.PHONY: test

test:
	pwd
	mojo --version

# run tests for example_src/ project (they should all pass)
	pytest --mojo-include example_src/ example_tests/ > pytest.out
	cat pytest.out
# check test collection (this count needs to be updated manually when tests are updated)
	grep "collected 6 items" pytest.out
