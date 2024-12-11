import { JimpClass } from "@jimp/types";
declare class ImagePHash {
    size: number;
    smallerSize: number;
    constructor(size?: number, smallerSize?: number);
    distance(s1: string, s2: string): number;
    /**
     * Returns a 'binary string' (like. 001010111011100010) which is easy to do a hamming distance on.
     */
    getHash(img: JimpClass): string;
}
export default ImagePHash;
//# sourceMappingURL=phash.d.ts.map