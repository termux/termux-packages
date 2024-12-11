import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const FlipOptionsSchema: z.ZodObject<{
    /** if true the image will be flipped horizontally */
    horizontal: z.ZodOptional<z.ZodBoolean>;
    /** if true the image will be flipped vertically */
    vertical: z.ZodOptional<z.ZodBoolean>;
}, "strip", z.ZodTypeAny, {
    horizontal?: boolean | undefined;
    vertical?: boolean | undefined;
}, {
    horizontal?: boolean | undefined;
    vertical?: boolean | undefined;
}>;
export type FlipOptions = z.infer<typeof FlipOptionsSchema>;
export declare const methods: {
    /**
     * Flip the image.
     * @param horizontal a Boolean, if true the image will be flipped horizontally
     * @param vertical a Boolean, if true the image will be flipped vertically
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.flip(true, false);
     * ```
     */
    flip<I extends JimpClass>(image: I, options: FlipOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map