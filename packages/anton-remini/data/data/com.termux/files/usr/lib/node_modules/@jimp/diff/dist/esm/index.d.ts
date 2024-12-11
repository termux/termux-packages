import { JimpClass } from "@jimp/types";
/**
 * Diffs two images and returns
 * @param img1 A Jimp image to compare
 * @param img2 A Jimp image to compare
 * @param threshold A number, 0 to 1, the smaller the value the more sensitive the comparison (default: 0.1)
 * @returns An object with the following properties:
 * - percent: The proportion of different pixels (0-1), where 0 means the two images are pixel identical
 * - image: A Jimp image showing differences
 * @example
 * ```ts
 * import { Jimp, diff } from "jimp";
 *
 * const image1 = await Jimp.read("test/image.png");
 * const image2 = await Jimp.read("test/image.png");
 *
 * const diff = diff(image1, image2);
 *
 * diff.percent; // 0.5
 * diff.image; // a Jimp image showing differences
 * ```
 */
export declare function diff<I extends JimpClass>(img1: I, img2: I, threshold?: number): {
    percent: number;
    image: any;
};
//# sourceMappingURL=index.d.ts.map