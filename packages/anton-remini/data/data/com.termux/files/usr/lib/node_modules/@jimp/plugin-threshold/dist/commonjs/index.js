"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
const utils_1 = require("@jimp/utils");
const plugin_color_1 = require("@jimp/plugin-color");
const zod_1 = require("zod");
const ThresholdOptionsSchema = zod_1.z.object({
    /** A number auto limited between 0 - 255 */
    max: zod_1.z.number().min(0).max(255),
    /** A number auto limited between 0 - 255 (default 255)  */
    replace: zod_1.z.number().min(0).max(255).optional(),
    /** A boolean whether to apply greyscale beforehand (default true)  */
    autoGreyscale: zod_1.z.boolean().optional(),
});
exports.methods = {
    /**
     * Applies a minimum color threshold to a grayscale image.
     * Converts image to grayscale by default.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.threshold({ max: 150 });
     * ```
     */
    threshold(image, options) {
        let { max, replace = 255, 
        // eslint-disable-next-line prefer-const
        autoGreyscale = true, } = ThresholdOptionsSchema.parse(options);
        max = (0, utils_1.limit255)(max);
        replace = (0, utils_1.limit255)(replace);
        if (autoGreyscale) {
            plugin_color_1.methods.greyscale(image);
        }
        image.scan((_, __, idx) => {
            const grey = image.bitmap.data[idx] < max ? image.bitmap.data[idx] : replace;
            image.bitmap.data[idx] = grey;
            image.bitmap.data[idx + 1] = grey;
            image.bitmap.data[idx + 2] = grey;
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map