"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
const utils_1 = require("@jimp/utils");
const zod_1 = require("zod");
const FisheyeOptionsSchema = zod_1.z.object({
    /** the radius of the circle */
    radius: zod_1.z.number().min(0).optional(),
});
exports.methods = {
    /**
     * Adds a fisheye effect to the image.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.fisheye();
     * ```
     */
    fisheye(image, options = {}) {
        const { radius = 2.5 } = FisheyeOptionsSchema.parse(options);
        const source = (0, utils_1.clone)(image);
        const { width, height } = source.bitmap;
        source.scan((x, y) => {
            const hx = x / width;
            const hy = y / height;
            const rActual = Math.sqrt(Math.pow(hx - 0.5, 2) + Math.pow(hy - 0.5, 2));
            const rn = 2 * Math.pow(rActual, radius);
            const cosA = (hx - 0.5) / rActual;
            const sinA = (hy - 0.5) / rActual;
            const newX = Math.round((rn * cosA + 0.5) * width);
            const newY = Math.round((rn * sinA + 0.5) * height);
            const color = source.getPixelColor(newX, newY);
            image.setPixelColor(color, x, y);
        });
        /* Set center pixel color, otherwise it will be transparent */
        image.setPixelColor(source.getPixelColor(width / 2, height / 2), width / 2, height / 2);
        return image;
    },
};
//# sourceMappingURL=index.js.map