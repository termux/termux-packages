import { JimpClass } from "@jimp/types";
import { z } from "zod";
declare const DisplaceOptionsSchema: z.ZodObject<{
    /** the source Jimp instance */
    map: z.ZodObject<{
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
    /** the maximum displacement value */
    offset: z.ZodNumber;
}, "strip", z.ZodTypeAny, {
    map: {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    };
    offset: number;
}, {
    map: {
        bitmap: {
            data: Buffer | Uint8Array;
            width: number;
            height: number;
        };
    };
    offset: number;
}>;
export type DisplaceOptions = z.infer<typeof DisplaceOptionsSchema>;
export declare const methods: {
    /**
     * Displaces the image based on the provided displacement map
     * @param map the source Jimp instance
     * @param offset
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const map = await Jimp.read("test/map.png");
     *
     * image.displace(map, 10);
     * ```
     */
    displace<I extends JimpClass>(image: I, options: DisplaceOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map