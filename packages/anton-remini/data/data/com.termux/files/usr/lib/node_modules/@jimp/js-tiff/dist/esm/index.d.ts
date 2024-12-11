import { Bitmap } from "@jimp/types";
export default function tiff(): {
    mime: "image/tiff";
    encode: (bitmap: Bitmap) => Buffer;
    decode: (data: Buffer) => Bitmap;
};
//# sourceMappingURL=index.d.ts.map