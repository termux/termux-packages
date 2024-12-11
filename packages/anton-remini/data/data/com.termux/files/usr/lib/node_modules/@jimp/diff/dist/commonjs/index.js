"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.diff = diff;
const plugin_resize_1 = require("@jimp/plugin-resize");
const utils_1 = require("@jimp/utils");
const pixelmatch_1 = __importDefault(require("pixelmatch"));
/**
 * Diffs two images and returns
 * @param img1 A Jimp image to compare
 * @param img2 A Jimp image to compare
 * @param threshold A number, 0 to 1, the smaller the value the more sensitive the comparison (default: 0.1)
 * @returns An object with the following properties:
 * - percent: The proportion of different pixels (0-1), where 0 means the two images are pixel identical
 * - image: A Jimp image showing differences
 * @example
 * ```ts
 * import { Jimp, diff } from "jimp";
 *
 * const image1 = await Jimp.read("test/image.png");
 * const image2 = await Jimp.read("test/image.png");
 *
 * const diff = diff(image1, image2);
 *
 * diff.percent; // 0.5
 * diff.image; // a Jimp image showing differences
 * ```
 */
function diff(img1, img2, threshold = 0.1) {
    let bmp1 = img1.bitmap;
    let bmp2 = img2.bitmap;
    if (bmp1.width !== bmp2.width || bmp1.height !== bmp2.height) {
        if (bmp1.width * bmp1.height > bmp2.width * bmp2.height) {
            // img1 is bigger
            bmp1 = plugin_resize_1.methods.resize((0, utils_1.clone)(img1), {
                w: bmp2.width,
                h: bmp2.height,
            }).bitmap;
        }
        else {
            // img2 is bigger (or they are the same in area)
            bmp2 = plugin_resize_1.methods.resize((0, utils_1.clone)(img2), {
                w: bmp1.width,
                h: bmp1.height,
            }).bitmap;
        }
    }
    if (typeof threshold !== "number" || threshold < 0 || threshold > 1) {
        throw new Error("threshold must be a number between 0 and 1");
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const diff = new img1.constructor({
        width: bmp1.width,
        height: bmp1.height,
        color: 0xffffffff,
    });
    const numDiffPixels = (0, pixelmatch_1.default)(bmp1.data, bmp2.data, diff.bitmap.data, diff.bitmap.width, diff.bitmap.height, { threshold });
    return {
        percent: numDiffPixels / (diff.bitmap.width * diff.bitmap.height),
        image: diff,
    };
}
//# sourceMappingURL=index.js.map