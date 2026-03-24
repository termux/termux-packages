
TESTS = test/*.js
REPORTER = dot
BENCHMARKS = benchmarks/*.js

all:
	@node support/compile

clean:
	@rm -f dist/drip.js dist/drip.min.js

docs: clean-docs
	@./node_modules/.bin/codex build docs \
		--out docs/out
	@./node_modules/.bin/codex serve \
		--out docs/out --static /drip

clean-docs:
	@rm -rf docs/out

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(TESTS)

benchmark:
	@./node_modules/.bin/matcha $(BENCHMARKS)

.PHONY: all clean-docs docs clean test benchmark