import { PNGOptions as PNGJSOptions } from "pngjs";
import { PNGFilterType, PNGColorType } from "./constants.js";
export type { PNGOptions as PNGJSOptions } from "pngjs";
export type PNGOptions = Omit<PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
    filterType?: PNGFilterType;
    colorType?: PNGColorType;
    inputColorType?: PNGColorType;
};
export interface DecodePngOptions {
    checkCRC?: boolean | undefined;
    skipRescale?: boolean | undefined;
}
export * from "./constants.js";
export default function png(): {
    mime: "image/png";
    hasAlpha: true;
    encode: (bitmap: import("@jimp/types").Bitmap, { deflateLevel, deflateStrategy, filterType, colorType, inputHasAlpha, ...options }?: PNGOptions) => Buffer;
    decode: (data: Buffer, options?: DecodePngOptions) => {
        data: Buffer;
        width: number;
        height: number;
    };
};
//# sourceMappingURL=index.d.ts.map