import { methods } from "@jimp/plugin-resize";
import { clone } from "@jimp/utils";
import pixelMatch from "pixelmatch";
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
export function diff(img1, img2, threshold = 0.1) {
    let bmp1 = img1.bitmap;
    let bmp2 = img2.bitmap;
    if (bmp1.width !== bmp2.width || bmp1.height !== bmp2.height) {
        if (bmp1.width * bmp1.height > bmp2.width * bmp2.height) {
            // img1 is bigger
            bmp1 = methods.resize(clone(img1), {
                w: bmp2.width,
                h: bmp2.height,
            }).bitmap;
        }
        else {
            // img2 is bigger (or they are the same in area)
            bmp2 = methods.resize(clone(img2), {
                w: bmp1.width,
                h: bmp1.height,
            }).bitmap;
        }
    }
    if (typeof threshold !== "number" || threshold < 0 || threshold > 1) {
        throw new Error("threshold must be a number between 0 and 1");
    }
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const diff = new img1.constructor({
        width: bmp1.width,
        height: bmp1.height,
        color: 0xffffffff,
    });
    const numDiffPixels = pixelMatch(bmp1.data, bmp2.data, diff.bitmap.data, diff.bitmap.width, diff.bitmap.height, { threshold });
    return {
        percent: numDiffPixels / (diff.bitmap.width * diff.bitmap.height),
        image: diff,
    };
}
//# sourceMappingURL=index.js.map