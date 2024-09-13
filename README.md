# mojo-pytest

[![Run Tests](https://github.com/guidorice/mojo-pytest/actions/workflows/test.yml/badge.svg)](https://github.com/guidorice/mojo-pytest/actions/workflows/test.yml)

[Mojo🔥](https://github.com/modularml/mojo) language test runner plugin for [pytest](https://docs.pytest.org). Try it for
your mixed Python and Mojo codebases!

## Design

This package implements a `pytest` plugin to discover and run Mojo tests, alongside your Python tests. Although `pytest`
does not have any awareness of Mojo source or package structure, `pytest` is extensible. In summary, `plugin.py` calls
`mojo test` in a sub-process and parses the outputs and exit codes.

## Usage

1. Create your Mojo tests according to the manual: https://docs.modular.com/mojo/tools/testing .

2. Install `mojo`, `python`, `pytest` and `pytest-mojo` plugin using the [conda](https://docs.anaconda.com/miniconda/)
 [environment.yml](environment.yml) file. This can alternatively be done with the [magic](https://docs.modular.com/magic/)
 package manager, but [conda](https://docs.anaconda.com/miniconda/) is easier for this use case.

    ```shell
    # use conda to install mojo, python, and the pytest-mojo plugin.
    $ conda env -n foo-project create -f environment.yml

    # verify environment
    $ conda activate foo-project
    $ mojo --version
    mojo 24.5.0 (e8aacb95)
    $ python --version
    Python 3.12.6
    $ conda list pytest
    ...
    pytest                    8.3.3              pyhd8ed1ab_0    conda-forge
    pytest-mojo               24.5                     pypi_0    pypi
    pytest-xdist              3.6.1              pyhd8ed1ab_0    conda-forge
    ```

    Summary: it is a requirement is to have a `python` and `mojo` sharing the same runtime and packages and
    [conda](https://docs.anaconda.com/miniconda/) is the easiest way to accomplish that.

3. Create some tests. See the example project for one possible filesystem layout:
    - `example_src/` has it's tests in the `example_tests/` folder.
    - Remember the [Mojo manual](https://docs.modular.com/mojo/tools/testing) explains
    that tests are allowed to be in the same folder as Mojo code, or different folder, or even as Mojo code in
    docstrings! So this example project is just one possibility.
4. Mojo tests and Python tests are all run via `pytest`! Use the plugin's `--mojo-include` option to include your
   Mojo packages.

    ```shell
    # this example_src/ contains a Python package which is also called from Mojo,
    # so we must add it using PYTHONPATH. Please note that the full path may be required!
    $ export PYTHONPATH=/Users/you/project/example_src/

    # Use the plugin's --mojo-include option to tell mojo where to find `my_package` 
    $ pytest --mojo-include example_src/ example_tests/

    ================================ test session starts ================================
    platform darwin -- Python 3.12.6, pytest-8.3.3, pluggy-1.5.0
    rootdir: /Users/guidorice/mojo/mojo-pytest
    configfile: pyproject.toml
    plugins: mojo-24.5
    collected 6 items                                                                   

    example_tests/my_package/my_test.mojo .                                       [ 16%]
    example_tests/my_package/test_fibonacci.mojo ..                               [ 50%]
    example_tests/my_package/test_fibonacci.py .                                  [ 66%]
    example_tests/my_package/test_fire.🔥 .                                       [ 83%]
    example_tests/my_package/test_random_tensor.mojo .                            [100%]

    ================================ 6 passed in 13.55s =================================
    ```

    👆🏽 Notice how your Python tests are run alongside your mojo tests.

5. Mojo binary packages are also supported with `--mojo-include`. For example, this could be used in a CI/CD script:

    ```shell
    $ mojo package example_src/my_package -o build/my_package.mojopkg  # or .📦
    $ pytest --mojo-include build/ example_tests/
    ... 
    ... (same pytest output as above)
    ...
    ```


## Example Project

In the `example_src/` directory is a Mojo package with a couple of modules. There is also a Python module, which we call
in two ways (from `pytest`, and from Mojo). Here is an overview:

```shell
example_src
├── main.mojo                    # main entry point. run with `mojo example_src/main.mojo`
└── my_package
    ├── __init__.mojo            # this is both Mojo package, and a Python package.
    ├── __init__.py
    ├── fibonacci.mojo           # Mojo implementation
    ├── fibonacci.py             # Python implementation
    └── random_tensor.mojo       # random tensor stuff

example_tests
└── my_package
    ├── my_test.mojo             # files can be named xxx_test as well as test_xxx.
    ├── test_fibonacci.mojo      # tests the Mojo impl and the Python impl.
    ├── test_fibonacci.py        # tests the Python impl (pure Python).
    ├── test_fire.🔥             # tests are collected for fire extension too.
    └── test_random_tensor.mojo  # tests the Mojo impl.
```

## Links

- If you experience slowness, see this [tip about using multiprocessing]( https://github.com/guidorice/mojo-pytest/wiki#2024-07-17-here-is-a-performance-tip)
with pytest.
- Writing tests in Mojo: https://docs.modular.com/mojo/tools/testing
- Non-Python tests in `pytest`:  https://pytest.org/en/7.4.x/example/nonpython.html#non-python-tests
- C test runner: https://pytest-c-testrunner.readthedocs.io/
- Pytest docs: https://docs.pytest.org
