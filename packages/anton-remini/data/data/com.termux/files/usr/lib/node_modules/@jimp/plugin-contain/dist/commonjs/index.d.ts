import { JimpClass } from "@jimp/types";
import { ResizeStrategy } from "@jimp/plugin-resize";
import { z } from "zod";
declare const ContainOptionsSchema: z.ZodObject<{
    /** the width to resize the image to */
    w: z.ZodNumber;
    /** the height to resize the image to */
    h: z.ZodNumber;
    /** A bitmask for horizontal and vertical alignment */
    align: z.ZodOptional<z.ZodNumber>;
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: z.ZodOptional<z.ZodNativeEnum<typeof ResizeStrategy>>;
}, "strip", z.ZodTypeAny, {
    w: number;
    h: number;
    align?: number | undefined;
    mode?: ResizeStrategy | undefined;
}, {
    w: number;
    h: number;
    align?: number | undefined;
    mode?: ResizeStrategy | undefined;
}>;
export type ContainOptions = z.infer<typeof ContainOptionsSchema>;
export declare const methods: {
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
    contain<I extends JimpClass>(image: I, options: ContainOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map