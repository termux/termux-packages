"use strict";
/**
 * @module jimp
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.cssColorToHex = exports.limit255 = exports.colorDiff = exports.rgbaToInt = exports.intToRGBA = exports.diff = exports.measureTextHeight = exports.measureText = exports.loadFont = exports.BlendMode = exports.VerticalAlign = exports.HorizontalAlign = exports.BmpCompression = exports.PNGFilterType = exports.PNGColorType = exports.compareHashes = exports.distance = exports.ResizeStrategy = exports.Jimp = exports.JimpMime = exports.defaultFormats = exports.defaultPlugins = void 0;
// import { Jimp } from "@jimp/core";
const js_bmp_1 = __importStar(require("@jimp/js-bmp"));
const js_gif_1 = __importDefault(require("@jimp/js-gif"));
const js_jpeg_1 = __importDefault(require("@jimp/js-jpeg"));
const js_png_1 = __importDefault(require("@jimp/js-png"));
const js_tiff_1 = __importDefault(require("@jimp/js-tiff"));
const blit = __importStar(require("@jimp/plugin-blit"));
const blur = __importStar(require("@jimp/plugin-blur"));
const circle = __importStar(require("@jimp/plugin-circle"));
const color = __importStar(require("@jimp/plugin-color"));
const contain = __importStar(require("@jimp/plugin-contain"));
const cover = __importStar(require("@jimp/plugin-cover"));
const crop = __importStar(require("@jimp/plugin-crop"));
const displace = __importStar(require("@jimp/plugin-displace"));
const dither = __importStar(require("@jimp/plugin-dither"));
const fisheye = __importStar(require("@jimp/plugin-fisheye"));
const flip = __importStar(require("@jimp/plugin-flip"));
const hash = __importStar(require("@jimp/plugin-hash"));
const mask = __importStar(require("@jimp/plugin-mask"));
const print = __importStar(require("@jimp/plugin-print"));
const resize = __importStar(require("@jimp/plugin-resize"));
const rotate = __importStar(require("@jimp/plugin-rotate"));
const threshold = __importStar(require("@jimp/plugin-threshold"));
const quantize = __importStar(require("@jimp/plugin-quantize"));
const core_1 = require("@jimp/core");
exports.defaultPlugins = [
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
exports.defaultFormats = [js_bmp_1.default, js_bmp_1.msBmp, js_gif_1.default, js_jpeg_1.default, js_png_1.default, js_tiff_1.default];
/** Convenience object for getting the MIME types of the default formats */
exports.JimpMime = {
    bmp: (0, js_bmp_1.default)().mime,
    gif: (0, js_gif_1.default)().mime,
    jpeg: (0, js_jpeg_1.default)().mime,
    png: (0, js_png_1.default)().mime,
    tiff: (0, js_tiff_1.default)().mime,
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
exports.Jimp = (0, core_1.createJimp)({
    formats: exports.defaultFormats,
    plugins: exports.defaultPlugins,
});
var plugin_resize_1 = require("@jimp/plugin-resize");
Object.defineProperty(exports, "ResizeStrategy", { enumerable: true, get: function () { return plugin_resize_1.ResizeStrategy; } });
var plugin_hash_1 = require("@jimp/plugin-hash");
Object.defineProperty(exports, "distance", { enumerable: true, get: function () { return plugin_hash_1.distance; } });
Object.defineProperty(exports, "compareHashes", { enumerable: true, get: function () { return plugin_hash_1.compareHashes; } });
var js_png_2 = require("@jimp/js-png");
Object.defineProperty(exports, "PNGColorType", { enumerable: true, get: function () { return js_png_2.PNGColorType; } });
Object.defineProperty(exports, "PNGFilterType", { enumerable: true, get: function () { return js_png_2.PNGFilterType; } });
var js_bmp_2 = require("@jimp/js-bmp");
Object.defineProperty(exports, "BmpCompression", { enumerable: true, get: function () { return js_bmp_2.BmpCompression; } });
var core_2 = require("@jimp/core");
Object.defineProperty(exports, "HorizontalAlign", { enumerable: true, get: function () { return core_2.HorizontalAlign; } });
Object.defineProperty(exports, "VerticalAlign", { enumerable: true, get: function () { return core_2.VerticalAlign; } });
Object.defineProperty(exports, "BlendMode", { enumerable: true, get: function () { return core_2.BlendMode; } });
var load_font_1 = require("@jimp/plugin-print/load-font");
Object.defineProperty(exports, "loadFont", { enumerable: true, get: function () { return load_font_1.loadFont; } });
var plugin_print_1 = require("@jimp/plugin-print");
Object.defineProperty(exports, "measureText", { enumerable: true, get: function () { return plugin_print_1.measureText; } });
Object.defineProperty(exports, "measureTextHeight", { enumerable: true, get: function () { return plugin_print_1.measureTextHeight; } });
var diff_1 = require("@jimp/diff");
Object.defineProperty(exports, "diff", { enumerable: true, get: function () { return diff_1.diff; } });
var utils_1 = require("@jimp/utils");
Object.defineProperty(exports, "intToRGBA", { enumerable: true, get: function () { return utils_1.intToRGBA; } });
Object.defineProperty(exports, "rgbaToInt", { enumerable: true, get: function () { return utils_1.rgbaToInt; } });
Object.defineProperty(exports, "colorDiff", { enumerable: true, get: function () { return utils_1.colorDiff; } });
Object.defineProperty(exports, "limit255", { enumerable: true, get: function () { return utils_1.limit255; } });
Object.defineProperty(exports, "cssColorToHex", { enumerable: true, get: function () { return utils_1.cssColorToHex; } });
//# sourceMappingURL=index.js.map