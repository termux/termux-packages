
TESTS = test/*.js
REPORTER = spec

all:
	@node support/compile

clean:
	@rm -f dist/oath.js dist/oath.min.js

docs: clean-docs
	@./node_modules/.bin/codex build docs \
		--out docs/out
	@./node_modules/.bin/codex serve \
		--out docs/out --static /oath

clean-docs:
	@rm -rf docs/out

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(TESTS)

.PHONY: all clean-docs docs clean test
