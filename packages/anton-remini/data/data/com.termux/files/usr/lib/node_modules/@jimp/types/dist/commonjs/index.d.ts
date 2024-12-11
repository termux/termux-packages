import { z } from "zod";
export declare enum Edge {
    EXTEND = 1,
    WRAP = 2,
    CROP = 3
}
export interface Bitmap {
    data: Buffer;
    width: number;
    height: number;
}
export interface Format<Mime extends string = string, ExportOptions extends Record<string, any> | undefined = undefined, DecodeOptions extends Record<string, any> | undefined = undefined> {
    mime: Mime;
    hasAlpha?: boolean;
    encode: (image: Bitmap, options?: ExportOptions) => Promise<Buffer> | Buffer;
    decode: (data: Buffer, options?: DecodeOptions) => Promise<Bitmap> | Bitmap;
}
export interface RGBColor {
    r: number;
    g: number;
    b: number;
}
export interface RGBAColor {
    r: number;
    g: number;
    b: number;
    a: number;
}
export declare const JimpClassSchema: z.ZodObject<{
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
export interface JimpClass {
    background: number;
    bitmap: Bitmap;
    getPixelIndex: (x: number, y: number, edgeHandling?: Edge) => number;
    getPixelColor: (x: number, y: number) => number;
    setPixelColor: (hex: number, x: number, y: number) => JimpClass;
    scan(f: (x: number, y: number, idx: number) => any): JimpClass;
    scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): JimpClass;
    scan(x: number | ((x: number, y: number, idx: number) => any), y?: number, w?: number, h?: number, f?: (x: number, y: number, idx: number) => any): JimpClass;
}
//# sourceMappingURL=index.d.ts.map