.PHONY: build check lint test

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

lint test build: check

check:
	@python3 -m unittest discover -s "$(ROOT)/tests" -p 'test_*.py'
	@python3 "$(ROOT)/scripts/check_repository_policy.py" "$(ROOT)"
	@"$(ROOT)/scripts/check-baseline.sh"
