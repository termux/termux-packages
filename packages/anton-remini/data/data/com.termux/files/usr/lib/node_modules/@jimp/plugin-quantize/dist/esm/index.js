import { applyPaletteSync, buildPaletteSync, utils } from "image-q";
import z from "zod";
const QuantizeOptionsSchema = z.object({
    colors: z.number().optional(),
    colorDistanceFormula: z
        .union([
        z.literal("cie94-textiles"),
        z.literal("cie94-graphic-arts"),
        z.literal("ciede2000"),
        z.literal("color-metric"),
        z.literal("euclidean"),
        z.literal("euclidean-bt709-noalpha"),
        z.literal("euclidean-bt709"),
        z.literal("manhattan"),
        z.literal("manhattan-bt709"),
        z.literal("manhattan-nommyde"),
        z.literal("pngquant"),
    ])
        .optional(),
    paletteQuantization: z
        .union([
        z.literal("neuquant"),
        z.literal("neuquant-float"),
        z.literal("rgbquant"),
        z.literal("wuquant"),
    ])
        .optional(),
    imageQuantization: z
        .union([
        z.literal("nearest"),
        z.literal("riemersma"),
        z.literal("floyd-steinberg"),
        z.literal("false-floyd-steinberg"),
        z.literal("stucki"),
        z.literal("atkinson"),
        z.literal("jarvis"),
        z.literal("burkes"),
        z.literal("sierra"),
        z.literal("two-sierra"),
        z.literal("sierra-lite"),
    ])
        .optional(),
});
export const methods = {
    /**
     * Image color number reduction.
     */
    quantize(image, options) {
        const { colors, colorDistanceFormula, paletteQuantization, imageQuantization, } = QuantizeOptionsSchema.parse(options);
        const inPointContainer = utils.PointContainer.fromUint8Array(image.bitmap.data, image.bitmap.width, image.bitmap.height);
        const palette = buildPaletteSync([inPointContainer], {
            colors,
            colorDistanceFormula,
            paletteQuantization,
        });
        const outPointContainer = applyPaletteSync(inPointContainer, palette, {
            colorDistanceFormula,
            imageQuantization,
        });
        image.bitmap.data = Buffer.from(outPointContainer.toUint8Array());
        return image;
    },
};
//# sourceMappingURL=index.js.map