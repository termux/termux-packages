# Dox

 Dox is a JavaScript documentation generator written with [node](http://nodejs.org). Dox no longer generates an opinionated structure or style for your docs, it simply gives you a JSON representation, allowing you to use _markdown_ and _JSDoc_-style tags.

## Installation

Install from npm:

    $ npm install -g dox

## Usage Examples

`dox(1)` operates over stdio:

    $ dox < utils.js
    ...JSON... 

 to inspect the generated data you can use the `--debug` flag, which is easier to read than the JSON output:
 
     $ dox --debug < utils.js 

utils.js:

```js
/**
 * Escape the given `html`.
 *
 * Examples:
 *
 *     utils.escape('<script></script>')
 *     // => '&lt;script&gt;&lt;/script&gt;'
 *
 * @param {String} html string to be escaped
 * @return {String} escaped html
 * @api public
 */

exports.escape = function(html){
  return String(html)
    .replace(/&(?!\w+;)/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
};
```

output:

```json
[
  {
    "tags": [
      {
        "type": "param",
        "types": [
          "String"
        ],
        "name": "html",
        "description": "string to be escaped"
      },
      {
        "type": "return",
        "types": [
          "String"
        ],
        "description": "escaped html"
      },
      {
        "type": "api",
        "visibility": "public"
      }
    ],
    "description": {
      "full": "<p>Escape the given <code>html</code>.</p>\n\n<h2>Examples</h2>\n\n<pre><code>utils.escape('&amp;lt;script&amp;gt;&amp;lt;/script&amp;gt;')\n// =&amp;gt; '&amp;lt;script&amp;gt;&amp;lt;/script&amp;gt;'\n</code></pre>",
      "summary": "<p>Escape the given <code>html</code>.</p>",
      "body": "<h2>Examples</h2>\n\n<pre><code>utils.escape('&amp;lt;script&amp;gt;&amp;lt;/script&amp;gt;')\n// =&amp;gt; '&amp;lt;script&amp;gt;&amp;lt;/script&amp;gt;'\n</code></pre>"
    },
    "isPrivate": false,
    "ignore": false,
    "code": "exports.escape = function(html){\n  return String(html)\n    .replace(/&(?!\\w+;)/g, '&amp;')\n    .replace(/</g, '&lt;')\n    .replace(/>/g, '&gt;');\n};",
    "ctx": {
      "type": "method",
      "receiver": "exports",
      "name": "escape",
      "string": "exports.escape()"
    }
  }
]
```

This output can then be passed to a template for rendering. Look below at the "Properties" section for details.

## Usage

```

Usage: dox [options]

Options:

  -h, --help     output usage information
  -v, --version  output the version number
  -d, --debug    output parsed comments for debugging

Examples:

  # stdin
  $ dox > myfile.json

  # operates over stdio
  $ dox < myfile.js > myfile.json

```

## Properties

  A "comment" is comprised of the following detailed properties:
  
    - tags
    - description
    - isPrivate
    - ignore
    - code
    - ctx

### Description

  A dox description is comprised of three parts, the "full" description,
  the "summary", and the "body". The following example has only a "summary",
  as it consists of a single paragraph only, therefore the "full" property has
  only this value as well.

```js
/**
 * Output the given `str` to _stdout_.
 */

exports.write = function(str) {
  process.stdout.write(str);
};
````
yields:

```js
description: 
     { full: '<p>Output the given <code>str</code> to <em>stdout</em>.</p>',
       summary: '<p>Output the given <code>str</code> to <em>stdout</em>.</p>',
       body: '' },
```

  Large descriptions might look something like the following, where the "summary" is still the first paragraph, the remaining description becomes the "body". Keep in mind this _is_ markdown, so you can indent code, use lists, links, etc. Dox also augments markdown, allowing "Some Title:\n" to form a header.

```js
/**
 * Output the given `str` to _stdout_
 * or the stream specified by `options`.
 * 
 * Options:
 * 
 *   - `stream` defaulting to _stdout_
 * 
 * Examples:
 * 
 *     mymodule.write('foo')
 *     mymodule.write('foo', { stream: process.stderr })
 * 
 */

exports.write = function(str, options) {
  options = options || {};
  (options.stream || process.stdout).write(str);
};
```

yields:

```js
description: 
     { full: '<p>Output the given <code>str</code> to <em>stdout</em><br />or the stream specified by <code>options</code>.</p>\n\n<h2>Options</h2>\n\n<ul>\n<li><code>stream</code> defaulting to <em>stdout</em></li>\n</ul>\n\n<h2>Examples</h2>\n\n<pre><code>mymodule.write(\'foo\')\nmymodule.write(\'foo\', { stream: process.stderr })\n</code></pre>',
       summary: '<p>Output the given <code>str</code> to <em>stdout</em><br />or the stream specified by <code>options</code>.</p>',
       body: '<h2>Options</h2>\n\n<ul>\n<li><code>stream</code> defaulting to <em>stdout</em></li>\n</ul>\n\n<h2>Examples</h2>\n\n<pre><code>mymodule.write(\'foo\')\nmymodule.write(\'foo\', { stream: process.stderr })\n</code></pre>' }
```

### Tags

  Dox also supports JSdoc-style tags. Currently only __@api__ is special-cased, providing the `comment.isPrivate` boolean so you may omit "private" utilities etc.

```js

/**
 * Output the given `str` to _stdout_
 * or the stream specified by `options`.
 * 
 * @param {String} str
 * @param {Object} options
 * @return {Object} exports for chaining
 */

exports.write = function(str, options) {
  options = options || {};
  (options.stream || process.stdout).write(str);
  return this;
};
```

yields:

```js
tags: 
   [ { type: 'param',
       types: [ 'String' ],
       name: 'str',
       description: '' },
     { type: 'param',
       types: [ 'Object' ],
       name: 'options',
       description: '' },
     { type: 'return',
       types: [ 'Object' ],
       description: 'exports for chaining' },
     { type: 'api',
       visibility: 'public' } ]
```

### Code

 The `.code` property is the code following the comment block, in our previous examples:

```js
exports.write = function(str, options) {
  options = options || {};
  (options.stream || process.stdout).write(str);
  return this;
};
```

### Ctx

  The `.ctx` object indicates the context of the code block, is it a method, a function, a variable etc. Below are some examples:

```js
exports.write = function(str, options) {
};
```

yields:

```js
ctx: 
 { type: 'method',
   receiver: 'exports',
   name: 'write',
   string: 'exports.write()' } }
```

```js
var foo = 'bar';
```

yields:

```js
ctx: 
 { type: 'declaration',
   name: 'foo',
   value: '\'bar\'',
   string: 'foo' }
```

```js
function User() {
  
}
```

yields:

```js
ctx: 
 { type: 'function',
   name: 'User',
   string: 'User()' } }
```

### Ignore

Comments and their associated bodies of code may be flagged with "!" to be considered worth ignoring, these are typically things like file comments containing copyright etc, however you of course can output them in your templates if you want.

```
/**
 * Not ignored.
 */
```

vs

```
/*!
 * Ignored.
 */
```

### Running tests

 Install dev dependencies and execute `make test`:
 
     $ npm install -d
     $ make test

## License 

(The MIT License)

Copyright (c) 2011 TJ Holowaychuk &lt;tj@vision-media.ca&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.