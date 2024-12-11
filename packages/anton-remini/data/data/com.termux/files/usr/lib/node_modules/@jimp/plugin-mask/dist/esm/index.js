import { JimpClassSchema } from "@jimp/types";
import { z } from "zod";
const MaskOptionsObjectSchema = z.object({
    src: JimpClassSchema,
    /** the x position to draw the image */
    x: z.number().optional(),
    /** the y position to draw the image */
    y: z.number().optional(),
});
const MaskOptionsSchema = z.union([JimpClassSchema, MaskOptionsObjectSchema]);
export const methods = {
    /**
     * Masks a source image on to this image using average pixel colour. A completely black pixel on the mask will turn a pixel in the image completely transparent.
     * @param src the source Jimp instance
     * @param x the horizontal position to blit the image
     * @param y the vertical position to blit the image
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const mask = await Jimp.read("test/mask.png");
     *
     * image.mask(mask);
     * ```
     */
    mask(image, options) {
        MaskOptionsSchema.parse(options);
        let src;
        let x;
        let y;
        if ("bitmap" in options) {
            src = options;
            x = 0;
            y = 0;
        }
        else {
            src = options.src;
            x = options.x ?? 0;
            y = options.y ?? 0;
        }
        // round input
        x = Math.round(x);
        y = Math.round(y);
        const w = image.bitmap.width;
        const h = image.bitmap.height;
        src.scan(function (sx, sy, idx) {
            const destX = x + sx;
            const destY = y + sy;
            if (destX >= 0 && destY >= 0 && destX < w && destY < h) {
                const dstIdx = image.getPixelIndex(destX, destY);
                const { data } = src.bitmap;
                const avg = (data[idx + 0] + data[idx + 1] + data[idx + 2]) / 3;
                image.bitmap.data[dstIdx + 3] *= avg / 255;
            }
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map