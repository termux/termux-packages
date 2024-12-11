/**
 * @module jimp
 */
// import { Jimp } from "@jimp/core";
import bmp, { msBmp } from "@jimp/js-bmp";
import gif from "@jimp/js-gif";
import jpeg from "@jimp/js-jpeg";
import png from "@jimp/js-png";
import tiff from "@jimp/js-tiff";
import * as blit from "@jimp/plugin-blit";
import * as blur from "@jimp/plugin-blur";
import * as circle from "@jimp/plugin-circle";
import * as color from "@jimp/plugin-color";
import * as contain from "@jimp/plugin-contain";
import * as cover from "@jimp/plugin-cover";
import * as crop from "@jimp/plugin-crop";
import * as displace from "@jimp/plugin-displace";
import * as dither from "@jimp/plugin-dither";
import * as fisheye from "@jimp/plugin-fisheye";
import * as flip from "@jimp/plugin-flip";
import * as hash from "@jimp/plugin-hash";
import * as mask from "@jimp/plugin-mask";
import * as print from "@jimp/plugin-print";
import * as resize from "@jimp/plugin-resize";
import * as rotate from "@jimp/plugin-rotate";
import * as threshold from "@jimp/plugin-threshold";
import * as quantize from "@jimp/plugin-quantize";
import { createJimp } from "@jimp/core";
export const defaultPlugins = [
    blit.methods,
    blur.methods,
    circle.methods,
    color.methods,
    contain.methods,
    cover.methods,
    crop.methods,
    displace.methods,
    dither.methods,
    fisheye.methods,
    flip.methods,
    hash.methods,
    mask.methods,
    print.methods,
    resize.methods,
    rotate.methods,
    threshold.methods,
    quantize.methods,
];
export const defaultFormats = [bmp, msBmp, gif, jpeg, png, tiff];
/** Convenience object for getting the MIME types of the default formats */
export const JimpMime = {
    bmp: bmp().mime,
    gif: gif().mime,
    jpeg: jpeg().mime,
    png: png().mime,
    tiff: tiff().mime,
};
// TODO: This doesn't document the constructor of the class
/**
 * @class
 *
 * A `Jimp` class enables you to:class
 *
 * - Read an image into a "bit map" (a collection of pixels)
 * - Modify the bit map through methods that change the pixels
 * - Write the bit map back to an image buffer
 *
 * @example
 *
 * #### Basic
 *
 * You can use the Jimp class to make empty images.
 * This is useful for when you want to create an image that composed of other images on top of a background.
 *
 * ```ts
 * import { Jimp } from "jimp";
 *
 * const image = new Jimp({ width: 256, height: 256, color: 0xffffffff });
 * const image2 = new Jimp({ width: 100, height: 100, color: 0xff0000ff });
 *
 * image.composite(image2, 50, 50);
 * ```
 *
 * #### Node
 *
 * You can use jimp in Node.js.
 * For example you can read an image from a file and resize it and
 * then write it back to a file.
 *
 * ```ts
 * import { Jimp } from "jimp";
 * import { promises as fs } from "fs";
 *
 * const image = await Jimp.read("test/image.png");
 *
 * image.resize(256, 100);
 * image.greyscale();
 *
 * await image.write('test/output.png');
 * ```
 *
 * #### Browser
 *
 * You can use jimp in the browser by reading files from URLs
 *
 * ```ts
 * import { Jimp } from "jimp";
 *
 * const image = await Jimp.read("https://upload.wikimedia.org/wikipedia/commons/0/01/Bot-Test.jpg");
 *
 * image.resize(256, 100);
 * image.greyscale();
 *
 * const output = await image.getBuffer("test/image.png");
 *
 * const canvas = document.createElement("canvas");
 *
 * canvas.width = image.bitmap.width;
 * canvas.height = image.bitmap.height;
 *
 * const ctx = canvas.getContext("2d");
 * ctx.putImageData(image.bitmap, 0, 0);
 *
 * document.body.appendChild(canvas);
 * ```
 */
export const Jimp = createJimp({
    formats: defaultFormats,
    plugins: defaultPlugins,
});
export { ResizeStrategy } from "@jimp/plugin-resize";
export { distance, compareHashes } from "@jimp/plugin-hash";
export { PNGColorType, PNGFilterType } from "@jimp/js-png";
export { BmpCompression } from "@jimp/js-bmp";
export { HorizontalAlign, VerticalAlign, BlendMode } from "@jimp/core";
export { loadFont } from "@jimp/plugin-print/load-font";
export { measureText, measureTextHeight } from "@jimp/plugin-print";
export { diff } from "@jimp/diff";
export { intToRGBA, rgbaToInt, colorDiff, limit255, cssColorToHex, } from "@jimp/utils";
//# sourceMappingURL=index.js.map