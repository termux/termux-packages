"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
const image_q_1 = require("image-q");
const zod_1 = __importDefault(require("zod"));
const QuantizeOptionsSchema = zod_1.default.object({
    colors: zod_1.default.number().optional(),
    colorDistanceFormula: zod_1.default
        .union([
        zod_1.default.literal("cie94-textiles"),
        zod_1.default.literal("cie94-graphic-arts"),
        zod_1.default.literal("ciede2000"),
        zod_1.default.literal("color-metric"),
        zod_1.default.literal("euclidean"),
        zod_1.default.literal("euclidean-bt709-noalpha"),
        zod_1.default.literal("euclidean-bt709"),
        zod_1.default.literal("manhattan"),
        zod_1.default.literal("manhattan-bt709"),
        zod_1.default.literal("manhattan-nommyde"),
        zod_1.default.literal("pngquant"),
    ])
        .optional(),
    paletteQuantization: zod_1.default
        .union([
        zod_1.default.literal("neuquant"),
        zod_1.default.literal("neuquant-float"),
        zod_1.default.literal("rgbquant"),
        zod_1.default.literal("wuquant"),
    ])
        .optional(),
    imageQuantization: zod_1.default
        .union([
        zod_1.default.literal("nearest"),
        zod_1.default.literal("riemersma"),
        zod_1.default.literal("floyd-steinberg"),
        zod_1.default.literal("false-floyd-steinberg"),
        zod_1.default.literal("stucki"),
        zod_1.default.literal("atkinson"),
        zod_1.default.literal("jarvis"),
        zod_1.default.literal("burkes"),
        zod_1.default.literal("sierra"),
        zod_1.default.literal("two-sierra"),
        zod_1.default.literal("sierra-lite"),
    ])
        .optional(),
});
exports.methods = {
    /**
     * Image color number reduction.
     */
    quantize(image, options) {
        const { colors, colorDistanceFormula, paletteQuantization, imageQuantization, } = QuantizeOptionsSchema.parse(options);
        const inPointContainer = image_q_1.utils.PointContainer.fromUint8Array(image.bitmap.data, image.bitmap.width, image.bitmap.height);
        const palette = (0, image_q_1.buildPaletteSync)([inPointContainer], {
            colors,
            colorDistanceFormula,
            paletteQuantization,
        });
        const outPointContainer = (0, image_q_1.applyPaletteSync)(inPointContainer, palette, {
            colorDistanceFormula,
            imageQuantization,
        });
        image.bitmap.data = Buffer.from(outPointContainer.toUint8Array());
        return image;
    },
};
//# sourceMappingURL=index.js.map