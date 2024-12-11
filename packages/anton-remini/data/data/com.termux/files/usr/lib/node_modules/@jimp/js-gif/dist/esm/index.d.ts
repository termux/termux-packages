export interface JPEGOptions {
    quality?: number;
}
export default function gif(): {
    mime: "image/gif";
    encode: (bitmap: import("@jimp/types").Bitmap) => Promise<Buffer>;
    decode: (data: Buffer) => {
        data: Buffer;
        width: number;
        height: number;
    };
};
//# sourceMappingURL=index.d.ts.map