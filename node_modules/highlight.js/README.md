# Highlight.js

Highlight.js is a node.js fork of [highlight.js](https://github.com/isagalaev/highlight.js) for the browser.

##Install

	npm install highlight.js

##Usage

###Auto Language Detection:

	var hl = require("highlight.js");
	var txt = "var test = 'asdf'";
	var html = hl.highlightAuto(txt);
	console.log(html.value);

###Pass in Language:

	var hl = require("highlight.js");
	var txt = "var test = 'asdf'";
	var html = hl.highlight('javascript', txt);
	console.log(html.value);

##Example Output:

&lt;span class="keyword"&gt;var&lt;/span&gt; test = &lt;span class="string"&gt;'asdf'&lt;/span&gt;
