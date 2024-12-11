import JPEG from "jpeg-js";
export interface JPEGOptions {
    quality?: number;
}
export interface DecodeJpegOptions {
    useTArray?: false;
    colorTransform?: boolean;
    formatAsRGBA?: boolean;
    tolerantDecoding?: boolean;
    maxResolutionInMP?: number;
    maxMemoryUsageInMB?: number;
}
export default function jpeg(): {
    mime: "image/jpeg";
    encode: (bitmap: import("@jimp/types").Bitmap, { quality }?: JPEGOptions) => Buffer;
    decode: (data: Buffer, options?: DecodeJpegOptions) => JPEG.BufferRet & {
        comments?: string[];
    };
};
//# sourceMappingURL=index.d.ts.map