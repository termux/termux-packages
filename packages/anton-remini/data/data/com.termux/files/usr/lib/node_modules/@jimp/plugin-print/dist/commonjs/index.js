"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(exports, p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = exports.measureTextHeight = exports.measureText = void 0;
const core_1 = require("@jimp/core");
const plugin_blit_1 = require("@jimp/plugin-blit");
const zod_1 = require("zod");
const measure_text_js_1 = require("./measure-text.js");
var measure_text_js_2 = require("./measure-text.js");
Object.defineProperty(exports, "measureText", { enumerable: true, get: function () { return measure_text_js_2.measureText; } });
Object.defineProperty(exports, "measureTextHeight", { enumerable: true, get: function () { return measure_text_js_2.measureTextHeight; } });
__exportStar(require("./types.js"), exports);
const PrintOptionsSchema = zod_1.z.object({
    /** the x position to draw the image */
    x: zod_1.z.number(),
    /** the y position to draw the image */
    y: zod_1.z.number(),
    /** the text to print */
    text: zod_1.z.union([
        zod_1.z.union([zod_1.z.string(), zod_1.z.number()]),
        zod_1.z.object({
            text: zod_1.z.union([zod_1.z.string(), zod_1.z.number()]),
            alignmentX: zod_1.z.nativeEnum(core_1.HorizontalAlign).optional(),
            alignmentY: zod_1.z.nativeEnum(core_1.VerticalAlign).optional(),
        }),
    ]),
    /** the boundary width to draw in */
    maxWidth: zod_1.z.number().optional(),
    /** the boundary height to draw in */
    maxHeight: zod_1.z.number().optional(),
    /** a callback for when complete that ahs the end co-ordinates of the text */
    cb: zod_1.z
        .function(zod_1.z.tuple([zod_1.z.object({ x: zod_1.z.number(), y: zod_1.z.number() })]))
        .optional(),
});
function xOffsetBasedOnAlignment(font, line, maxWidth, alignment) {
    if (alignment === core_1.HorizontalAlign.LEFT) {
        return 0;
    }
    if (alignment === core_1.HorizontalAlign.CENTER) {
        return (maxWidth - (0, measure_text_js_1.measureText)(font, line)) / 2;
    }
    return maxWidth - (0, measure_text_js_1.measureText)(font, line);
}
function drawCharacter(image, font, x, y, char) {
    if (char.width > 0 && char.height > 0) {
        const characterPage = font.pages[char.page];
        if (characterPage) {
            image = plugin_blit_1.methods.blit(image, {
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
exports.methods = {
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
            alignmentX = text.alignmentX || core_1.HorizontalAlign.LEFT;
            alignmentY = text.alignmentY || core_1.VerticalAlign.TOP;
            ({ text } = text);
        }
        else {
            alignmentX = core_1.HorizontalAlign.LEFT;
            alignmentY = core_1.VerticalAlign.TOP;
            text = text.toString();
        }
        if (typeof text === "number") {
            text = text.toString();
        }
        if (maxHeight !== Infinity && alignmentY === core_1.VerticalAlign.BOTTOM) {
            y += maxHeight - (0, measure_text_js_1.measureTextHeight)(font, text, maxWidth);
        }
        else if (maxHeight !== Infinity && alignmentY === core_1.VerticalAlign.MIDDLE) {
            y += maxHeight / 2 - (0, measure_text_js_1.measureTextHeight)(font, text, maxWidth) / 2;
        }
        const defaultCharWidth = Object.entries(font.chars).find((c) => c[1].xadvance)?.[1].xadvance;
        if (typeof defaultCharWidth !== "number") {
            throw new Error("Could not find default character width");
        }
        const { lines, longestLine } = (0, measure_text_js_1.splitLines)(font, text, maxWidth);
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