import { ResizeStrategy } from "./constants.js";
import { z } from "zod";
import Resize from "./modules/resize.js";
import { operations as Resize2 } from "./modules/resize2.js";
export * from "./constants.js";
const ResizeOptionsSchema = z.union([
    z.object({
        /** the width to resize the image to */
        w: z.number().min(0),
        /** the height to resize the image to */
        h: z.number().min(0).optional(),
        /** a scaling method (e.g. ResizeStrategy.BEZIER) */
        mode: z.nativeEnum(ResizeStrategy).optional(),
    }),
    z.object({
        /** the width to resize the image to */
        w: z.number().min(0).optional(),
        /** the height to resize the image to */
        h: z.number().min(0),
        /** a scaling method (e.g. ResizeStrategy.BEZIER) */
        mode: z.nativeEnum(ResizeStrategy).optional(),
    }),
]);
const ScaleToFitOptionsSchema = z.object({
    /** the width to resize the image to */
    w: z.number().min(0),
    /** the height to resize the image to */
    h: z.number().min(0),
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.nativeEnum(ResizeStrategy).optional(),
});
const ScaleComplexOptionsSchema = z.object({
    /** the width to resize the image to */
    f: z.number().min(0),
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.nativeEnum(ResizeStrategy).optional(),
});
export const methods = {
    /**
     * Resizes the image to a set width and height using a 2-pass bilinear algorithm
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.resize({ w: 150 });
     * ```
     */
    resize(image, options) {
        const { mode } = ResizeOptionsSchema.parse(options);
        let w;
        let h;
        if (typeof options.w === "number") {
            w = options.w;
            h = options.h ?? image.bitmap.height * (w / image.bitmap.width);
        }
        else if (typeof options.h === "number") {
            h = options.h;
            w = options.w ?? image.bitmap.width * (h / image.bitmap.height);
        }
        else {
            throw new Error("w must be a number");
        }
        // round inputs
        w = Math.round(w) || 1;
        h = Math.round(h) || 1;
        if (mode && typeof Resize2[mode] === "function") {
            const dst = {
                data: Buffer.alloc(w * h * 4),
                width: w,
                height: h,
            };
            Resize2[mode](image.bitmap, dst);
            image.bitmap = dst;
        }
        else {
            const resize = new Resize(image.bitmap.width, image.bitmap.height, w, h, true, true, (buffer) => {
                image.bitmap.data = Buffer.from(buffer);
                image.bitmap.width = w;
                image.bitmap.height = h;
            });
            resize.resize(image.bitmap.data);
        }
        return image;
    },
    /**
     * Uniformly scales the image by a factor.
     * @param f the factor to scale the image by
     * @param mode (optional) a scaling method (e.g. Jimp.RESIZE_BEZIER)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.scale(0.5);
     * ```
     */
    scale(image, options) {
        const { f, mode } = typeof options === "number"
            ? { f: options }
            : ScaleComplexOptionsSchema.parse(options);
        const w = image.bitmap.width * f;
        const h = image.bitmap.height * f;
        return this.resize(image, { w, h, mode: mode });
    },
    /**
     * Scale the image to the largest size that fits inside the rectangle that has the given width and height.
     * @param w the width to resize the image to
     * @param h the height to resize the image to
     * @param mode a scaling method (e.g. ResizeStrategy.BEZIER)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.scaleToFit(100, 100);
     * ```
     */
    scaleToFit(image, options) {
        const { h, w, mode } = ScaleToFitOptionsSchema.parse(options);
        const f = w / h > image.bitmap.width / image.bitmap.height
            ? h / image.bitmap.height
            : w / image.bitmap.width;
        return this.scale(image, { f, mode: mode });
    },
};
//# sourceMappingURL=index.js.map