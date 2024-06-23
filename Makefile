.PHONY: test

test:
	mojo --version

# check test collection (this count needs to be updated manually when tests are updated)
	pytest example/ | grep "collected 18 items"

# Tests that do not fail
	pytest example/tests/mod_b

# Tests that should fail
	pytest example/tests/mod_a ; \
		if [ $$? -eq 0 ]; then \
			echo "expected pytest non-zero exit code"; \
			exit 1; \
		fi

# Test should fail because I am passing options for checking warnings
	pytest -W error example/tests/test_warning.mojo; \
		if [ $$? -eq 0 ]; then \
			echo "expected pytest non-zero exit code"; \
			exit 1; \
		fi

# Test should not fail because I am not checking for warnings
	pytest example/tests/test_warning.mojo

# Test should fail because --mojo-assertions is enabled
	pytest --mojo-assertions example/tests/test_debug_assert.mojo ; \
		if [ $$? -eq 0 ]; then \
			echo "expected pytest non-zero exit code"; \
			exit 1; \
		fi

# Test should not fail because I am not checking for debug assertions
	pytest example/tests/test_debug_assert.mojo
