import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const FisheyeOptionsSchema: z.ZodObject<{
    /** the radius of the circle */
    radius: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    radius?: number | undefined;
}, {
    radius?: number | undefined;
}>;
export type FisheyeOptions = z.infer<typeof FisheyeOptionsSchema>;
export declare const methods: {
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
    fisheye<I extends JimpClass>(image: I, options?: FisheyeOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map