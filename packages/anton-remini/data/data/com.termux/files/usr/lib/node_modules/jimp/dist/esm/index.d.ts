/**
 * @module jimp
 */
import bmp, { msBmp } from "@jimp/js-bmp";
import gif from "@jimp/js-gif";
import jpeg from "@jimp/js-jpeg";
import png from "@jimp/js-png";
import tiff from "@jimp/js-tiff";
import * as blit from "@jimp/plugin-blit";
import * as circle from "@jimp/plugin-circle";
import * as color from "@jimp/plugin-color";
import * as contain from "@jimp/plugin-contain";
import * as cover from "@jimp/plugin-cover";
import * as crop from "@jimp/plugin-crop";
import * as displace from "@jimp/plugin-displace";
import * as fisheye from "@jimp/plugin-fisheye";
import * as flip from "@jimp/plugin-flip";
import * as mask from "@jimp/plugin-mask";
import * as print from "@jimp/plugin-print";
import * as resize from "@jimp/plugin-resize";
import * as rotate from "@jimp/plugin-rotate";
import * as threshold from "@jimp/plugin-threshold";
import * as quantize from "@jimp/plugin-quantize";
export declare const defaultPlugins: ({
    blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
} | {
    blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
    gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
} | {
    circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
} | {
    normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
    invert<I extends import("@jimp/types").JimpClass>(image: I): I;
    brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
    contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
    posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
    greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
    opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
    sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
    fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
    convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
        kernel: number[][];
        edgeHandling?: import("@jimp/types").Edge | undefined;
    } | number[][]): I;
    opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
    pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
        size: number;
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
        kernel: number[][];
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
} | {
    contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
} | {
    cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
} | {
    crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
    autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
} | {
    displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
} | {
    dither<I extends import("@jimp/types").JimpClass>(image: I): I;
} | {
    fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
} | {
    flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
} | {
    pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
    hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
    distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
} | {
    mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
} | {
    print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
        font: print.BmFont<I>;
    }): I;
} | {
    resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
    scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
    scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
} | {
    rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
} | {
    threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
} | {
    quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
})[];
export declare const defaultFormats: (typeof bmp | typeof msBmp | typeof gif | typeof jpeg | typeof png | typeof tiff)[];
/** Convenience object for getting the MIME types of the default formats */
export declare const JimpMime: {
    bmp: "image/bmp";
    gif: "image/gif";
    jpeg: "image/jpeg";
    png: "image/png";
    tiff: "image/tiff";
};
/**
 * @class
 *
 * A `Jimp` class enables you to:class
 *
 * - Read an image into a "bit map" (a collection of pixels)
 * - Modify the bit map through methods that change the pixels
 * - Write the bit map back to an image buffer
 *
 * @example
 *
 * #### Basic
 *
 * You can use the Jimp class to make empty images.
 * This is useful for when you want to create an image that composed of other images on top of a background.
 *
 * ```ts
 * import { Jimp } from "jimp";
 *
 * const image = new Jimp({ width: 256, height: 256, color: 0xffffffff });
 * const image2 = new Jimp({ width: 100, height: 100, color: 0xff0000ff });
 *
 * image.composite(image2, 50, 50);
 * ```
 *
 * #### Node
 *
 * You can use jimp in Node.js.
 * For example you can read an image from a file and resize it and
 * then write it back to a file.
 *
 * ```ts
 * import { Jimp } from "jimp";
 * import { promises as fs } from "fs";
 *
 * const image = await Jimp.read("test/image.png");
 *
 * image.resize(256, 100);
 * image.greyscale();
 *
 * await image.write('test/output.png');
 * ```
 *
 * #### Browser
 *
 * You can use jimp in the browser by reading files from URLs
 *
 * ```ts
 * import { Jimp } from "jimp";
 *
 * const image = await Jimp.read("https://upload.wikimedia.org/wikipedia/commons/0/01/Bot-Test.jpg");
 *
 * image.resize(256, 100);
 * image.greyscale();
 *
 * const output = await image.getBuffer("test/image.png");
 *
 * const canvas = document.createElement("canvas");
 *
 * canvas.width = image.bitmap.width;
 * canvas.height = image.bitmap.height;
 *
 * const ctx = canvas.getContext("2d");
 * ctx.putImageData(image.bitmap, 0, 0);
 *
 * document.body.appendChild(canvas);
 * ```
 */
