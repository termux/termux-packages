import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const BlitOptionsSchema: z.ZodUnion<[z.ZodObject<{
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
    /** the x position to blit the image */
    x: z.ZodOptional<z.ZodNumber>;
    /** the y position to blit the image */
    y: z.ZodOptional<z.ZodNumber>;
    /** the x position from which to crop the source image */
    srcX: z.ZodOptional<z.ZodNumber>;
    /** the y position from which to crop the source image */
    srcY: z.ZodOptional<z.ZodNumber>;
    /** the width to which to crop the source image */
    srcW: z.ZodOptional<z.ZodNumber>;
    /** the height to which to crop the source image */
    srcH: z.ZodOptional<z.ZodNumber>;
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
    srcX?: number | undefined;
    srcY?: number | undefined;
    srcW?: number | undefined;
    srcH?: number | undefined;
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
    srcX?: number | undefined;
    srcY?: number | undefined;
    srcW?: number | undefined;
    srcH?: number | undefined;
}>]>;
export type BlitOptions = z.infer<typeof BlitOptionsSchema>;
export declare const methods: {
    /**
     * Short for "bit-block transfer".
     * It involves the transfer of a block of pixel data from one area of a computer's memory to another area, typically for the purpose of rendering images on the screen or manipulating them in various ways.
     * It's a fundamental operation in computer graphics utilized in various applications, from operating systems to video games.
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const parrot = await Jimp.read("test/party-parrot.png");
     *
     * image.blit({ src: parrot, x: 10, y: 10 });
     * ```
     */
    blit<I extends JimpClass>(image: I, options: BlitOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map