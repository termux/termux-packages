
all: test
	
test:
	@node spec/node.js
	
examples:
	@node examples/run.js examples/list.yml
	@node examples/run.js examples/list.nested.yml
	@node examples/run.js examples/hash.yml
	@node examples/run.js examples/config.yml
	@node examples/run.js examples/dates.yml
	
.PHONY: test examples
