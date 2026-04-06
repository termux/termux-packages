
TESTS = test/*.js
REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(TESTS)

docs: clean-docs
	@./bin/codex build docs \
		--out docs/out
	@./bin/codex serve \
		--out docs/out

clean-docs:
	@rm -rf docs/out

.PHONY: test clean-docs docs
