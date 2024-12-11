import { JimpClass } from "@jimp/types";
import { ResizeStrategy } from "@jimp/plugin-resize";
import { z } from "zod";
declare const CoverOptionsSchema: z.ZodObject<{
    /** the width to resize the image to */
    w: z.ZodNumber;
    /** the height to resize the image to */
    h: z.ZodNumber;
    /** A bitmask for horizontal and vertical alignment */
    align: z.ZodOptional<z.ZodNumber>;
    /** a scaling method (e.g. ResizeStrategy.BEZIER) */
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
export type CoverOptions = z.infer<typeof CoverOptionsSchema>;
export declare const methods: {
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
    cover<I extends JimpClass>(image: I, options: CoverOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map