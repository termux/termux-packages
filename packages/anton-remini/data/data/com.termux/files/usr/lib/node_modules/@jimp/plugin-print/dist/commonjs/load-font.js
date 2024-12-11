"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.loadFont = loadFont;
const load_bitmap_font_js_1 = require("./load-bitmap-font.js");
/**
 * Loads a Bitmap Font from a file.
 * @param file A path or URL to a font file
 * @returns A collection of Jimp images that can be used to print text
 * @example
 * ```ts
 * import { Jimp, loadFont } from "jimp";
 * import { SANS_10_BLACK } from "jimp/fonts";
 *
 * const font = await loadFont(SANS_10_BLACK);
 * const image = new Jimp({ width: 200, height: 100, color: 0xffffffff });
 *
 * image.print(font, 10, 10, "Hello world!");
 * ```
 */
async function loadFont(file) {
    let fileOrBuffer = file;
    if (typeof window === "undefined" && !load_bitmap_font_js_1.isWebWorker) {
        const { existsSync, promises: fs } = await import("fs");
        if (existsSync(file)) {
            fileOrBuffer = await fs.readFile(file);
        }
    }
    const data = await (0, load_bitmap_font_js_1.loadBitmapFontData)(fileOrBuffer);
    return (0, load_bitmap_font_js_1.processBitmapFont)(file, data);
}
//# sourceMappingURL=load-font.js.map