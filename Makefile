.PHONY: test

test:
	mojo --version

# check test collection (this count needs to be updated manually when tests are updated)
	pytest example/ | grep "collected 6 items"

# run tests for example_src/ project
	pytest --mojo-include example_src/ example_tests/
