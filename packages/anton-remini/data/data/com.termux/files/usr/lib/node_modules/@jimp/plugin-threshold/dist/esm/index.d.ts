import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const ThresholdOptionsSchema: z.ZodObject<{
    /** A number auto limited between 0 - 255 */
    max: z.ZodNumber;
    /** A number auto limited between 0 - 255 (default 255)  */
    replace: z.ZodOptional<z.ZodNumber>;
    /** A boolean whether to apply greyscale beforehand (default true)  */
    autoGreyscale: z.ZodOptional<z.ZodBoolean>;
}, "strip", z.ZodTypeAny, {
    max: number;
    replace?: number | undefined;
    autoGreyscale?: boolean | undefined;
}, {
    max: number;
    replace?: number | undefined;
    autoGreyscale?: boolean | undefined;
}>;
export type ThresholdOptions = z.infer<typeof ThresholdOptionsSchema>;
export declare const methods: {
    /**
     * Applies a minimum color threshold to a grayscale image.
     * Converts image to grayscale by default.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.threshold({ max: 150 });
     * ```
     */
    threshold<I extends JimpClass>(image: I, options: ThresholdOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map