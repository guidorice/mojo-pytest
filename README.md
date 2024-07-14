# mojo-pytest

[![Run Tests](https://github.com/guidorice/mojo-pytest/actions/workflows/test.yml/badge.svg)](https://github.com/guidorice/mojo-pytest/actions/workflows/test.yml)

[mojo🔥](https://github.com/modularml/mojo) test runner plugin for [pytest](https://docs.pytest.org). Great for your
mixed Python and mojo codebases! 


## Design

This package implements a `pytest` plugin to discover and run mojo tests, alongside
your Python tests. Although `pytest` does not have any awareness of mojo source or package structure, `pytest` is
extensible. In summary, `plugin.py` calls `mojo test` in a sub-process and parses the outputs and exit codes.

## Usage

1. Create your mojo tests according to the manual: https://docs.modular.com/mojo/tools/testing .

2. Install `pytest` and `pytest-mojo` plugin into your project
    with `pip install git+https://github.com/guidorice/mojo-pytest.git`, or with the Conda
    [environment.yaml](./environment.yaml) (recommended)
    ```shell
    # conda installation example
    $ conda env create -f environment.yaml -p ./env
    $ conda activate ./env

    # verify pytest and the mojo plugin are installed
    $ pytest --version
    $ pip show pytest-mojo
    ...
    ```

3. See the [example_src/](./example_src/) folder for one possible filesystem layout:
    - `example_src/` has it's tests in the `example_test/` folder.
    - Remember that the [mojo manual](https://docs.modular.com/mojo/tools/testing) explains
    that tests are allowed to be in the same folder as mojo code, or different folder, or even as mojo code in
    docstrings! So this example project is just one possibility.
4. mojo tests and Python tests are all run via `pytest`! Use the plugin's `--mojo-include` option to discover your
   mojo packages. (Note, under the hoold this mojo's `-I` option).
    ```shell
    # this example_src/ contains a python package which is also called from mojo,
    # so we must add it using PYTHONPATH. Please note that the full path may be required!
    $ export PYTHONPATH=/Users/you/project/example_src/

    # Use the plugin's --mojo-include option to tell mojo where to find the mojo package `my_package` 
    $ pytest --mojo-include example_src/ example_tests/

    ================================ test session starts ================================
    platform darwin -- Python 3.12.4, pytest-8.2.2, pluggy-1.5.0
    rootdir: /Users/guidorice/mojo/mojo-pytest
    plugins: mojo-24.4.0
    collected 6 items                                                                   

    example_tests/my_package/my_test.mojo .                                       [ 16%]
    example_tests/my_package/test_fibonacci.mojo ..                               [ 50%]
    example_tests/my_package/test_fibonacci.py .                                  [ 66%]
    example_tests/my_package/test_fire.🔥 .                                       [ 83%]
    example_tests/my_package/test_random_tensor.mojo .                            [100%]

    ================================= 6 passed in 6.47s =================================
    ```
    👆🏽Notice how your Python tests are run alongside your mojo tests.

5. mojo packages are supported with `--mojo-include` (for example, could be used in a CI/CD script):

```shell
    $ mojo package example_src/my_package -o build/my_package.mojopkg  # note: 📦 works same as .mojopkg
    $ pytest --mojo-include build/ example_tests/
    ... 
    ... (same pytest output as above)
    ...
```

See also, the [pytest docs](https://docs.pytest.org) for many more options.

## Example Project

In the `example_src/` directory is a mojo package with a couple of modules. There is also a python module,
which we call in two ways (from pytest, and from mojo). Here is an overview:

```shell
example_src
├── main.mojo                   # main entry point. run with `mojo example_src/main.mojo`
└── my_package
    ├── __init__.mojo           # this is both mojo package, and a python package.
    ├── __init__.py
    ├── fibonacci.mojo           # mojo implementation
    ├── fibonacci.py             # python implementation
    └── random_tensor.mojo       # random tensor stuff

example_tests
└── my_package
    ├── my_test.mojo             # files can be named xxx_test as well as test_xxx.
    ├── test_fibonacci.mojo      # tests the mojo impl and the python impl.
    ├── test_fibonacci.py        # tests the python impl (pure python).
    ├── test_fire.🔥             # tests are collected for fire extension too.
    └── test_random_tensor.mojo  # tests the mojo impl.
```

## Links

- Writing tests in mojo: https://docs.modular.com/mojo/tools/testing .
- Non-python tests in pytest:  https://pytest.org/en/7.4.x/example/nonpython.html#non-python-tests
- C test runner: https://pytest-c-testrunner.readthedocs.io/
