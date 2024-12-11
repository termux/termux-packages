"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
const types_1 = require("@jimp/types");
const utils_1 = require("@jimp/utils");
const zod_1 = require("zod");
const DisplaceOptionsSchema = zod_1.z.object({
    /** the source Jimp instance */
    map: types_1.JimpClassSchema,
    /** the maximum displacement value */
    offset: zod_1.z.number(),
});
exports.methods = {
    /**
     * Displaces the image based on the provided displacement map
     * @param map the source Jimp instance
     * @param offset
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const map = await Jimp.read("test/map.png");
     *
     * image.displace(map, 10);
     * ```
     */
    displace(image, options) {
        const { map, offset } = DisplaceOptionsSchema.parse(options);
        const source = (0, utils_1.clone)(image);
        image.scan((x, y, idx) => {
            let displacement = (map.bitmap.data[idx] / 256) * offset;
            displacement = Math.round(displacement);
            const ids = image.getPixelIndex(x + displacement, y);
            image.bitmap.data[ids] = source.bitmap.data[idx];
            image.bitmap.data[ids + 1] = source.bitmap.data[idx + 1];
            image.bitmap.data[ids + 2] = source.bitmap.data[idx + 2];
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map