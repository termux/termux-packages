import { JimpClass } from "@jimp/types";
import { z } from "zod";
export declare const CropOptionsSchema: z.ZodObject<{
    /** the x position to crop form */
    x: z.ZodNumber;
    /** the y position to crop form */
    y: z.ZodNumber;
    /** the width to crop form */
    w: z.ZodNumber;
    /** the height to crop form */
    h: z.ZodNumber;
}, "strip", z.ZodTypeAny, {
    x: number;
    y: number;
    w: number;
    h: number;
}, {
    x: number;
    y: number;
    w: number;
    h: number;
}>;
export type CropOptions = z.infer<typeof CropOptionsSchema>;
declare const AutocropComplexOptionsSchema: z.ZodObject<{
    /** percent of color difference tolerance (default value) */
    tolerance: z.ZodOptional<z.ZodNumber>;
    /** flag to force cropping only if the image has a real "frame" i.e. all 4 sides have some border (default value) */
    cropOnlyFrames: z.ZodOptional<z.ZodBoolean>;
    /** force cropping top be symmetric */
    cropSymmetric: z.ZodOptional<z.ZodBoolean>;
    /** Amount of pixels in border to leave */
    leaveBorder: z.ZodOptional<z.ZodNumber>;
    ignoreSides: z.ZodOptional<z.ZodObject<{
        north: z.ZodOptional<z.ZodBoolean>;
        south: z.ZodOptional<z.ZodBoolean>;
        east: z.ZodOptional<z.ZodBoolean>;
        west: z.ZodOptional<z.ZodBoolean>;
    }, "strip", z.ZodTypeAny, {
        north?: boolean | undefined;
        south?: boolean | undefined;
        east?: boolean | undefined;
        west?: boolean | undefined;
    }, {
        north?: boolean | undefined;
        south?: boolean | undefined;
        east?: boolean | undefined;
        west?: boolean | undefined;
    }>>;
}, "strip", z.ZodTypeAny, {
    tolerance?: number | undefined;
    cropOnlyFrames?: boolean | undefined;
    cropSymmetric?: boolean | undefined;
    leaveBorder?: number | undefined;
    ignoreSides?: {
        north?: boolean | undefined;
        south?: boolean | undefined;
        east?: boolean | undefined;
        west?: boolean | undefined;
    } | undefined;
}, {
    tolerance?: number | undefined;
    cropOnlyFrames?: boolean | undefined;
    cropSymmetric?: boolean | undefined;
    leaveBorder?: number | undefined;
    ignoreSides?: {
        north?: boolean | undefined;
        south?: boolean | undefined;
        east?: boolean | undefined;
        west?: boolean | undefined;
    } | undefined;
}>;
export type AutocropComplexOptions = z.infer<typeof AutocropComplexOptionsSchema>;
export type AutocropOptions = number | AutocropComplexOptions;
export declare const methods: {
    /**
     * Crops the image at a given point to a give size.
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const cropped = image.crop(150, 100);
     * ```
     */
    crop<I extends JimpClass>(image: I, options: CropOptions): I;
    /**
     * Autocrop same color borders from this image.
     * This function will attempt to crop out transparent pixels from the image.
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const cropped = image.autocrop();
     * ```
     */
    autocrop<I extends JimpClass>(image: I, options?: AutocropOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map