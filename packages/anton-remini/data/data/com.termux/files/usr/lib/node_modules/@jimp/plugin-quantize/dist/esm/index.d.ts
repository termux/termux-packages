import { JimpClass } from "@jimp/types";
import z from "zod";
declare const QuantizeOptionsSchema: z.ZodObject<{
    colors: z.ZodOptional<z.ZodNumber>;
    colorDistanceFormula: z.ZodOptional<z.ZodUnion<[z.ZodLiteral<"cie94-textiles">, z.ZodLiteral<"cie94-graphic-arts">, z.ZodLiteral<"ciede2000">, z.ZodLiteral<"color-metric">, z.ZodLiteral<"euclidean">, z.ZodLiteral<"euclidean-bt709-noalpha">, z.ZodLiteral<"euclidean-bt709">, z.ZodLiteral<"manhattan">, z.ZodLiteral<"manhattan-bt709">, z.ZodLiteral<"manhattan-nommyde">, z.ZodLiteral<"pngquant">]>>;
    paletteQuantization: z.ZodOptional<z.ZodUnion<[z.ZodLiteral<"neuquant">, z.ZodLiteral<"neuquant-float">, z.ZodLiteral<"rgbquant">, z.ZodLiteral<"wuquant">]>>;
    imageQuantization: z.ZodOptional<z.ZodUnion<[z.ZodLiteral<"nearest">, z.ZodLiteral<"riemersma">, z.ZodLiteral<"floyd-steinberg">, z.ZodLiteral<"false-floyd-steinberg">, z.ZodLiteral<"stucki">, z.ZodLiteral<"atkinson">, z.ZodLiteral<"jarvis">, z.ZodLiteral<"burkes">, z.ZodLiteral<"sierra">, z.ZodLiteral<"two-sierra">, z.ZodLiteral<"sierra-lite">]>>;
}, "strip", z.ZodTypeAny, {
    colors?: number | undefined;
    colorDistanceFormula?: "cie94-textiles" | "cie94-graphic-arts" | "ciede2000" | "color-metric" | "euclidean" | "euclidean-bt709-noalpha" | "euclidean-bt709" | "manhattan" | "manhattan-bt709" | "manhattan-nommyde" | "pngquant" | undefined;
    paletteQuantization?: "neuquant" | "neuquant-float" | "rgbquant" | "wuquant" | undefined;
    imageQuantization?: "nearest" | "riemersma" | "floyd-steinberg" | "false-floyd-steinberg" | "stucki" | "atkinson" | "jarvis" | "burkes" | "sierra" | "two-sierra" | "sierra-lite" | undefined;
}, {
    colors?: number | undefined;
    colorDistanceFormula?: "cie94-textiles" | "cie94-graphic-arts" | "ciede2000" | "color-metric" | "euclidean" | "euclidean-bt709-noalpha" | "euclidean-bt709" | "manhattan" | "manhattan-bt709" | "manhattan-nommyde" | "pngquant" | undefined;
    paletteQuantization?: "neuquant" | "neuquant-float" | "rgbquant" | "wuquant" | undefined;
    imageQuantization?: "nearest" | "riemersma" | "floyd-steinberg" | "false-floyd-steinberg" | "stucki" | "atkinson" | "jarvis" | "burkes" | "sierra" | "two-sierra" | "sierra-lite" | undefined;
}>;
export type QuantizeOptions = z.infer<typeof QuantizeOptionsSchema>;
export declare const methods: {
    /**
     * Image color number reduction.
     */
    quantize<I extends JimpClass>(image: I, options: QuantizeOptions): I;
};
export {};
//# sourceMappingURL=index.d.ts.map