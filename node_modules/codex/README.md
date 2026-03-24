# Codex

> Generate static websites using Markdown, Jade, and Stylus.

Codex is a simple tool for building static webites. It takes a template constructed in
[Jade](http://github.com/visionmedia/jade) and themed in [Stylus](http://github.com/learnboost/stylus),
and applies it to a collection of Markdown documents. The result is a complete html site
that can be hosted using your favorite webserver, or on github-pages. 

### Features

* Skeleton project template
* Command-line or API based project configuration and building
* Plugin based loading system for advanced features
* Includes `code` plugin for generating document sites for javascript/node.js projects.

### Sites by Codex

* [Chaijs.com](http://chaijs.com) - Chai is an assertion library for javascript projects. It's
documentation was built by Codex and uses the `code` plugin extensively.

## Installation

You can install Codex through npm. Global installation is recommended for new projects.

      $ [sudo] npm install codex -g

## First Project

```sh
codex skeleton my-project
cd my-project
codex watch -p 1227
```

Using the `watch` command will automatically regenerate your site every time codex detects
a change in either your template or data folders.

## CLI Usage

There are a number of options available for the command line interface...

![Codex CLI](http://f.cl.ly/items/06212s342p2G0d0l2v0p/codex-help.png)

## Code Plugin

... coming soon

## Getting Help

Please post issues or questions to [Github Issues](http://github.com/logicalparadox/codex/issues). 

## License

(The MIT License)

Copyright (c) 2011 Jake Luer

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
