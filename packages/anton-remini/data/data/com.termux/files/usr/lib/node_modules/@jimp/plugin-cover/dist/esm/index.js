import { VerticalAlign, HorizontalAlign } from "@jimp/core";
import { ResizeStrategy, methods as resizeMethods } from "@jimp/plugin-resize";
import { methods as cropMethods } from "@jimp/plugin-crop";
import { z } from "zod";
const CoverOptionsSchema = z.object({
    /** the width to resize the image to */
    w: z.number(),
    /** the height to resize the image to */
    h: z.number(),
    /** A bitmask for horizontal and vertical alignment */
    align: z.number().optional(),
    /** a scaling method (e.g. ResizeStrategy.BEZIER) */
    mode: z.nativeEnum(ResizeStrategy).optional(),
});
export const methods = {
    /**
     * Scale the image so the given width and height keeping the aspect ratio. Some parts of the image may be clipped.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.cover(150, 100);
     * ```
     */
    cover(image, options) {
        const { w, h, align = HorizontalAlign.CENTER | VerticalAlign.MIDDLE, mode, } = CoverOptionsSchema.parse(options);
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
            ? w / image.bitmap.width
            : h / image.bitmap.height;
        image = resizeMethods.scale(image, {
            f,
            mode,
        });
        image = cropMethods.crop(image, {
            x: ((image.bitmap.width - w) / 2) * alignH,
            y: ((image.bitmap.height - h) / 2) * alignV,
            w,
            h,
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map