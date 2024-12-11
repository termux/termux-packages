"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = exports.ColorActionName = void 0;
const tinycolor2_1 = __importDefault(require("tinycolor2"));
const utils_1 = require("@jimp/utils");
const types_1 = require("@jimp/types");
const zod_1 = require("zod");
const ConvolutionMatrixSchema = zod_1.z.array(zod_1.z.number()).min(1).array();
const ConvolutionComplexOptionsSchema = zod_1.z.object({
    /** a matrix to weight the neighbors sum */
    kernel: ConvolutionMatrixSchema,
    /**define how to sum pixels from outside the border */
    edgeHandling: zod_1.z.nativeEnum(types_1.Edge).optional(),
});
const ConvolutionOptionsSchema = zod_1.z.union([
    ConvolutionMatrixSchema,
    ConvolutionComplexOptionsSchema,
]);
const ConvoluteComplexOptionsSchema = zod_1.z.object({
    /** the convolution kernel */
    kernel: ConvolutionMatrixSchema,
    /** the x position of the region to apply convolution to */
    x: zod_1.z.number().optional(),
    /** the y position of the region to apply convolution to */
    y: zod_1.z.number().optional(),
    /** the width of the region to apply convolution to */
    w: zod_1.z.number().optional(),
    /** the height of the region to apply convolution to */
    h: zod_1.z.number().optional(),
});
const ConvoluteOptionsSchema = zod_1.z.union([
    ConvolutionMatrixSchema,
    ConvoluteComplexOptionsSchema,
]);
const PixelateSize = zod_1.z.number().min(1).max(Infinity);
const PixelateComplexOptionsSchema = zod_1.z.object({
    /** the size of the pixels */
    size: PixelateSize,
    /** the x position of the region to pixelate */
    x: zod_1.z.number().optional(),
    /** the y position of the region to pixelate */
    y: zod_1.z.number().optional(),
    /** the width of the region to pixelate */
    w: zod_1.z.number().optional(),
    /** the height of the region to pixelate */
    h: zod_1.z.number().optional(),
});
const PixelateOptionsSchema = zod_1.z.union([
    PixelateSize,
    PixelateComplexOptionsSchema,
]);
function applyKernel(image, kernel, x, y) {
    const value = [0, 0, 0, 0];
    const size = (kernel.length - 1) / 2;
    for (let kx = 0; kx < kernel.length; kx += 1) {
        for (let ky = 0; ky < kernel[kx].length; ky += 1) {
            const idx = image.getPixelIndex(x + kx - size, y + ky - size);
            value[0] += image.bitmap.data[idx] * kernel[kx][ky];
            value[1] += image.bitmap.data[idx + 1] * kernel[kx][ky];
            value[2] += image.bitmap.data[idx + 2] * kernel[kx][ky];
            value[3] += image.bitmap.data[idx + 3] * kernel[kx][ky];
        }
    }
    return value;
}
function mix(clr, clr2, p = 50) {
    return {
        r: (clr2.r - clr.r) * (p / 100) + clr.r,
        g: (clr2.g - clr.g) * (p / 100) + clr.g,
        b: (clr2.b - clr.b) * (p / 100) + clr.b,
    };
}
const HueActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("hue"),
    params: zod_1.z.tuple([zod_1.z.number().min(-360).max(360)]),
});
const SpinActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("spin"),
    params: zod_1.z.tuple([zod_1.z.number().min(-360).max(360)]),
});
const LightenActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("lighten"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const RGBColorSchema = zod_1.z.object({
    r: zod_1.z.number().min(0).max(255),
    g: zod_1.z.number().min(0).max(255),
    b: zod_1.z.number().min(0).max(255),
});
const MixActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("mix"),
    params: zod_1.z.union([
        zod_1.z.tuple([RGBColorSchema]),
        zod_1.z.tuple([RGBColorSchema, zod_1.z.number().min(0).max(100)]),
    ]),
});
const TintActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("tint"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const ShadeActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("shade"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const XorActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("xor"),
    params: zod_1.z.tuple([RGBColorSchema]),
});
const RedActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("red"),
    params: zod_1.z.tuple([zod_1.z.number().min(-255).max(255)]),
});
const GreenActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("green"),
    params: zod_1.z.tuple([zod_1.z.number().min(-255).max(255)]),
});
const BlueActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("blue"),
    params: zod_1.z.tuple([zod_1.z.number().min(-255).max(255)]),
});
const BrightenActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("brighten"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const DarkenActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("darken"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const DesaturateActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("desaturate"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const SaturateActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("saturate"),
    params: zod_1.z.tuple([zod_1.z.number().min(0).max(100)]).optional(),
});
const GrayscaleActionSchema = zod_1.z.object({
    apply: zod_1.z.literal("greyscale"),
    params: zod_1.z.tuple([]).optional(),
});
const ColorActionNameSchema = zod_1.z.union([
    HueActionSchema,
    SpinActionSchema,
    LightenActionSchema,
    MixActionSchema,
    TintActionSchema,
    ShadeActionSchema,
    XorActionSchema,
    RedActionSchema,
    GreenActionSchema,
    BlueActionSchema,
    BrightenActionSchema,
    DarkenActionSchema,
    DesaturateActionSchema,
    SaturateActionSchema,
    GrayscaleActionSchema,
]);
exports.ColorActionName = Object.freeze({
    LIGHTEN: "lighten",
    BRIGHTEN: "brighten",
    DARKEN: "darken",
    DESATURATE: "desaturate",
    SATURATE: "saturate",
    GREYSCALE: "greyscale",
    SPIN: "spin",
    HUE: "hue",
    MIX: "mix",
    TINT: "tint",
    SHADE: "shade",
    XOR: "xor",
    RED: "red",
    GREEN: "green",
    BLUE: "blue",
});
/**
 * Get an image's histogram
 * @return An object with an array of color occurrence counts for each channel (r,g,b)
 */
function histogram(image) {
    const histogram = {
        r: new Array(256).fill(0),
        g: new Array(256).fill(0),
        b: new Array(256).fill(0),
    };
    image.scan((_, __, index) => {
        histogram.r[image.bitmap.data[index + 0]]++;
        histogram.g[image.bitmap.data[index + 1]]++;
        histogram.b[image.bitmap.data[index + 2]]++;
    });
    return histogram;
}
/**
 * Normalize values
 * @param  value Pixel channel value.
 * @param  min   Minimum value for channel
 * @param  max   Maximum value for channel
 */
const normalizeValue = function (value, min, max) {
    return ((value - min) * 255) / (max - min);
};
const getBounds = function (histogramChannel) {
    return [
        histogramChannel.findIndex((value) => value > 0),
        255 -
            histogramChannel
                .slice()
                .reverse()
                .findIndex((value) => value > 0),
    ];
};
exports.methods = {
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
    normalize(image) {
        const h = histogram(image);
        // store bounds (minimum and maximum values)
        const bounds = {
            r: getBounds(h.r),
            g: getBounds(h.g),
            b: getBounds(h.b),
        };
        // apply value transformations
        image.scan((_, __, idx) => {
            const r = image.bitmap.data[idx + 0];
            const g = image.bitmap.data[idx + 1];
            const b = image.bitmap.data[idx + 2];
            image.bitmap.data[idx + 0] = normalizeValue(r, bounds.r[0], bounds.r[1]);
            image.bitmap.data[idx + 1] = normalizeValue(g, bounds.g[0], bounds.g[1]);
            image.bitmap.data[idx + 2] = normalizeValue(b, bounds.b[0], bounds.b[1]);
        });
        return image;
    },
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
    invert(image) {
        image.scan((_, __, idx) => {
            image.bitmap.data[idx] = 255 - image.bitmap.data[idx];
            image.bitmap.data[idx + 1] = 255 - image.bitmap.data[idx + 1];
            image.bitmap.data[idx + 2] = 255 - image.bitmap.data[idx + 2];
        });
        return image;
    },
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
    brightness(image, val) {
        if (typeof val !== "number") {
            throw new Error("val must be numbers");
        }
        image.scan((_, __, idx) => {
            image.bitmap.data[idx] = (0, utils_1.limit255)(image.bitmap.data[idx] * val);
            image.bitmap.data[idx + 1] = (0, utils_1.limit255)(image.bitmap.data[idx + 1] * val);
            image.bitmap.data[idx + 2] = (0, utils_1.limit255)(image.bitmap.data[idx + 2] * val);
        });
        return image;
    },
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
    contrast(image, val) {
        if (typeof val !== "number") {
            throw new Error("val must be numbers");
        }
        if (val < -1 || val > +1) {
            throw new Error("val must be a number between -1 and +1");
        }
        const factor = (val + 1) / (1 - val);
        function adjust(value) {
            value = Math.floor(factor * (value - 127) + 127);
            return value < 0 ? 0 : value > 255 ? 255 : value;
        }
        image.scan((_, __, idx) => {
            image.bitmap.data[idx] = adjust(image.bitmap.data[idx]);
            image.bitmap.data[idx + 1] = adjust(image.bitmap.data[idx + 1]);
            image.bitmap.data[idx + 2] = adjust(image.bitmap.data[idx + 2]);
        });
        return image;
    },
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
    posterize(image, n) {
        if (typeof n !== "number") {
            throw new Error("n must be numbers");
        }
        // minimum of 2 levels
        if (n < 2) {
            n = 2;
        }
        image.scan((_, __, idx) => {
            const r = image.bitmap.data[idx];
            const g = image.bitmap.data[idx + 1];
            const b = image.bitmap.data[idx + 2];
            image.bitmap.data[idx] =
                (Math.floor((r / 255) * (n - 1)) / (n - 1)) * 255;
            image.bitmap.data[idx + 1] =
                (Math.floor((g / 255) * (n - 1)) / (n - 1)) * 255;
            image.bitmap.data[idx + 2] =
                (Math.floor((b / 255) * (n - 1)) / (n - 1)) * 255;
        });
        return image;
    },
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
    greyscale(image) {
        image.scan((_, __, idx) => {
            // const grey = parseInt(
            //   0.2126 * image.bitmap.data[idx]! +
            //     0.7152 * image.bitmap.data[idx + 1]! +
            //     0.0722 * image.bitmap.data[idx + 2]!,
            //   10
            // );
            const grey = 0.2126 * image.bitmap.data[idx] +
                0.7152 * image.bitmap.data[idx + 1] +
                0.0722 * image.bitmap.data[idx + 2];
            image.bitmap.data[idx] = grey;
            image.bitmap.data[idx + 1] = grey;
            image.bitmap.data[idx + 2] = grey;
        });
        return image;
    },
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
    opacity(image, f) {
        if (typeof f !== "number") {
            throw new Error("f must be a number");
        }
        if (f < 0 || f > 1) {
            throw new Error("f must be a number from 0 to 1");
        }
        image.scan((_, __, idx) => {
            const v = image.bitmap.data[idx + 3] * f;
            image.bitmap.data[idx + 3] = v;
        });
        return image;
    },
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
    sepia(image) {
        image.scan((_, __, idx) => {
            let red = image.bitmap.data[idx];
            let green = image.bitmap.data[idx + 1];
            let blue = image.bitmap.data[idx + 2];
            red = red * 0.393 + green * 0.769 + blue * 0.189;
            green = red * 0.349 + green * 0.686 + blue * 0.168;
            blue = red * 0.272 + green * 0.534 + blue * 0.131;
            image.bitmap.data[idx] = red < 255 ? red : 255;
            image.bitmap.data[idx + 1] = green < 255 ? green : 255;
            image.bitmap.data[idx + 2] = blue < 255 ? blue : 255;
        });
        return image;
    },
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
    fade(image, f) {
        if (typeof f !== "number") {
            throw new Error("f must be a number");
        }
        if (f < 0 || f > 1) {
            throw new Error("f must be a number from 0 to 1");
        }
        // this method is an alternative to opacity (which may be deprecated)
        return this.opacity(image, 1 - f);
    },
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
    convolution(image, options) {
        const parsed = ConvolutionOptionsSchema.parse(options);
        const { kernel, edgeHandling = types_1.Edge.EXTEND } = "kernel" in parsed ? parsed : { kernel: parsed, edgeHandling: undefined };
        if (!kernel[0]) {
            throw new Error("kernel must be a matrix");
        }
        const newData = Buffer.from(image.bitmap.data);
        const kRows = kernel.length;
        const kCols = kernel[0].length;
        const rowEnd = Math.floor(kRows / 2);
        const colEnd = Math.floor(kCols / 2);
        const rowIni = -rowEnd;
        const colIni = -colEnd;
        let weight;
        let rSum;
        let gSum;
        let bSum;
        let ri;
        let gi;
        let bi;
        let xi;
        let yi;
        let idxi;
        image.scan((x, y, idx) => {
            bSum = 0;
            gSum = 0;
            rSum = 0;
            for (let row = rowIni; row <= rowEnd; row++) {
                for (let col = colIni; col <= colEnd; col++) {
                    xi = x + col;
                    yi = y + row;
                    weight = kernel[row + rowEnd][col + colEnd];
                    idxi = image.getPixelIndex(xi, yi, edgeHandling);
                    if (idxi === -1) {
                        bi = 0;
                        gi = 0;
                        ri = 0;
                    }
                    else {
                        ri = image.bitmap.data[idxi + 0];
                        gi = image.bitmap.data[idxi + 1];
                        bi = image.bitmap.data[idxi + 2];
                    }
                    rSum += weight * ri;
                    gSum += weight * gi;
                    bSum += weight * bi;
                }
            }
            if (rSum < 0) {
                rSum = 0;
            }
            if (gSum < 0) {
                gSum = 0;
            }
            if (bSum < 0) {
                bSum = 0;
            }
            if (rSum > 255) {
                rSum = 255;
            }
            if (gSum > 255) {
                gSum = 255;
            }
            if (bSum > 255) {
                bSum = 255;
            }
            newData[idx + 0] = rSum;
            newData[idx + 1] = gSum;
            newData[idx + 2] = bSum;
        });
        image.bitmap.data = newData;
        return image;
    },
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
    opaque(image) {
        image.scan((_, __, idx) => {
            image.bitmap.data[idx + 3] = 255;
        });
        return image;
    },
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
    pixelate(image, options) {
        const parsed = PixelateOptionsSchema.parse(options);
        const { size, x = 0, y = 0, w = image.bitmap.width - x, h = image.bitmap.height - y, } = typeof parsed === "number"
            ? { size: parsed }
            : parsed;
        const kernel = [
            [1 / 16, 2 / 16, 1 / 16],
            [2 / 16, 4 / 16, 2 / 16],
            [1 / 16, 2 / 16, 1 / 16],
        ];
        const source = (0, utils_1.clone)(image);
        (0, utils_1.scan)(source, x, y, w, h, (xx, yx, idx) => {
            xx = size * Math.floor(xx / size);
            yx = size * Math.floor(yx / size);
            const value = applyKernel(source, kernel, xx, yx);
            image.bitmap.data[idx] = value[0];
            image.bitmap.data[idx + 1] = value[1];
            image.bitmap.data[idx + 2] = value[2];
            image.bitmap.data[idx + 3] = value[3];
        });
        return image;
    },
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
    convolute(image, options) {
        const parsed = ConvoluteOptionsSchema.parse(options);
        const { kernel, x = 0, y = 0, w = image.bitmap.width - x, h = image.bitmap.height - y, } = "kernel" in parsed
            ? parsed
            : { kernel: parsed };
        const source = (0, utils_1.clone)(image);
        (0, utils_1.scan)(source, x, y, w, h, (xx, yx, idx) => {
            const value = applyKernel(source, kernel, xx, yx);
            image.bitmap.data[idx] = (0, utils_1.limit255)(value[0]);
            image.bitmap.data[idx + 1] = (0, utils_1.limit255)(value[1]);
            image.bitmap.data[idx + 2] = (0, utils_1.limit255)(value[2]);
            image.bitmap.data[idx + 3] = (0, utils_1.limit255)(value[3]);
        });
        return image;
    },
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
    color(image, actions) {
        if (!actions || !Array.isArray(actions)) {
            throw new Error("actions must be an array");
        }
        actions.forEach((action) => ColorActionNameSchema.parse(action));
        actions = actions.map((action) => {
            if (action.apply === "xor" || action.apply === "mix") {
                action.params[0] = (0, tinycolor2_1.default)(action.params[0]).toRgb();
            }
            return action;
        });
        image.scan((_, __, idx) => {
            let clr = {
                r: image.bitmap.data[idx],
                g: image.bitmap.data[idx + 1],
                b: image.bitmap.data[idx + 2],
            };
            const colorModifier = (i, amount) => (0, utils_1.limit255)(clr[i] + amount);
            actions.forEach((action) => {
                if (action.apply === "mix") {
                    clr = mix(clr, action.params[0], action.params[1]);
                }
                else if (action.apply === "tint") {
                    clr = mix(clr, { r: 255, g: 255, b: 255 }, action.params?.[0]);
                }
                else if (action.apply === "shade") {
                    clr = mix(clr, { r: 0, g: 0, b: 0 }, action.params?.[0]);
                }
                else if (action.apply === "xor") {
                    clr = {
                        r: clr.r ^ action.params[0].r,
                        g: clr.g ^ action.params[0].g,
                        b: clr.b ^ action.params[0].b,
                    };
                }
                else if (action.apply === "red") {
                    clr.r = colorModifier("r", action.params[0]);
                }
                else if (action.apply === "green") {
                    clr.g = colorModifier("g", action.params[0]);
                }
                else if (action.apply === "blue") {
                    clr.b = colorModifier("b", action.params[0]);
                }
                else {
                    if (action.apply === "hue") {
                        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                        // @ts-ignore
                        action.apply = "spin";
                    }
                    const tnyClr = (0, tinycolor2_1.default)(clr);
                    const fn = tnyClr[action.apply].bind(tnyClr);
                    if (!fn) {
                        throw new Error("action " + action.apply + " not supported");
                    }
                    // eslint-disable-next-line @typescript-eslint/no-explicit-any
                    clr = fn(...(action.params || [])).toRgb();
                }
            });
            image.bitmap.data[idx] = clr.r;
            image.bitmap.data[idx + 1] = clr.g;
            image.bitmap.data[idx + 2] = clr.b;
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map