from setuptools import find_packages, setup

setup(
    name="pytest-mojo",
    version="24.4.0",
    packages=find_packages(),
    entry_points={"pytest11": ["mojo = pytest_mojo.plugin"]},
    install_requires=["pytest"],
)
