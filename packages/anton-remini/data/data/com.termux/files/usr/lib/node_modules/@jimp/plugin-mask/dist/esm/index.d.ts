import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const MaskOptionsSchema: z.ZodUnion<[z.ZodObject<{
    bitmap: z.ZodObject<{
        data: z.ZodUnion<[z.ZodType<Buffer, z.ZodTypeDef, Buffer>, z.ZodType<Uint8Array, z.ZodTypeDef, Uint8Array>]>;
        width: z.ZodNumber;
        height: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        data: Buffer | Uint8Array;
        width: number;
        height: number;
    }, {
        data: Buffer | Uint8Array;
        width: number;
        height: number;
    }>;
}, "strip", z.ZodTypeAny, {
    bitmap: {
        data: Buffer | Uint8Array;
        width: number;
        height: number;
    };
}, {
    bitmap: {
        data: Buffer | Uint8Array;
        width: number;
        height: number;
    };
}>, z.ZodObject<{
    src: z.ZodObject<{
        bitmap: z.ZodObject<{
            data: z.ZodUnion<[z.ZodType<Buffer, z.ZodTypeDef, Buffer>, z.ZodType<Uint8Array, z.ZodTypeDef, Uint8Array>]>;
            width: z.ZodNumber;
            height: z.ZodNumber;
        }, "strip", z.ZodTypeAny, {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        }, {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        }>;
    }, "strip", z.ZodTypeAny, {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    }, {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    }>;
    /** the x position to draw the image */
    x: z.ZodOptional<z.ZodNumber>;
    /** the y position to draw the image */
    y: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    src: {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    };
    x?: number | undefined;
    y?: number | undefined;
}, {
    src: {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    };
    x?: number | undefined;
    y?: number | undefined;
}>]>;
export type MaskOptions = z.infer<typeof MaskOptionsSchema>;
export declare const methods: {
    /**
     * Masks a source image on to this image using average pixel colour. A completely black pixel on the mask will turn a pixel in the image completely transparent.
     * @param src the source Jimp instance
     * @param x the horizontal position to blit the image
     * @param y the vertical position to blit the image
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const mask = await Jimp.read("test/mask.png");
     *
     * image.mask(mask);
     * ```
     */
    mask<I extends JimpClass>(image: I, options: MaskOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map