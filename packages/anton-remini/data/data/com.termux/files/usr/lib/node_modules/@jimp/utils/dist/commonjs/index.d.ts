import { RGBAColor, JimpClass, Bitmap, RGBColor } from "@jimp/types";
export declare function clone<I extends JimpClass>(image: I): I;
export declare function scan<I extends JimpClass>(image: I, f: (this: I, x: number, y: number, idx: number) => any): I;
export declare function scan<I extends {
    bitmap: Bitmap;
}>(image: I, x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): I;
export declare function scanIterator<I extends JimpClass>(image: I, x: number, y: number, w: number, h: number): Generator<{
    x: number;
    y: number;
    idx: number;
    image: I;
}, void, unknown>;
/**
 * A helper method that converts RGBA values to a single integer value
 * @param i A single integer value representing an RGBA colour (e.g. 0xFF0000FF for red)
 * @returns An object with the properties r, g, b and a representing RGBA values
 * @example
 * ```ts
 * import { intToRGBA } from "@jimp/utils";
 *
 * intToRGBA(0xFF0000FF); // { r: 255, g: 0, b: 0, a:255 }
 * ```
 */
export declare function intToRGBA(i: number): RGBAColor;
/**
 * A static helper method that converts RGBA values to a single integer value
 * @param r the red value (0-255)
 * @param g the green value (0-255)
 * @param b the blue value (0-255)
 * @param a the alpha value (0-255)
 * @example
 * ```ts
 * import { rgbaToInt } from "@jimp/utils";
 *
 * rgbaToInt(255, 0, 0, 255); // 0xFF0000FF
 * ```
 */
export declare function rgbaToInt(r: number, g: number, b: number, a: number): number;
/**
 * Compute color difference
 * 0 means no difference, 1 means maximum difference.
 * Both parameters must be an color object `{ r:val, g:val, b:val, a:val }`
 * Where `a` is optional and `val` is an integer between 0 and 255.
 * @param rgba1 first color to compare.
 * @param rgba2 second color to compare.
 * @returns float between 0 and 1.
 * @example
 * ```ts
 * import { colorDiff } from "@jimp/utils";
 *
 * colorDiff(
 *  { r: 255, g: 0, b: 0, a: 0 },
 *  { r: 0, g: 255, b: 0, a: 0 },
 * ); // 0.5
 *
 * colorDiff(
 *  { r: 0, g: 0, b: 0, },
 *  { r: 255, g: 255, b: 255, }
 * ); // 0.7
 * ```
 */
export declare function colorDiff(rgba1: RGBAColor | RGBColor, rgba2: RGBAColor | RGBColor): number;
/**
 * Limits a number to between 0 or 255
 * @example
 * ```ts
 * import { limit255 } from "@jimp/utils";
 *
 * limit255(256); // 255
 * limit255(-1); // 0
 * ```
 */
export declare function limit255(n: number): number;
/**
 * Converts a css color (Hex, 8-digit (RGBA) Hex, RGB, RGBA, HSL, HSLA, HSV, HSVA, Named) to a hex number
 * @returns A hex number representing a color
 * @example
 * ```ts
 * import { cssColorToHex } from "@jimp/utils";
 *
 * cssColorToHex("rgba(255, 0, 0, 0.5)"); // "ff000080"
 * ```
 */
export declare function cssColorToHex(cssColor: string | number): number;
//# sourceMappingURL=index.d.ts.map