import { JimpClass } from "@jimp/types";
export declare const methods: {
    /**
     * A fast blur algorithm that produces similar effect to a Gaussian blur - but MUCH quicker
     * @param r the pixel radius of the blur
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.blur(5);
     * ```
     */
    blur<I extends JimpClass>(image: I, r: number): I;
    /**
     * Applies a true Gaussian blur to the image (warning: this is VERY slow)
     * @param r the pixel radius of the blur
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.gaussian(15);
     * ```
     */
    gaussian<I extends JimpClass>(image: I, r: number): I;
};
//# sourceMappingURL=index.d.ts.map