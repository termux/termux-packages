import { Edge, JimpClass } from "@jimp/types";
import { z } from "zod";
declare const ConvolutionOptionsSchema: z.ZodUnion<[z.ZodArray<z.ZodArray<z.ZodNumber, "many">, "many">, z.ZodObject<{
    /** a matrix to weight the neighbors sum */
    kernel: z.ZodArray<z.ZodArray<z.ZodNumber, "many">, "many">;
    /**define how to sum pixels from outside the border */
    edgeHandling: z.ZodOptional<z.ZodNativeEnum<typeof Edge>>;
}, "strip", z.ZodTypeAny, {
    kernel: number[][];
    edgeHandling?: Edge | undefined;
}, {
    kernel: number[][];
    edgeHandling?: Edge | undefined;
}>]>;
type ConvolutionOptions = z.infer<typeof ConvolutionOptionsSchema>;
declare const ConvoluteOptionsSchema: z.ZodUnion<[z.ZodArray<z.ZodArray<z.ZodNumber, "many">, "many">, z.ZodObject<{
    /** the convolution kernel */
    kernel: z.ZodArray<z.ZodArray<z.ZodNumber, "many">, "many">;
    /** the x position of the region to apply convolution to */
    x: z.ZodOptional<z.ZodNumber>;
    /** the y position of the region to apply convolution to */
    y: z.ZodOptional<z.ZodNumber>;
    /** the width of the region to apply convolution to */
    w: z.ZodOptional<z.ZodNumber>;
    /** the height of the region to apply convolution to */
    h: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    kernel: number[][];
    x?: number | undefined;
    y?: number | undefined;
    w?: number | undefined;
    h?: number | undefined;
}, {
    kernel: number[][];
    x?: number | undefined;
    y?: number | undefined;
    w?: number | undefined;
    h?: number | undefined;
}>]>;
type ConvoluteOptions = z.infer<typeof ConvoluteOptionsSchema>;
declare const PixelateOptionsSchema: z.ZodUnion<[z.ZodNumber, z.ZodObject<{
    /** the size of the pixels */
    size: z.ZodNumber;
    /** the x position of the region to pixelate */
    x: z.ZodOptional<z.ZodNumber>;
    /** the y position of the region to pixelate */
    y: z.ZodOptional<z.ZodNumber>;
    /** the width of the region to pixelate */
    w: z.ZodOptional<z.ZodNumber>;
    /** the height of the region to pixelate */
    h: z.ZodOptional<z.ZodNumber>;
}, "strip", z.ZodTypeAny, {
    size: number;
    x?: number | undefined;
    y?: number | undefined;
    w?: number | undefined;
    h?: number | undefined;
}, {
    size: number;
    x?: number | undefined;
    y?: number | undefined;
    w?: number | undefined;
    h?: number | undefined;
}>]>;
type PixelateOptions = z.infer<typeof PixelateOptionsSchema>;
declare const HueActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"hue">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "hue";
}, {
    params: [number];
    apply: "hue";
}>;
export type HueAction = z.infer<typeof HueActionSchema>;
declare const SpinActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"spin">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "spin";
}, {
    params: [number];
    apply: "spin";
}>;
export type SpinAction = z.infer<typeof SpinActionSchema>;
declare const LightenActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"lighten">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "lighten";
    params?: [number] | undefined;
}, {
    apply: "lighten";
    params?: [number] | undefined;
}>;
export type LightenAction = z.infer<typeof LightenActionSchema>;
declare const MixActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"mix">;
    params: z.ZodUnion<[z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>], null>, z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>, z.ZodNumber], null>]>;
}, "strip", z.ZodTypeAny, {
    params: [{
        r: number;
        g: number;
        b: number;
    }] | [{
        r: number;
        g: number;
        b: number;
    }, number];
    apply: "mix";
}, {
    params: [{
        r: number;
        g: number;
        b: number;
    }] | [{
        r: number;
        g: number;
        b: number;
    }, number];
    apply: "mix";
}>;
export type MixAction = z.infer<typeof MixActionSchema>;
declare const TintActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"tint">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "tint";
    params?: [number] | undefined;
}, {
    apply: "tint";
    params?: [number] | undefined;
}>;
export type TintAction = z.infer<typeof TintActionSchema>;
declare const ShadeActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"shade">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "shade";
    params?: [number] | undefined;
}, {
    apply: "shade";
    params?: [number] | undefined;
}>;
export type ShadeAction = z.infer<typeof ShadeActionSchema>;
declare const XorActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"xor">;
    params: z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>], null>;
}, "strip", z.ZodTypeAny, {
    params: [{
        r: number;
        g: number;
        b: number;
    }];
    apply: "xor";
}, {
    params: [{
        r: number;
        g: number;
        b: number;
    }];
    apply: "xor";
}>;
export type XorAction = z.infer<typeof XorActionSchema>;
declare const RedActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"red">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "red";
}, {
    params: [number];
    apply: "red";
}>;
export type RedAction = z.infer<typeof RedActionSchema>;
declare const GreenActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"green">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "green";
}, {
    params: [number];
    apply: "green";
}>;
export type GreenAction = z.infer<typeof GreenActionSchema>;
declare const BlueActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"blue">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "blue";
}, {
    params: [number];
    apply: "blue";
}>;
export type BlueAction = z.infer<typeof BlueActionSchema>;
declare const BrightenActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"brighten">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "brighten";
    params?: [number] | undefined;
}, {
    apply: "brighten";
    params?: [number] | undefined;
}>;
export type BrightenAction = z.infer<typeof BrightenActionSchema>;
declare const DarkenActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"darken">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "darken";
    params?: [number] | undefined;
}, {
    apply: "darken";
    params?: [number] | undefined;
}>;
export type DarkenAction = z.infer<typeof DarkenActionSchema>;
declare const DesaturateActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"desaturate">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "desaturate";
    params?: [number] | undefined;
}, {
    apply: "desaturate";
    params?: [number] | undefined;
}>;
export type DesaturateAction = z.infer<typeof DesaturateActionSchema>;
declare const SaturateActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"saturate">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "saturate";
    params?: [number] | undefined;
}, {
    apply: "saturate";
    params?: [number] | undefined;
}>;
export type SaturateAction = z.infer<typeof SaturateActionSchema>;
declare const GrayscaleActionSchema: z.ZodObject<{
    apply: z.ZodLiteral<"greyscale">;
    params: z.ZodOptional<z.ZodTuple<[], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "greyscale";
    params?: [] | undefined;
}, {
    apply: "greyscale";
    params?: [] | undefined;
}>;
export type GrayscaleAction = z.infer<typeof GrayscaleActionSchema>;
declare const ColorActionNameSchema: z.ZodUnion<[z.ZodObject<{
    apply: z.ZodLiteral<"hue">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "hue";
}, {
    params: [number];
    apply: "hue";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"spin">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "spin";
}, {
    params: [number];
    apply: "spin";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"lighten">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "lighten";
    params?: [number] | undefined;
}, {
    apply: "lighten";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"mix">;
    params: z.ZodUnion<[z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>], null>, z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>, z.ZodNumber], null>]>;
}, "strip", z.ZodTypeAny, {
    params: [{
        r: number;
        g: number;
        b: number;
    }] | [{
        r: number;
        g: number;
        b: number;
    }, number];
    apply: "mix";
}, {
    params: [{
        r: number;
        g: number;
        b: number;
    }] | [{
        r: number;
        g: number;
        b: number;
    }, number];
    apply: "mix";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"tint">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "tint";
    params?: [number] | undefined;
}, {
    apply: "tint";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"shade">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "shade";
    params?: [number] | undefined;
}, {
    apply: "shade";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"xor">;
    params: z.ZodTuple<[z.ZodObject<{
        r: z.ZodNumber;
        g: z.ZodNumber;
        b: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        r: number;
        g: number;
        b: number;
    }, {
        r: number;
        g: number;
        b: number;
    }>], null>;
}, "strip", z.ZodTypeAny, {
    params: [{
        r: number;
        g: number;
        b: number;
    }];
    apply: "xor";
}, {
    params: [{
        r: number;
        g: number;
        b: number;
    }];
    apply: "xor";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"red">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "red";
}, {
    params: [number];
    apply: "red";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"green">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "green";
}, {
    params: [number];
    apply: "green";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"blue">;
    params: z.ZodTuple<[z.ZodNumber], null>;
}, "strip", z.ZodTypeAny, {
    params: [number];
    apply: "blue";
}, {
    params: [number];
    apply: "blue";
}>, z.ZodObject<{
    apply: z.ZodLiteral<"brighten">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "brighten";
    params?: [number] | undefined;
}, {
    apply: "brighten";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"darken">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "darken";
    params?: [number] | undefined;
}, {
    apply: "darken";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"desaturate">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "desaturate";
    params?: [number] | undefined;
}, {
    apply: "desaturate";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"saturate">;
    params: z.ZodOptional<z.ZodTuple<[z.ZodNumber], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "saturate";
    params?: [number] | undefined;
}, {
    apply: "saturate";
    params?: [number] | undefined;
}>, z.ZodObject<{
    apply: z.ZodLiteral<"greyscale">;
    params: z.ZodOptional<z.ZodTuple<[], null>>;
}, "strip", z.ZodTypeAny, {
    apply: "greyscale";
    params?: [] | undefined;
}, {
    apply: "greyscale";
    params?: [] | undefined;
}>]>;
export type ColorAction = z.infer<typeof ColorActionNameSchema>;
export declare const ColorActionName: Readonly<{
    LIGHTEN: "lighten";
    BRIGHTEN: "brighten";
    DARKEN: "darken";
    DESATURATE: "desaturate";
    SATURATE: "saturate";
    GREYSCALE: "greyscale";
    SPIN: "spin";
    HUE: "hue";
    MIX: "mix";
    TINT: "tint";
    SHADE: "shade";
    XOR: "xor";
    RED: "red";
    GREEN: "green";
    BLUE: "blue";
}>;
export declare const methods: {
    /**
     * Normalizes the image.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.normalize();
     * ```
     */
    normalize<I extends JimpClass>(image: I): I;
    /**
     * Inverts the colors in the image.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.invert();
     * ```
     */
    invert<I extends JimpClass>(image: I): I;
    /**
     * Adjusts the brightness of the image
     * @param val the amount to adjust the brightness.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.brightness(0.5);
     * ```
     */
    brightness<I extends JimpClass>(image: I, val: number): I;
    /**
     * Adjusts the contrast of the image
     * @param val the amount to adjust the contrast, a number between -1 and +1
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.contrast(0.75);
     * ```
     */
    contrast<I extends JimpClass>(image: I, val: number): I;
    /**
     * Apply a posterize effect
     * @param  n the amount to adjust the contrast, minimum threshold is two
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.posterize(5);
     * ```
     */
    posterize<I extends JimpClass>(image: I, n: number): I;
    /**
     * Removes colour from the image using ITU Rec 709 luminance values
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.greyscale();
     * ```
     */
    greyscale<I extends JimpClass>(image: I): I;
    /**
     * Multiplies the opacity of each pixel by a factor between 0 and 1
     * @param f A number, the factor by which to multiply the opacity of each pixel
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.opacity(0.5);
     * ```
     */
    opacity<I extends JimpClass>(image: I, f: number): I;
    /**
     * Applies a sepia tone to the image.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.sepia();
     * ```
     */
    sepia<I extends JimpClass>(image: I): I;
    /**
     * Fades each pixel by a factor between 0 and 1
     * @param f A number from 0 to 1. 0 will haven no effect. 1 will turn the image completely transparent.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.fade(0.7);
     * ```
     */
    fade<I extends JimpClass>(image: I, f: number): I;
    /**
     * Adds each element of the image to its local neighbors, weighted by the kernel
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.convolute([
     *   [-1, -1, 0],
     *   [-1, 1, 1],
     *   [0, 1, 1],
     * ]);
     * ```
     */
    convolution<I extends JimpClass>(image: I, options: ConvolutionOptions): I;
    /**
     * Set the alpha channel on every pixel to fully opaque.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.opaque();
     * ```
     */
    opaque<I extends JimpClass>(image: I): I;
    /**
     * Pixelates the image or a region
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * // pixelate the whole image
     * image.pixelate(10);
     *
     * // pixelate a region
     * image.pixelate(10, 10, 10, 20, 20);
     * ```
     */
    pixelate<I extends JimpClass>(image: I, options: PixelateOptions): I;
    /**
     * Applies a convolution kernel to the image or a region
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * // apply a convolution kernel to the whole image
     * image.convolution([
     *   [-1, -1, 0],
     *   [-1, 1, 1],
     *   [0, 1, 1],
     * ]);
     *
     * // apply a convolution kernel to a region
     * image.convolution([
     *   [-1, -1, 0],
     *   [-1, 1, 1],
     *   [0, 1, 1],
     * ], 10, 10, 10, 20);
     * ```
     */
    convolute<I extends JimpClass>(image: I, options: ConvoluteOptions): I;
    /**
     * Apply multiple color modification rules
     * @param  actions list of color modification rules, in following format: { apply: '<rule-name>', params: [ <rule-parameters> ]  }
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.color([
     *   { apply: "hue", params: [-90] },
     *   { apply: "lighten", params: [50] },
     *   { apply: "xor", params: ["#06D"] },
     * ]);
     * ```
     */
    color<I extends JimpClass>(image: I, actions: ColorAction[]): I;
};
export {};
//# sourceMappingURL=index.d.ts.map