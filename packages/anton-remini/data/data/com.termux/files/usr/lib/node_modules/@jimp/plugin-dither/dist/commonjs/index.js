"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
exports.methods = {
    /**
     * Apply a ordered dithering effect.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.dither();
     * ```
     */
    dither(image) {
        const rgb565Matrix = [
            1, 9, 3, 11, 13, 5, 15, 7, 4, 12, 2, 10, 16, 8, 14, 6,
        ];
        image.scan((x, y, idx) => {
            const thresholdId = ((y & 3) << 2) + (x % 4);
            const dither = rgb565Matrix[thresholdId];
            image.bitmap.data[idx] = Math.min(image.bitmap.data[idx] + dither, 0xff);
            image.bitmap.data[idx + 1] = Math.min(image.bitmap.data[idx + 1] + dither, 0xff);
            image.bitmap.data[idx + 2] = Math.min(image.bitmap.data[idx + 2] + dither, 0xff);
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map