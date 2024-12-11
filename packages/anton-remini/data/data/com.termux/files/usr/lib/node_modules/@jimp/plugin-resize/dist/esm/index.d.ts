import { JimpClass } from "@jimp/types";
import { ResizeStrategy } from "./constants.js";
import { z } from "zod";
export * from "./constants.js";
declare const ResizeOptionsSchema: z.ZodUnion<[z.ZodObject<{
    /** the width to resize the image to */
    w: z.ZodNumber;
    /** the height to resize the image to */
    h: z.ZodOptional<z.ZodNumber>;
    /** a scaling method (e.g. ResizeStrategy.BEZIER) */
    mode: z.ZodOptional<z.ZodNativeEnum<typeof ResizeStrategy>>;
}, "strip", z.ZodTypeAny, {
    w: number;
    h?: number | undefined;
    mode?: ResizeStrategy | undefined;
}, {
    w: number;
    h?: number | undefined;
    mode?: ResizeStrategy | undefined;
}>, z.ZodObject<{
    /** the width to resize the image to */
    w: z.ZodOptional<z.ZodNumber>;
    /** the height to resize the image to */
    h: z.ZodNumber;
    /** a scaling method (e.g. ResizeStrategy.BEZIER) */
    mode: z.ZodOptional<z.ZodNativeEnum<typeof ResizeStrategy>>;
}, "strip", z.ZodTypeAny, {
    h: number;
    w?: number | undefined;
    mode?: ResizeStrategy | undefined;
}, {
    h: number;
    w?: number | undefined;
    mode?: ResizeStrategy | undefined;
}>]>;
export type ResizeOptions = z.infer<typeof ResizeOptionsSchema>;
declare const ScaleToFitOptionsSchema: z.ZodObject<{
    /** the width to resize the image to */
    w: z.ZodNumber;
    /** the height to resize the image to */
    h: z.ZodNumber;
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.ZodOptional<z.ZodNativeEnum<typeof ResizeStrategy>>;
}, "strip", z.ZodTypeAny, {
    w: number;
    h: number;
    mode?: ResizeStrategy | undefined;
}, {
    w: number;
    h: number;
    mode?: ResizeStrategy | undefined;
}>;
export type ScaleToFitOptions = z.infer<typeof ScaleToFitOptionsSchema>;
declare const ScaleComplexOptionsSchema: z.ZodObject<{
    /** the width to resize the image to */
    f: z.ZodNumber;
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.ZodOptional<z.ZodNativeEnum<typeof ResizeStrategy>>;
}, "strip", z.ZodTypeAny, {
    f: number;
    mode?: ResizeStrategy | undefined;
}, {
    f: number;
    mode?: ResizeStrategy | undefined;
}>;
export type ScaleComplexOptions = z.infer<typeof ScaleComplexOptionsSchema>;
export type ScaleOptions = number | ScaleComplexOptions;
export declare const methods: {
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
    resize<I extends JimpClass>(image: I, options: ResizeOptions): I;
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
    scale<I extends JimpClass>(image: I, options: ScaleOptions): I;
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
    scaleToFit<I extends JimpClass>(image: I, options: ScaleToFitOptions): I;
};
//# sourceMappingURL=index.d.ts.map