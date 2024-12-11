import { HorizontalAlign, VerticalAlign } from "@jimp/core";
import { clone } from "@jimp/utils";
import { ResizeStrategy, methods as resizeMethods } from "@jimp/plugin-resize";
import { methods as blitMethods } from "@jimp/plugin-blit";
import { z } from "zod";
const ContainOptionsSchema = z.object({
    /** the width to resize the image to */
    w: z.number(),
    /** the height to resize the image to */
    h: z.number(),
    /** A bitmask for horizontal and vertical alignment */
    align: z.number().optional(),
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.nativeEnum(ResizeStrategy).optional(),
});
export const methods = {
    /**
     * Scale the image to the given width and height keeping the aspect ratio. Some parts of the image may be letter boxed.
     * @param w the width to resize the image to
     * @param h the height to resize the image to
     * @param align A bitmask for horizontal and vertical alignment
     * @param mode a scaling method (e.g. Jimp.RESIZE_BEZIER)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.contain({ w: 150, h: 100 });
     * ```
     */
    contain(image, options) {
        const { w, h, align = HorizontalAlign.CENTER | VerticalAlign.MIDDLE, mode, } = ContainOptionsSchema.parse(options);
        const hbits = align & ((1 << 3) - 1);
        const vbits = align >> 3;
        // check if more flags than one is in the bit sets
        if (!((hbits !== 0 && !(hbits & (hbits - 1))) ||
            (vbits !== 0 && !(vbits & (vbits - 1))))) {
            throw new Error("only use one flag per alignment direction");
        }
        const alignH = hbits >> 1; // 0, 1, 2
        const alignV = vbits >> 1; // 0, 1, 2
        const f = w / h > image.bitmap.width / image.bitmap.height
            ? h / image.bitmap.height
            : w / image.bitmap.width;
        const c = resizeMethods.scale(clone(image), { f, mode });
        image = resizeMethods.resize(image, { w, h, mode });
        image.scan((_, __, idx) => {
            image.bitmap.data.writeUInt32BE(image.background, idx);
        });
        image = blitMethods.blit(image, {
            src: c,
            x: ((image.bitmap.width - c.bitmap.width) / 2) * alignH,
            y: ((image.bitmap.height - c.bitmap.height) / 2) * alignV,
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map