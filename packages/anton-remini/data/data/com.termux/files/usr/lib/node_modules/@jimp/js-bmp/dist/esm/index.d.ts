import * as BMP from "bmp-ts";
import { Bitmap } from "@jimp/types";
export type { BmpColor } from "bmp-ts";
export { BmpCompression } from "bmp-ts";
type Pretty<T> = {
    [K in keyof T]: T[K] extends (...args: any[]) => any ? T[K] : T[K] extends object ? Pretty<T[K]> : T[K];
};
export type EncodeOptions = Pretty<Partial<Pick<BMP.BmpImage, "palette" | "colors" | "importantColors" | "hr" | "vr" | "reserved1" | "reserved2">>>;
export interface DecodeBmpOptions {
    toRGBA?: boolean;
}
declare function encode(image: Bitmap, options?: EncodeOptions): Buffer;
declare function decode(data: Buffer, options?: DecodeBmpOptions): Bitmap;
export declare function msBmp(): {
    mime: "image/x-ms-bmp";
    encode: typeof encode;
    decode: typeof decode;
};
export default function bmp(): {
    mime: "image/bmp";
    encode: typeof encode;
    decode: typeof decode;
};
//# sourceMappingURL=index.d.ts.map