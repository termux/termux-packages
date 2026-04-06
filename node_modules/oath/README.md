[![Build Status](https://secure.travis-ci.org/logicalparadox/oath.png)](http://travis-ci.org/logicalparadox/oath)

# Oath

Oath is a tiny javascript library for [node](http://nodejs.org) and the browser that makes
it easy to build and interact with promise/future based APIs.

## What is a future/promise anyway?

A future (or promise), is an alternative method to callbacks when working with asyncronous
code. For more information check out the very information Wikipedia article
on [Futures and Promises](http://en.wikipedia.org/wiki/Futures_and_promises).

## About version 0.2.x

Version 0.2.x and the master branch represent a shift in oath's core fucus. Instead of providing helper
functions for manipulating the result set and deep chaining, this version allows you to manipulate the
result set directly, and provides helpers if this is to be done asyncronously. Docs coming shortly.

## Installation

Oath is available for both server-side and the browser.

### Node.js

Package is available through [npm](http://npmjs.org):

    npm install oath

### Browser

Download the package and include either the normal or minimized build in your HTML header.

    <script src="/public/js/oath.js" type="text/javascript"></script>
    <script src="/public/js/oath.min.js" type="text/javascript"></script>

## Help, resources, and issues?

* The annotated source / full API documentation for versions 0.1.x is available at [alogicalparadox.com/oath](http://alogicalparadox.com/oath/).
* If you have questions or issues, please use this projects [Github Issues](https://github.com/logicalparadox/oath/issues).

## Contributors

Interested in contributing? Fork to get started. Contact [@logicalparadox](http://github.com/logicalparadox) if you are interested in being a regular contributor.

* Jake Luer [[Github: @logicalparadox](http://github.com/logicalparadox)] [[Twitter: @jakeluer](http://twitter.com/jakeluer)] [[Website](http://alogicalparadox.com)]

## License

(The MIT License)

Copyright (c) 2011 Jake Luer <jake@alogicalparadox.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.