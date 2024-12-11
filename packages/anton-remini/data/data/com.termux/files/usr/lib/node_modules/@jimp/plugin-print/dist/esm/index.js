import { HorizontalAlign, VerticalAlign } from "@jimp/core";
import { methods as blitMethods } from "@jimp/plugin-blit";
import { z } from "zod";
import { measureText, measureTextHeight, splitLines } from "./measure-text.js";
export { measureText, measureTextHeight } from "./measure-text.js";
export * from "./types.js";
const PrintOptionsSchema = z.object({
    /** the x position to draw the image */
    x: z.number(),
    /** the y position to draw the image */
    y: z.number(),
    /** the text to print */
    text: z.union([
        z.union([z.string(), z.number()]),
        z.object({
            text: z.union([z.string(), z.number()]),
            alignmentX: z.nativeEnum(HorizontalAlign).optional(),
            alignmentY: z.nativeEnum(VerticalAlign).optional(),
        }),
    ]),
    /** the boundary width to draw in */
    maxWidth: z.number().optional(),
    /** the boundary height to draw in */
    maxHeight: z.number().optional(),
    /** a callback for when complete that ahs the end co-ordinates of the text */
    cb: z
        .function(z.tuple([z.object({ x: z.number(), y: z.number() })]))
        .optional(),
});
function xOffsetBasedOnAlignment(font, line, maxWidth, alignment) {
    if (alignment === HorizontalAlign.LEFT) {
        return 0;
    }
    if (alignment === HorizontalAlign.CENTER) {
        return (maxWidth - measureText(font, line)) / 2;
    }
    return maxWidth - measureText(font, line);
}
function drawCharacter(image, font, x, y, char) {
    if (char.width > 0 && char.height > 0) {
        const characterPage = font.pages[char.page];
        if (characterPage) {
            image = blitMethods.blit(image, {
                src: characterPage,
                x: x + char.xoffset,
                y: y + char.yoffset,
                srcX: char.x,
                srcY: char.y,
                srcW: char.width,
                srcH: char.height,
            });
        }
    }
    return image;
}
function printText(image, font, x, y, text, defaultCharWidth) {
    for (let i = 0; i < text.length; i++) {
        const stringChar = text[i];
        let char;
        if (font.chars[stringChar]) {
            char = stringChar;
        }
        else if (/\s/.test(stringChar)) {
            char = "";
        }
        else {
            char = "?";
        }
        const fontChar = font.chars[char] || { xadvance: undefined };
        const fontKerning = font.kernings[char];
        if (fontChar) {
            drawCharacter(image, font, x, y, fontChar);
        }
        const nextChar = text[i + 1];
        const kerning = fontKerning && nextChar && fontKerning[nextChar]
            ? fontKerning[nextChar] || 0
            : 0;
        x += kerning + (fontChar.xadvance || defaultCharWidth);
    }
}
export const methods = {
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
    print(image, { font, ...options }) {
        let { 
        // eslint-disable-next-line prefer-const
        x, y, text, 
        // eslint-disable-next-line prefer-const
        maxWidth = Infinity, 
        // eslint-disable-next-line prefer-const
        maxHeight = Infinity, 
        // eslint-disable-next-line prefer-const
        cb = () => { }, } = PrintOptionsSchema.parse(options);
        let alignmentX;
        let alignmentY;
        if (typeof text === "object" &&
            text.text !== null &&
            text.text !== undefined) {
            alignmentX = text.alignmentX || HorizontalAlign.LEFT;
            alignmentY = text.alignmentY || VerticalAlign.TOP;
            ({ text } = text);
        }
        else {
            alignmentX = HorizontalAlign.LEFT;
            alignmentY = VerticalAlign.TOP;
            text = text.toString();
        }
        if (typeof text === "number") {
            text = text.toString();
        }
        if (maxHeight !== Infinity && alignmentY === VerticalAlign.BOTTOM) {
            y += maxHeight - measureTextHeight(font, text, maxWidth);
        }
        else if (maxHeight !== Infinity && alignmentY === VerticalAlign.MIDDLE) {
            y += maxHeight / 2 - measureTextHeight(font, text, maxWidth) / 2;
        }
        const defaultCharWidth = Object.entries(font.chars).find((c) => c[1].xadvance)?.[1].xadvance;
        if (typeof defaultCharWidth !== "number") {
            throw new Error("Could not find default character width");
        }
        const { lines, longestLine } = splitLines(font, text, maxWidth);
        lines.forEach((line) => {
            const lineString = line.join(" ");
            const alignmentWidth = xOffsetBasedOnAlignment(font, lineString, maxWidth, alignmentX);
            printText(image, font, x + alignmentWidth, y, lineString, defaultCharWidth);
            y += font.common.lineHeight;
        });
        cb.bind(image)({ x: x + longestLine, y });
        return image;
    },
};
//# sourceMappingURL=index.js.map