#!/usr/bin/env bash

# INPUTS (environment variables that need to be set before calling this script):
#
# CI (azure/github_actions/UNSET)
# CI_RUN_ID (unique identifier for the CI job run)
# CONFIG (build matrix configuration string)
# FEEDSTOCK_NAME
# ARTIFACT_STAGING_DIR (use working directory if unset)
# BLD_ARTIFACT_PREFIX (prefix for the conda build artifact name, skip if unset)
# ENV_ARTIFACT_PREFIX (prefix for the conda build environments artifact name, skip if unset)

# OUTPUTS
#
# BLD_ARTIFACT_NAME
# BLD_ARTIFACT_PATH
# ENV_ARTIFACT_NAME
# ENV_ARTIFACT_PATH

source .scripts/logging_utils.sh

# DON'T do set -x, because it results in double echo-ing pipeline commands
# and that might end up inserting extraneous quotation marks in output variables
set -e

if [[ -d ${MINIFORGE_HOME} ]]; then
    . "${MINIFORGE_HOME}/etc/profile.d/conda.sh"
    conda activate
fi

# Check that the conda-build directory exists
if [ ! -d "$CONDA_BLD_PATH" ]; then
    echo "conda-build directory does not exist"
    exit 1
fi

# Set staging dir to the working dir, in Windows style if applicable
if [[ -z "${ARTIFACT_STAGING_DIR}" ]]; then
    if pwd -W; then
        ARTIFACT_STAGING_DIR=$(pwd -W)
    else
        ARTIFACT_STAGING_DIR=$PWD
    fi
fi
echo "ARTIFACT_STAGING_DIR: $ARTIFACT_STAGING_DIR"

FEEDSTOCK_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
if [ -z ${FEEDSTOCK_NAME} ]; then
    export FEEDSTOCK_NAME=$(basename ${FEEDSTOCK_ROOT})
fi

