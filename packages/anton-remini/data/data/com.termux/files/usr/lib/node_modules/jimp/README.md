<div align="center">
  <img width="200" height="200"
    src="https://s3.amazonaws.com/pix.iemoji.com/images/emoji/apple/ios-11/256/crayon.png">
  <h1>Jimp</h1>
  <p>JavaScript Image Manipulation Program</p>
</div>

The "JavaScript Image Manipulation Program" :-)

An image processing library for Node written entirely in JavaScript, with zero native dependencies.

The default jimp configuration.

Supported types:

- `@jimp/jpeg`
- `@jimp/png`
- `@jimp/bmp`
- `@jimp/tiff`
- `@jimp/gif`

[Read the full docs.](http://jimp-dev.github.io/jimp/)

## Installation

```bash
npm install --save jimp
```

## Usage

```js
const { Jimp } = require("jimp");

// open a file called "lenna.png"
const image = await Jimp.read("test.png");

image.resize(256, 256); // resize

await image.write("test-small.jpg"); // save
```