export declare const Jimp: {
    new (options?: import("@jimp/core").JimpConstructorOptions): {
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    };
    read(url: string | Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/x-ms-bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/jpeg", import("@jimp/js-jpeg").DecodeJpegOptions> | Record<"image/png", import("@jimp/js-png").DecodePngOptions> | undefined): Promise<{
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    } & import("@jimp/core").JimpInstanceMethods<{
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, {
        blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
        invert<I extends import("@jimp/types").JimpClass>(image: I): I;
        brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
        greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
        opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
        fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: import("@jimp/types").Edge | undefined;
        } | number[][]): I;
        opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
        pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends import("@jimp/types").JimpClass>(image: I): I;
    } & {
        fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
        hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>>;
    fromBitmap(bitmap: import("@jimp/core").RawImageData): InstanceType<any> & import("@jimp/core").JimpInstanceMethods<{
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends ReturnType<typeof bmp | typeof msBmp | typeof gif | typeof jpeg | typeof png | typeof tiff>["mime"], Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends ReturnType<typeof bmp | typeof msBmp | typeof gif | typeof jpeg | typeof png | typeof tiff>["mime"], Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends any>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, {
        blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
        invert<I extends import("@jimp/types").JimpClass>(image: I): I;
        brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
        greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
        opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
        fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: import("@jimp/types").Edge | undefined;
        } | number[][]): I;
        opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
        pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends import("@jimp/types").JimpClass>(image: I): I;
    } & {
        fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
        hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>;
    fromBuffer(buffer: Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/x-ms-bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/jpeg", import("@jimp/js-jpeg").DecodeJpegOptions> | Record<"image/png", import("@jimp/js-png").DecodePngOptions> | undefined): Promise<{
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    } & import("@jimp/core").JimpInstanceMethods<{
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: import("@jimp/core").BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        scan(f: (x: number, y: number, idx: number) => any): any;
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, {
        blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
        invert<I extends import("@jimp/types").JimpClass>(image: I): I;
        brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
        posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
        greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
        opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
        fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
        convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: import("@jimp/types").Edge | undefined;
        } | number[][]): I;
        opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
        pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends import("@jimp/types").JimpClass>(image: I): I;
    } & {
        fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
        hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>>;
} & (new (...args: any[]) => import("@jimp/core").JimpInstanceMethods<{
    bitmap: import("@jimp/types").Bitmap;
    background: number;
    formats: import("@jimp/types").Format<any>[];
    mime?: string;
    inspect(): string;
    toString(): string;
    readonly width: number;
    readonly height: number;
    getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T ? T extends Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
    getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T ? T extends Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
    write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
        palette?: import("@jimp/js-bmp").BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", import("@jimp/js-jpeg").JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: import("@jimp/js-png").PNGFilterType;
        colorType?: import("@jimp/js-png").PNGColorType;
        inputColorType?: import("@jimp/js-png").PNGColorType;
    }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
    clone<S extends {
        new (options?: import("@jimp/core").JimpConstructorOptions): any;
        read(url: string | Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/x-ms-bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/jpeg", import("@jimp/js-jpeg").DecodeJpegOptions> | Record<"image/png", import("@jimp/js-png").DecodePngOptions> | undefined): Promise<any & import("@jimp/core").JimpInstanceMethods<any, {
            blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
            gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
            invert<I extends import("@jimp/types").JimpClass>(image: I): I;
            brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
            greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
            opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
            fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: import("@jimp/types").Edge | undefined;
            } | number[][]): I;
            opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
            pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends import("@jimp/types").JimpClass>(image: I): I;
        } & {
            fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
            hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>>;
        fromBitmap(bitmap: import("@jimp/core").RawImageData): InstanceType<any> & import("@jimp/core").JimpInstanceMethods<any, {
            blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
            gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
            invert<I extends import("@jimp/types").JimpClass>(image: I): I;
            brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
            greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
            opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
            fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: import("@jimp/types").Edge | undefined;
            } | number[][]): I;
            opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
            pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends import("@jimp/types").JimpClass>(image: I): I;
        } & {
            fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
            hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>;
        fromBuffer(buffer: Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/x-ms-bmp", import("@jimp/js-bmp").DecodeBmpOptions> | Record<"image/jpeg", import("@jimp/js-jpeg").DecodeJpegOptions> | Record<"image/png", import("@jimp/js-png").DecodePngOptions> | undefined): Promise<any & import("@jimp/core").JimpInstanceMethods<any, {
            blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
            gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
            invert<I extends import("@jimp/types").JimpClass>(image: I): I;
            brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
            posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
            greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
            opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
            fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
            convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: import("@jimp/types").Edge | undefined;
            } | number[][]): I;
            opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
            pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends import("@jimp/types").JimpClass>(image: I): I;
        } & {
            fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
            hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>>;
    }>(this: S): S;
    getPixelIndex(x: number, y: number, edgeHandling?: import("@jimp/types").Edge): number;
    getPixelColor(x: number, y: number): number;
    setPixelColor(hex: number, x: number, y: number): any;
    hasAlpha(): boolean;
    composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
        mode?: import("@jimp/core").BlendMode;
        opacitySource?: number;
        opacityDest?: number;
    }): any;
    scan(f: (x: number, y: number, idx: number) => any): any;
    scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
    scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
        x: number;
        y: number;
        idx: number;
        image: any;
    }, void, unknown>;
}, {
    blit<I extends import("@jimp/types").JimpClass>(image: I, options: blit.BlitOptions): I;
} & {
    blur<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
    gaussian<I extends import("@jimp/types").JimpClass>(image: I, r: number): I;
} & {
    circle<I extends import("@jimp/types").JimpClass>(image: I, options?: circle.CircleOptions): I;
} & {
    normalize<I extends import("@jimp/types").JimpClass>(image: I): I;
    invert<I extends import("@jimp/types").JimpClass>(image: I): I;
    brightness<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
    contrast<I extends import("@jimp/types").JimpClass>(image: I, val: number): I;
    posterize<I extends import("@jimp/types").JimpClass>(image: I, n: number): I;
    greyscale<I extends import("@jimp/types").JimpClass>(image: I): I;
    opacity<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
    sepia<I extends import("@jimp/types").JimpClass>(image: I): I;
    fade<I extends import("@jimp/types").JimpClass>(image: I, f: number): I;
    convolution<I extends import("@jimp/types").JimpClass>(image: I, options: {
        kernel: number[][];
        edgeHandling?: import("@jimp/types").Edge | undefined;
    } | number[][]): I;
    opaque<I extends import("@jimp/types").JimpClass>(image: I): I;
    pixelate<I extends import("@jimp/types").JimpClass>(image: I, options: number | {
        size: number;
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    convolute<I extends import("@jimp/types").JimpClass>(image: I, options: number[][] | {
        kernel: number[][];
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    color<I extends import("@jimp/types").JimpClass>(image: I, actions: color.ColorAction[]): I;
} & {
    contain<I extends import("@jimp/types").JimpClass>(image: I, options: contain.ContainOptions): I;
} & {
    cover<I extends import("@jimp/types").JimpClass>(image: I, options: cover.CoverOptions): I;
} & {
    crop<I extends import("@jimp/types").JimpClass>(image: I, options: crop.CropOptions): I;
    autocrop<I extends import("@jimp/types").JimpClass>(image: I, options?: crop.AutocropOptions): I;
} & {
    displace<I extends import("@jimp/types").JimpClass>(image: I, options: displace.DisplaceOptions): I;
} & {
    dither<I extends import("@jimp/types").JimpClass>(image: I): I;
} & {
    fisheye<I extends import("@jimp/types").JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
} & {
    flip<I extends import("@jimp/types").JimpClass>(image: I, options: flip.FlipOptions): I;
} & {
    pHash<I extends import("@jimp/types").JimpClass>(image: I): string;
    hash<I extends import("@jimp/types").JimpClass>(image: I, base?: number): string;
    distanceFromHash<I extends import("@jimp/types").JimpClass>(image: I, compareHash: string): number;
} & {
    mask<I extends import("@jimp/types").JimpClass>(image: I, options: mask.MaskOptions): I;
} & {
    print<I extends import("@jimp/types").JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
        font: print.BmFont<I>;
    }): I;
} & {
    resize<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ResizeOptions): I;
    scale<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleOptions): I;
    scaleToFit<I extends import("@jimp/types").JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
} & {
    rotate<I extends import("@jimp/types").JimpClass>(image: I, options: rotate.RotateOptions): I;
} & {
    threshold<I extends import("@jimp/types").JimpClass>(image: I, options: threshold.ThresholdOptions): I;
} & {
    quantize<I extends import("@jimp/types").JimpClass>(image: I, options: quantize.QuantizeOptions): I;
}>);
export type JimpInstance = InstanceType<typeof Jimp>;
export type { ColorAction, HueAction, MixAction, RedAction, XorAction, BlueAction, SpinAction, TintAction, GreenAction, ShadeAction, DarkenAction, LightenAction, BrightenAction, SaturateAction, GrayscaleAction, DesaturateAction, } from "@jimp/plugin-color";
export type { CircleOptions } from "@jimp/plugin-circle";
export type { AutocropOptions, CropOptions } from "@jimp/plugin-crop";
export { ResizeStrategy } from "@jimp/plugin-resize";
export type { ScaleOptions, ResizeOptions, ScaleToFitOptions, } from "@jimp/plugin-resize";
export type { ThresholdOptions } from "@jimp/plugin-threshold";
export { distance, compareHashes } from "@jimp/plugin-hash";
export type { JPEGOptions } from "@jimp/js-jpeg";
export { PNGColorType, PNGFilterType } from "@jimp/js-png";
export { BmpCompression } from "@jimp/js-bmp";
export type { EncodeOptions } from "@jimp/js-bmp";
export type { BmpColor } from "@jimp/js-bmp";
export { HorizontalAlign, VerticalAlign, BlendMode } from "@jimp/core";
export type { RawImageData, JimpConstructorOptions, JimpSimpleConstructorOptions, } from "@jimp/core";
export type { Bitmap, Edge, RGBAColor, RGBColor } from "@jimp/types";
export { loadFont } from "@jimp/plugin-print/load-font";
export { measureText, measureTextHeight } from "@jimp/plugin-print";
export { diff } from "@jimp/diff";
export { intToRGBA, rgbaToInt, colorDiff, limit255, cssColorToHex, } from "@jimp/utils";
export type { FlipOptions } from "@jimp/plugin-flip";
export type { FisheyeOptions } from "@jimp/plugin-fisheye";
export type { DisplaceOptions } from "@jimp/plugin-displace";
export type { CoverOptions } from "@jimp/plugin-cover";
export type { ContainOptions } from "@jimp/plugin-contain";
//# sourceMappingURL=index.d.ts.map