# Set a unique ID for the artifact(s), specialized for this particular job run
ARTIFACT_UNIQUE_ID="${CI_RUN_ID}_${CONFIG}"
if [[ ${#ARTIFACT_UNIQUE_ID} -gt 80 ]]; then
    ARTIFACT_UNIQUE_ID="${CI_RUN_ID}_${CONFIG_SHORT}"
fi
echo "ARTIFACT_UNIQUE_ID: $ARTIFACT_UNIQUE_ID"

# Set a descriptive ID for the archive(s), specialized for this particular job run
ARCHIVE_UNIQUE_ID="${CI_RUN_ID}_${CONFIG}"

pushd "${CONDA_BLD_PATH}"

ZSTD="--use-compress-prog=zstd -T0 -12"


shopt -s nullglob
ARTIFACT_PATHS=(
    linux-*
    osx-*
    win-*

    broken*
    noarch*
    channeldata.json*
    index.html*
)
ENVIRONMENT_PATHS=(
    ./*_*/*_env*
    ./*_*/*_prefix_moved_*

    ./bld/*_*/*_env*
    ./test/test_*/test_env
)

EXCLUDE_FROM_WORK=(
    .git

    ./pkg_cache
    ./src_cache
    ./*_*/pip_cache

    "${ARTIFACT_PATHS[@]}"
    "${ENVIRONMENT_PATHS[@]}"
)

if [[ ! -z ${BLD_ARTIFACT_PREFIX} && -n ${ARTIFACT_PATHS} ]]; then
    echo "Creating build artifact archive ..."
    export BLD_ARTIFACT_NAME="${BLD_ARTIFACT_PREFIX}_${ARTIFACT_UNIQUE_ID}"
    export BLD_ARTIFACT_PATH="${ARTIFACT_STAGING_DIR}/${FEEDSTOCK_NAME}_${BLD_ARTIFACT_PREFIX}_${ARCHIVE_UNIQUE_ID}.tar.zst"

    if ! tar -c -f "${BLD_ARTIFACT_PATH}" "${ZSTD}" "${ARTIFACT_PATHS[@]}" &&
        [[ -s ${BLD_ARTIFACT_PATH} ]]
    then
        mv -v "${BLD_ARTIFACT_PATH}" "${BLD_ARTIFACT_PATH/%.tar.zst/-broken&}"
        BLD_ARTIFACT_NAME+=-broken
        BLD_ARTIFACT_PATH=${BLD_ARTIFACT_PATH/%.tar.zst/-broken&}
    fi

    if [[ -s ${BLD_ARTIFACT_PATH} ]]; then
        echo "Archive created:"
        ls -l -h "${BLD_ARTIFACT_PATH}"

        if [[ "$CI" == "azure" ]]; then
            echo "##vso[task.setVariable variable=BLD_ARTIFACT_NAME]$BLD_ARTIFACT_NAME"
            echo "##vso[task.setVariable variable=BLD_ARTIFACT_PATH]$BLD_ARTIFACT_PATH"
        elif [[ "$CI" == "github_actions" ]]; then
            echo "BLD_ARTIFACT_NAME=$BLD_ARTIFACT_NAME" >> $GITHUB_OUTPUT
            echo "BLD_ARTIFACT_PATH=$BLD_ARTIFACT_PATH" >> $GITHUB_OUTPUT
        fi
    else
        echo "No archive created"
    fi
else
    echo "Skipping build artifact archive"
fi
echo

if [[ ! -z ${WRK_ARTIFACT_PREFIX} ]]; then
    echo "Creating work directory archive ..."
    export WRK_ARTIFACT_NAME="${WRK_ARTIFACT_PREFIX}_${ARTIFACT_UNIQUE_ID}"
    export WRK_ARTIFACT_PATH="${ARTIFACT_STAGING_DIR}/${FEEDSTOCK_NAME}_${WRK_ARTIFACT_PREFIX}_${ARCHIVE_UNIQUE_ID}.tar.zst"

    if ! tar -c -f "${WRK_ARTIFACT_PATH}" "${ZSTD}" \
            "${EXCLUDE_FROM_WORK[@]/#/--exclude=}" . &&
        [[ -s ${WRK_ARTIFACT_PATH} ]]
    then
        mv -v "${WRK_ARTIFACT_PATH}" "${WRK_ARTIFACT_PATH/%.tar.zst/-broken&}"
        WRK_ARTIFACT_NAME+=-broken
        WRK_ARTIFACT_PATH=${WRK_ARTIFACT_PATH/%.tar.zst/-broken&}
    fi

    if [[ -s ${WRK_ARTIFACT_PATH} ]]; then
        echo "Archive created:"
        ls -l -h "${WRK_ARTIFACT_PATH}"

        if [[ "$CI" == "azure" ]]; then
            echo "##vso[task.setVariable variable=WRK_ARTIFACT_NAME]$WRK_ARTIFACT_NAME"
            echo "##vso[task.setVariable variable=WRK_ARTIFACT_PATH]$WRK_ARTIFACT_PATH"
        elif [[ "$CI" == "github_actions" ]]; then
            echo "WRK_ARTIFACT_NAME=$WRK_ARTIFACT_NAME" >> $GITHUB_OUTPUT
            echo "WRK_ARTIFACT_PATH=$WRK_ARTIFACT_PATH" >> $GITHUB_OUTPUT
        fi
    else
        echo "No archive created"
    fi
else
    echo "Skipping work directory artifact archive"
fi
echo

if [[ ! -z ${ENV_ARTIFACT_PREFIX} && -n ${ENVIRONMENT_PATHS[@]} ]]; then
    echo "Creating build environment artifact archive ..."
    export ENV_ARTIFACT_NAME="${ENV_ARTIFACT_PREFIX}_${ARTIFACT_UNIQUE_ID}"
    export ENV_ARTIFACT_PATH="${ARTIFACT_STAGING_DIR}/${FEEDSTOCK_NAME}_${ENV_ARTIFACT_PREFIX}_${ARCHIVE_UNIQUE_ID}.tar.zst"

    if ! tar -c -f "${ENV_ARTIFACT_PATH}" "${ZSTD}" "${ENVIRONMENT_PATHS[@]}" &&
        [[ -s ${ENV_ARTIFACT_PATH} ]]
    then
        mv -v "${ENV_ARTIFACT_PATH}" "${ENV_ARTIFACT_PATH/%.tar.zst/-broken&}"
        ENV_ARTIFACT_NAME+=-broken
        ENV_ARTIFACT_PATH=${ENV_ARTIFACT_PATH/%.tar.zst/-broken&}
    fi

    if [[ -s ${ENV_ARTIFACT_PATH} ]]; then
        echo "Archive created:"
        ls -l -h "${ENV_ARTIFACT_PATH}"

        if [[ "$CI" == "azure" ]]; then
            echo "##vso[task.setVariable variable=ENV_ARTIFACT_NAME]$ENV_ARTIFACT_NAME"
            echo "##vso[task.setVariable variable=ENV_ARTIFACT_PATH]$ENV_ARTIFACT_PATH"
        elif [[ "$CI" == "github_actions" ]]; then
            echo "ENV_ARTIFACT_NAME=$ENV_ARTIFACT_NAME" >> $GITHUB_OUTPUT
            echo "ENV_ARTIFACT_PATH=$ENV_ARTIFACT_PATH" >> $GITHUB_OUTPUT
        fi
    else
        echo "No archive created"
    fi
else
    echo "Skipping environment artifact archive"
fi
echo

popd
