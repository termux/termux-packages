import { HorizontalAlign, VerticalAlign } from "@jimp/core";
import { JimpClass } from "@jimp/types";
import { z } from "zod";
import { BmFont } from "./types.js";
export { measureText, measureTextHeight } from "./measure-text.js";
export * from "./types.js";
declare const PrintOptionsSchema: z.ZodObject<{
    /** the x position to draw the image */
    x: z.ZodNumber;
    /** the y position to draw the image */
    y: z.ZodNumber;
    /** the text to print */
    text: z.ZodUnion<[z.ZodUnion<[z.ZodString, z.ZodNumber]>, z.ZodObject<{
        text: z.ZodUnion<[z.ZodString, z.ZodNumber]>;
        alignmentX: z.ZodOptional<z.ZodNativeEnum<typeof HorizontalAlign>>;
        alignmentY: z.ZodOptional<z.ZodNativeEnum<typeof VerticalAlign>>;
    }, "strip", z.ZodTypeAny, {
        text: string | number;
        alignmentX?: HorizontalAlign | undefined;
        alignmentY?: VerticalAlign | undefined;
    }, {
        text: string | number;
        alignmentX?: HorizontalAlign | undefined;
        alignmentY?: VerticalAlign | undefined;
    }>]>;
    /** the boundary width to draw in */
    maxWidth: z.ZodOptional<z.ZodNumber>;
    /** the boundary height to draw in */
    maxHeight: z.ZodOptional<z.ZodNumber>;
    /** a callback for when complete that ahs the end co-ordinates of the text */
    cb: z.ZodOptional<z.ZodFunction<z.ZodTuple<[z.ZodObject<{
        x: z.ZodNumber;
        y: z.ZodNumber;
    }, "strip", z.ZodTypeAny, {
        x: number;
        y: number;
    }, {
        x: number;
        y: number;
    }>], null>, z.ZodUnknown>>;
}, "strip", z.ZodTypeAny, {
    x: number;
    y: number;
    text: string | number | {
        text: string | number;
        alignmentX?: HorizontalAlign | undefined;
        alignmentY?: VerticalAlign | undefined;
    };
    maxWidth?: number | undefined;
    maxHeight?: number | undefined;
    cb?: ((args_0: {
        x: number;
        y: number;
    }) => unknown) | undefined;
}, {
    x: number;
    y: number;
    text: string | number | {
        text: string | number;
        alignmentX?: HorizontalAlign | undefined;
        alignmentY?: VerticalAlign | undefined;
    };
    maxWidth?: number | undefined;
    maxHeight?: number | undefined;
    cb?: ((args_0: {
        x: number;
        y: number;
    }) => unknown) | undefined;
}>;
export type PrintOptions = z.infer<typeof PrintOptionsSchema>;
export declare const methods: {
    /**
     * Draws a text on a image on a given boundary
     * @param font a bitmap font loaded from `Jimp.loadFont` command
     * @param x the x position to start drawing the text
     * @param y the y position to start drawing the text
     * @param text the text to draw (string or object with `text`, `alignmentX`, and/or `alignmentY`)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     * const font = await Jimp.loadFont(Jimp.FONT_SANS_32_BLACK);
     *
     * image.print({ font, x: 10, y: 10, text: "Hello world!" });
     * ```
     */
    print<I extends JimpClass>(image: I, { font, ...options }: PrintOptions & {
        /** the BMFont instance */
        font: BmFont<I>;
    }): I;
};
//# sourceMappingURL=index.d.ts.map