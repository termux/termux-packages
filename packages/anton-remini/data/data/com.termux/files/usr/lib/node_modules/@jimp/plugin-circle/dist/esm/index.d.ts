import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const CircleOptionsSchema: z.ZodObject<{
    /** the x position to draw the circle */
    x: z.ZodOptional<z.ZodNumber>;
    /** the y position to draw the circle */
    y: z.ZodOptional<z.ZodNumber>;
    /** the radius of the circle */
    radius: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    x?: number | undefined;
    y?: number | undefined;
    radius?: number | undefined;
}, {
    x?: number | undefined;
    y?: number | undefined;
    radius?: number | undefined;
}>;
export type CircleOptions = z.infer<typeof CircleOptionsSchema>;
export declare const methods: {
    /**
     * Creates a circle out of an image.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.circle();
     * // or
     * image.circle({ radius: 50, x: 25, y: 25 });
     * ```
     */
    circle<I extends JimpClass>(image: I, options?: CircleOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map