# mojo-pytest

[Mojo🔥](https://github.com/modularml/mojo)  test runner using [pytest](https://docs.pytest.org).

## Design

This example project implements a `pytest` hook to discover and run Mojo tests. Although `pytest` does not have any
awareness of Mojo source or package structure, `pytest` is extensible. By following a convention, you can use `pytest`
to run Mojo tests and view results. In summary, `conftest.py` calls `mojo run` in a sub-process and parses the outputs
and exit codes.

## Convention

- Create Mojo package directory in your project root.
- Anywhere in the Mojo package create source files prefixed with `test_`, ex: `test_something.mojo` or `test_xyz.🔥`.
  - Each test file must have a `main` entry point function.
  - Each `main` function may call arbitrary functions and methods in your Mojo package.
  - Each test item must print a line with it's test name, prefixed with `#` (hashtag, comment) character, ex: `# test name`.
  - Failed tests must raise Mojo `Error`. A helper function for assertions is in `example/tests/util.mojo`.
- Mojo compiler warnings may optionally be handled as test failures, using the `pytest -W error` mode.

## Usage

1. Install `pytest` >= 7.4 in your Python environment.
2. Install `pytest-mojo` plugin with  `pip install git+https://github.com/guidorice/mojo-pytest.git`, or with the Conda
  [environment.yaml](./environment.yaml).
3. Use the project layout described in here.
4. Run `pytest` from your project root. [See also pytest docs](https://docs.pytest.org). Examples:

```shell
# summary
pytest

# details
pytest -v

# mojo warnings treated as errors
pytest -W error

# show all captured stdout
pytest -s

```

## Example Project

In the `example/` directory is a Mojo package with a couple of modules. Note: in every subdirectory also exists an
`__init__.mojo` file, not shown here:

```shell
conftest.py
example/
├── mod_a
│   └── impl.mojo
├── mod_b
│   └── impl.mojo
└── tests
    ├── mod_a
    │   ├── test_convert.mojo
    │   ├── test_convert_different.mojo
    │   └── test_maths.mojo
    ├── mod_b
    │   └── test_greet.mojo
    └── util.mojo
```

```text
$ pytest
======================================== test session starts =========================================
platform darwin -- Python 3.11.5, pytest-7.4.0, pluggy-1.0.0
rootdir: /Users/guidorice/mojo/mojo-pytest
plugins: mojo-0.1.0
collected 9 items                                                                                    

example/tests/test_warning.mojo .                                                              [ 11%]
example/tests/mod_a/test_convert.mojo .                                                        [ 22%]
example/tests/mod_a/test_convert_different.mojo .                                              [ 33%]
example/tests/mod_a/test_maths.mojo ....F                                                      [ 88%]
example/tests/mod_b/test_greet.mojo .                                                          [100%]

============================================== FAILURES ==============================================
__________________________________________ # maths more: 42 __________________________________________
(<MojoTestItem # maths more: 42>, 'Unhandled exception caught during execution: bad maths: 42')
====================================== short test summary info =======================================
FAILED example/tests/mod_a/test_maths.mojo::# maths more: 42
==================================== 1 failed, 8 passed in 0.33s =====================================
```

## Links

- Non-python tests in pytest:  https://pytest.org/en/7.4.x/example/nonpython.html#non-python-tests
- C test runner: https://pytest-c-testrunner.readthedocs.io/
