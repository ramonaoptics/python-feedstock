About python-feedstock
======================

Feedstock license: [BSD-3-Clause](https://github.com/ramonaoptics/python-feedstock/blob/main/LICENSE.txt)

Home: https://www.python.org/

Package license: Python-2.0

Summary: General purpose programming language

Development: https://docs.python.org/devguide/

Documentation: https://www.python.org/doc/versions/

Python is a widely used high-level, general-purpose, interpreted, dynamic
programming language. Its design philosophy emphasizes code
readability, and its syntax allows programmers to express concepts in
fewer lines of code than would be possible in languages such as C++ or
Java. The language provides constructs intended to enable clear programs
on both a small and large scale.


Current build status
====================


<table>
    
  <tr>
    <td>Azure</td>
    <td>
      <details>
        <summary>
          <a href="https://dev.azure.com/ramonaoptics/feedstock-builds/_build/latest?definitionId=None&branchName=main">
            <img src="https://dev.azure.com/ramonaoptics/feedstock-builds/_apis/build/status/python-feedstock?branchName=main">
          </a>
        </summary>
        <table>
          <thead><tr><th>Variant</th><th>Status</th></tr></thead>
          <tbody><tr>
              <td>linux_64_build_typedebugchannel_targetsramonaoptics_python_debug</td>
              <td>
                <a href="https://dev.azure.com/ramonaoptics/feedstock-builds/_build/latest?definitionId=None&branchName=main">
                  <img src="https://dev.azure.com/ramonaoptics/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typedebugchannel_targetsramonaoptics_python_debug" alt="variant">
                </a>
              </td>
            </tr><tr>
              <td>linux_64_build_typereleasechannel_targetsramonaoptics_main</td>
              <td>
                <a href="https://dev.azure.com/ramonaoptics/feedstock-builds/_build/latest?definitionId=None&branchName=main">
                  <img src="https://dev.azure.com/ramonaoptics/feedstock-builds/_apis/build/status/python-feedstock?branchName=main&jobName=linux&configuration=linux%20linux_64_build_typereleasechannel_targetsramonaoptics_main" alt="variant">
                </a>
              </td>
            </tr>
          </tbody>
        </table>
      </details>
    </td>
  </tr>
</table>

Current release info
====================

| Name | Downloads | Version | Platforms |
| --- | --- | --- | --- |
| [![Conda Recipe](https://img.shields.io/badge/recipe-cpython-green.svg)](https://anaconda.org/ramonaoptics/cpython) | [![Conda Downloads](https://img.shields.io/conda/dn/ramonaoptics/cpython.svg)](https://anaconda.org/ramonaoptics/cpython) | [![Conda Version](https://img.shields.io/conda/vn/ramonaoptics/cpython.svg)](https://anaconda.org/ramonaoptics/cpython) | [![Conda Platforms](https://img.shields.io/conda/pn/ramonaoptics/cpython.svg)](https://anaconda.org/ramonaoptics/cpython) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-libpython--static-green.svg)](https://anaconda.org/ramonaoptics/libpython-static) | [![Conda Downloads](https://img.shields.io/conda/dn/ramonaoptics/libpython-static.svg)](https://anaconda.org/ramonaoptics/libpython-static) | [![Conda Version](https://img.shields.io/conda/vn/ramonaoptics/libpython-static.svg)](https://anaconda.org/ramonaoptics/libpython-static) | [![Conda Platforms](https://img.shields.io/conda/pn/ramonaoptics/libpython-static.svg)](https://anaconda.org/ramonaoptics/libpython-static) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python-green.svg)](https://anaconda.org/ramonaoptics/python) | [![Conda Downloads](https://img.shields.io/conda/dn/ramonaoptics/python.svg)](https://anaconda.org/ramonaoptics/python) | [![Conda Version](https://img.shields.io/conda/vn/ramonaoptics/python.svg)](https://anaconda.org/ramonaoptics/python) | [![Conda Platforms](https://img.shields.io/conda/pn/ramonaoptics/python.svg)](https://anaconda.org/ramonaoptics/python) |
| [![Conda Recipe](https://img.shields.io/badge/recipe-python--gil-green.svg)](https://anaconda.org/ramonaoptics/python-gil) | [![Conda Downloads](https://img.shields.io/conda/dn/ramonaoptics/python-gil.svg)](https://anaconda.org/ramonaoptics/python-gil) | [![Conda Version](https://img.shields.io/conda/vn/ramonaoptics/python-gil.svg)](https://anaconda.org/ramonaoptics/python-gil) | [![Conda Platforms](https://img.shields.io/conda/pn/ramonaoptics/python-gil.svg)](https://anaconda.org/ramonaoptics/python-gil) |

Installing python
=================

Installing `python` from the `ramonaoptics` channel can be achieved by adding `ramonaoptics` to your channels with:

```
conda config --add channels ramonaoptics
conda config --set channel_priority strict
```

How to use
----------

<details>
<summary>With conda</summary>

```
conda install cpython libpython-static python python-gil
```

</details>

<details>
<summary>With mamba</summary>

```
mamba install cpython libpython-static python python-gil
```

</details>

<details>
<summary>With pixi</summary>

```
# for adding to your local project
pixi add cpython libpython-static python python-gil
# for installing globally
pixi global install cpython libpython-static python python-gil
```

</details>

Search package versions
-----------------------

It is possible to list all of the versions of `cpython` available on your platform:

<details>
<summary>With conda</summary>

```
conda search cpython --channel ramonaoptics
```

</details>

<details>
<summary>With mamba</summary>

```
mamba search cpython --channel ramonaoptics
```

</details>

<details>
<summary>With pixi</summary>

```
pixi search cpython --channel ramonaoptics
```

</details>

<details>
<summary>With mamba repoquery, which may provide more information</summary>

```
# Search all versions available on your platform:
mamba repoquery search cpython --channel ramonaoptics

# List packages depending on `cpython`:
mamba repoquery whoneeds cpython --channel ramonaoptics

# List dependencies of `cpython`:
mamba repoquery depends cpython --channel ramonaoptics
```

</details>




Updating python-feedstock
=========================

If you would like to improve the python recipe or build a new
package version, please fork this repository and submit a PR. Upon submission,
your changes will be run on the appropriate platforms to give the reviewer an
opportunity to confirm that the changes result in a successful build. Once
merged, the recipe will be re-built and uploaded automatically to the
`ramonaoptics` channel, whereupon the built conda packages will be available for
everybody to install and use from the `ramonaoptics` channel.
Note that all branches in the ramonaoptics/python-feedstock are
immediately built and any created packages are uploaded, so PRs should be based
on branches in forks, and branches in the main repository should only be used to
build distinct package versions.

In order to produce a uniquely identifiable distribution:
 * If the version of a package **is not** being increased, please add or increase
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string).
 * If the version of a package **is** being increased, please remember to return
   the [``build/number``](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#build-number-and-string)
   back to 0.

Feedstock Maintainers
=====================

* [@chrisburr](https://github.com/chrisburr/)
* [@isuruf](https://github.com/isuruf/)
* [@jakirkham](https://github.com/jakirkham/)
* [@katietz](https://github.com/katietz/)
* [@mbargull](https://github.com/mbargull/)
* [@mingwandroid](https://github.com/mingwandroid/)
* [@msarahan](https://github.com/msarahan/)
* [@ocefpaf](https://github.com/ocefpaf/)
* [@pelson](https://github.com/pelson/)
* [@scopatz](https://github.com/scopatz/)
* [@xhochy](https://github.com/xhochy/)

