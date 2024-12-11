import { JimpClass } from "@jimp/types";
export declare const methods: {
    /**
     * Calculates the perceptual hash
     * @returns the perceptual hash
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.hash();
     * ```
     */
    pHash<I extends JimpClass>(image: I): string;
    /**
     * Generates a perceptual hash of the image <https://en.wikipedia.org/wiki/Perceptual_hashing>. And pads the string. Can configure base.
     * @param base A number between 2 and 64 representing the base for the hash (e.g. 2 is binary, 10 is decimal, 16 is hex, 64 is base 64). Defaults to 64.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.hash(2); // binary
     * image.hash(64); // base 64
     * ```
     */
    hash<I extends JimpClass>(image: I, base?: number): string;
    /**
     * Calculates the hamming distance of the current image and a hash based on their perceptual hash
     * @param compareHash hash to compare to
     * @returns  a number ranging from 0 to 1, 0 means they are believed to be identical
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.distanceFromHash(image.pHash());
     * ```
     */
    distanceFromHash<I extends JimpClass>(image: I, compareHash: string): number;
};
/**
 * Calculates the hamming distance of two images based on their perceptual hash
 * @param img1 A Jimp image to compare
 * @param img2 A Jimp image to compare
 * @returns A number ranging from 0 to 1, 0 means they are believed to be identical
 * @example
 * ```ts
 * import { Jimp, distance } from "jimp";
 *
 * const image1 = await Jimp.read("test/image.png");
 * const image2 = await Jimp.read("test/image.png");
 *
 * distance(image1, image2); // 0.5
 * ```
 */
export declare function distance<I extends JimpClass>(img1: I, img2: I): number;
/**
 * Calculates the hamming distance of two images based on their perceptual hash
 * @param hash1 A pHash
 * @param hash2 A pHash
 * @returns A number ranging from 0 to 1, 0 means they are believed to be identical
 * @example
 * ```ts
 * import { Jimp, compareHashes } from "jimp";
 *
 * const image1 = await Jimp.read("test/image.png");
 * const image2 = await Jimp.read("test/image.png");
 *
 * compareHashes(image1.pHash(), image2.pHash()); // 0.5
 * ```
 */
export declare function compareHashes(hash1: string, hash2: string): number;
//# sourceMappingURL=index.d.ts.map