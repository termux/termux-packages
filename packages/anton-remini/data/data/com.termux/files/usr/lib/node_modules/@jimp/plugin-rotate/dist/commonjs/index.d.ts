import { ResizeStrategy } from "@jimp/plugin-resize";
import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const RotateOptionsSchema: z.ZodUnion<[z.ZodNumber, z.ZodObject<{
    /** the number of degrees to rotate the image by */
    deg: z.ZodNumber;
    /** resize mode or a boolean, if false then the width and height of the image will not be changed */
    mode: z.ZodOptional<z.ZodUnion<[z.ZodBoolean, z.ZodNativeEnum<typeof ResizeStrategy>]>>;
}, "strip", z.ZodTypeAny, {
    deg: number;
    mode?: boolean | ResizeStrategy | undefined;
}, {
    deg: number;
    mode?: boolean | ResizeStrategy | undefined;
}>]>;
export type RotateOptions = z.infer<typeof RotateOptionsSchema>;
export declare const methods: {
    /**
     * Rotates the image counter-clockwise by a number of degrees. By default the width and height of the image will be resized appropriately.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.rotate(90);
     * ```
     */
    rotate<I extends JimpClass>(image: I, options: RotateOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map