import tinyColor from "tinycolor2";
export function clone(image) {
    const newBitmap = {
        width: image.bitmap.width,
        height: image.bitmap.height,
        data: Buffer.from(image.bitmap.data),
    };
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return new image.constructor(newBitmap);
}
export function scan(image, 
// eslint-disable-next-line @typescript-eslint/no-explicit-any
xArg, yArg, wArg, hArg, 
// eslint-disable-next-line @typescript-eslint/no-explicit-any
cbArg) {
    let x;
    let y;
    let w;
    let h;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    let cb;
    if (typeof xArg === "function") {
        cb = xArg;
        x = 0;
        y = 0;
        w = image.bitmap.width;
        h = image.bitmap.height;
    }
    else {
        x = xArg;
        if (typeof yArg !== "number")
            throw new Error("y must be a number");
        y = yArg;
        if (typeof wArg !== "number")
            throw new Error("w must be a number");
        w = wArg;
        if (typeof hArg !== "number")
            throw new Error("h must be a number");
        h = hArg;
        if (typeof cbArg !== "function")
            throw new Error("cb must be a function");
        cb = cbArg;
    }
    // round input
    x = Math.round(x);
    y = Math.round(y);
    w = Math.round(w);
    h = Math.round(h);
    const bound = cb.bind(image);
    for (let _y = y; _y < y + h; _y++) {
        for (let _x = x; _x < x + w; _x++) {
            const idx = (image.bitmap.width * _y + _x) << 2;
            // Bind the images so this.bitmap works
            bound(_x, _y, idx);
        }
    }
    return image;
}
export function* scanIterator(image, x, y, w, h) {
    // round input
    x = Math.round(x);
    y = Math.round(y);
    w = Math.round(w);
    h = Math.round(h);
    for (let _y = y; _y < y + h; _y++) {
        for (let _x = x; _x < x + w; _x++) {
            const idx = (image.bitmap.width * _y + _x) << 2;
            yield { x: _x, y: _y, idx, image };
        }
    }
}
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
export function intToRGBA(i) {
    if (typeof i !== "number") {
        throw new Error("i must be a number");
    }
    const rgba = {
        r: 0,
        g: 0,
        b: 0,
        a: 0,
    };
    rgba.r = Math.floor(i / Math.pow(256, 3));
    rgba.g = Math.floor((i - rgba.r * Math.pow(256, 3)) / Math.pow(256, 2));
    rgba.b = Math.floor((i - rgba.r * Math.pow(256, 3) - rgba.g * Math.pow(256, 2)) /
        Math.pow(256, 1));
    rgba.a = Math.floor((i -
        rgba.r * Math.pow(256, 3) -
        rgba.g * Math.pow(256, 2) -
        rgba.b * Math.pow(256, 1)) /
        Math.pow(256, 0));
    return rgba;
}
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
export function rgbaToInt(r, g, b, a) {
    if (typeof r !== "number" ||
        typeof g !== "number" ||
        typeof b !== "number" ||
        typeof a !== "number") {
        throw new Error("r, g, b and a must be numbers");
    }
    if (r < 0 || r > 255) {
        throw new Error("r must be between 0 and 255");
    }
    if (g < 0 || g > 255) {
        throw new Error("g must be between 0 and 255");
    }
    if (b < 0 || b > 255) {
        throw new Error("b must be between 0 and 255");
    }
    if (a < 0 || a > 255) {
        throw new Error("a must be between 0 and 255");
    }
    let i = r & 0xff;
    i <<= 8;
    i |= g & 0xff;
    i <<= 8;
    i |= b & 0xff;
    i <<= 8;
    i |= a & 0xff;
    // Ensure sign is correct
    i >>>= 0;
    return i;
}
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
export function colorDiff(rgba1, rgba2) {
    const sq = (n) => Math.pow(n, 2);
    const { max } = Math;
    const maxVal = 255 * 255 * 3;
    const rgba1A = "a" in rgba1 ? rgba1.a : 255;
    const rgba2A = "a" in rgba2 ? rgba2.a : 255;
    return ((max(sq(rgba1.r - rgba2.r), sq(rgba1.r - rgba2.r - rgba1A + rgba2A)) +
        max(sq(rgba1.g - rgba2.g), sq(rgba1.g - rgba2.g - rgba1A + rgba2A)) +
        max(sq(rgba1.b - rgba2.b), sq(rgba1.b - rgba2.b - rgba1A + rgba2A))) /
        maxVal);
}
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
export function limit255(n) {
    n = Math.max(n, 0);
    n = Math.min(n, 255);
    return n;
}
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
export function cssColorToHex(cssColor) {
    if (typeof cssColor === "number") {
        return cssColor;
    }
    return parseInt(tinyColor(cssColor).toHex8(), 16);
}
//# sourceMappingURL=index.js.map