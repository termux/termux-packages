import * as _jimp_js_png from '@jimp/js-png';
import _jimp_js_png__default from '@jimp/js-png';
export { PNGColorType, PNGFilterType } from '@jimp/js-png';
import * as _jimp_js_jpeg from '@jimp/js-jpeg';
import _jimp_js_jpeg__default from '@jimp/js-jpeg';
export { JPEGOptions } from '@jimp/js-jpeg';
import * as _jimp_js_bmp from '@jimp/js-bmp';
import _jimp_js_bmp__default, { msBmp } from '@jimp/js-bmp';
export { BmpColor, BmpCompression, EncodeOptions } from '@jimp/js-bmp';
import * as _jimp_core from '@jimp/core';
export { BlendMode, HorizontalAlign, JimpConstructorOptions, JimpSimpleConstructorOptions, RawImageData, VerticalAlign } from '@jimp/core';
import * as _jimp_types from '@jimp/types';
export { Bitmap, Edge, RGBAColor, RGBColor } from '@jimp/types';
import gif from '@jimp/js-gif';
import tiff from '@jimp/js-tiff';
import * as blit from '@jimp/plugin-blit';
import * as circle from '@jimp/plugin-circle';
export { CircleOptions } from '@jimp/plugin-circle';
import * as color from '@jimp/plugin-color';
export { BlueAction, BrightenAction, ColorAction, DarkenAction, DesaturateAction, GrayscaleAction, GreenAction, HueAction, LightenAction, MixAction, RedAction, SaturateAction, ShadeAction, SpinAction, TintAction, XorAction } from '@jimp/plugin-color';
import * as contain from '@jimp/plugin-contain';
export { ContainOptions } from '@jimp/plugin-contain';
import * as cover from '@jimp/plugin-cover';
export { CoverOptions } from '@jimp/plugin-cover';
import * as crop from '@jimp/plugin-crop';
export { AutocropOptions, CropOptions } from '@jimp/plugin-crop';
import * as displace from '@jimp/plugin-displace';
export { DisplaceOptions } from '@jimp/plugin-displace';
import * as fisheye from '@jimp/plugin-fisheye';
export { FisheyeOptions } from '@jimp/plugin-fisheye';
import * as flip from '@jimp/plugin-flip';
export { FlipOptions } from '@jimp/plugin-flip';
import * as mask from '@jimp/plugin-mask';
import * as print from '@jimp/plugin-print';
export { measureText, measureTextHeight } from '@jimp/plugin-print';
import * as resize from '@jimp/plugin-resize';
export { ResizeOptions, ResizeStrategy, ScaleOptions, ScaleToFitOptions } from '@jimp/plugin-resize';
import * as rotate from '@jimp/plugin-rotate';
import * as threshold from '@jimp/plugin-threshold';
export { ThresholdOptions } from '@jimp/plugin-threshold';
import * as quantize from '@jimp/plugin-quantize';
export { compareHashes, distance } from '@jimp/plugin-hash';
export { loadFont } from '@jimp/plugin-print/load-font';
export { diff } from '@jimp/diff';
export { colorDiff, cssColorToHex, intToRGBA, limit255, rgbaToInt } from '@jimp/utils';

declare const defaultPlugins: ({
    blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
} | {
    blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
    gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
} | {
    circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
} | {
    normalize<I extends _jimp_types.JimpClass>(image: I): I;
    invert<I extends _jimp_types.JimpClass>(image: I): I;
    brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
    contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
    posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
    greyscale<I extends _jimp_types.JimpClass>(image: I): I;
    opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
    sepia<I extends _jimp_types.JimpClass>(image: I): I;
    fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
    convolution<I extends _jimp_types.JimpClass>(image: I, options: {
        kernel: number[][];
        edgeHandling?: _jimp_types.Edge | undefined;
    } | number[][]): I;
    opaque<I extends _jimp_types.JimpClass>(image: I): I;
    pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
        size: number;
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
        kernel: number[][];
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
} | {
    contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
} | {
    cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
} | {
    crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
    autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
} | {
    displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
} | {
    dither<I extends _jimp_types.JimpClass>(image: I): I;
} | {
    fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
} | {
    flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
} | {
    pHash<I extends _jimp_types.JimpClass>(image: I): string;
    hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
    distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
} | {
    mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
} | {
    print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
        font: print.BmFont<I>;
    }): I;
} | {
    resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
    scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
    scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
} | {
    rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
} | {
    threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
} | {
    quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
})[];
declare const defaultFormats: (typeof _jimp_js_bmp__default | typeof msBmp | typeof gif | typeof _jimp_js_jpeg__default | typeof _jimp_js_png__default | typeof tiff)[];
/** Convenience object for getting the MIME types of the default formats */
declare const JimpMime: {
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
declare const Jimp: {
    new (options?: _jimp_core.JimpConstructorOptions): {
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
    read(url: string | Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/x-ms-bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/jpeg", _jimp_js_jpeg.DecodeJpegOptions> | Record<"image/png", _jimp_js_png.DecodePngOptions> | undefined): Promise<{
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
    } & _jimp_core.JimpInstanceMethods<{
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
        blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends _jimp_types.JimpClass>(image: I): I;
        invert<I extends _jimp_types.JimpClass>(image: I): I;
        brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
        greyscale<I extends _jimp_types.JimpClass>(image: I): I;
        opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        sepia<I extends _jimp_types.JimpClass>(image: I): I;
        fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        convolution<I extends _jimp_types.JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: _jimp_types.Edge | undefined;
        } | number[][]): I;
        opaque<I extends _jimp_types.JimpClass>(image: I): I;
        pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends _jimp_types.JimpClass>(image: I): I;
    } & {
        fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends _jimp_types.JimpClass>(image: I): string;
        hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>>;
    fromBitmap(bitmap: _jimp_core.RawImageData): InstanceType<any> & _jimp_core.JimpInstanceMethods<{
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends ReturnType<typeof _jimp_js_bmp__default | typeof msBmp | typeof gif | typeof _jimp_js_jpeg__default | typeof _jimp_js_png__default | typeof tiff>["mime"], Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends ReturnType<typeof _jimp_js_bmp__default | typeof msBmp | typeof gif | typeof _jimp_js_jpeg__default | typeof _jimp_js_png__default | typeof tiff>["mime"], Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends any>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
        blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends _jimp_types.JimpClass>(image: I): I;
        invert<I extends _jimp_types.JimpClass>(image: I): I;
        brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
        greyscale<I extends _jimp_types.JimpClass>(image: I): I;
        opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        sepia<I extends _jimp_types.JimpClass>(image: I): I;
        fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        convolution<I extends _jimp_types.JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: _jimp_types.Edge | undefined;
        } | number[][]): I;
        opaque<I extends _jimp_types.JimpClass>(image: I): I;
        pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends _jimp_types.JimpClass>(image: I): I;
    } & {
        fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends _jimp_types.JimpClass>(image: I): string;
        hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>;
    fromBuffer(buffer: Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/x-ms-bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/jpeg", _jimp_js_jpeg.DecodeJpegOptions> | Record<"image/png", _jimp_js_png.DecodePngOptions> | undefined): Promise<{
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
    } & _jimp_core.JimpInstanceMethods<{
        bitmap: _jimp_types.Bitmap;
        background: number;
        formats: _jimp_types.Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T ? T extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
            palette?: _jimp_js_bmp.BmpColor[] | undefined;
            colors?: number | undefined;
            importantColors?: number | undefined;
            hr?: number | undefined;
            vr?: number | undefined;
            reserved1?: number | undefined;
            reserved2?: number | undefined;
        }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: _jimp_js_png.PNGFilterType;
            colorType?: _jimp_js_png.PNGColorType;
            inputColorType?: _jimp_js_png.PNGColorType;
        }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        clone<S extends unknown>(this: S): S;
        getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
        getPixelColor(x: number, y: number): number;
        setPixelColor(hex: number, x: number, y: number): any;
        hasAlpha(): boolean;
        composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
            mode?: _jimp_core.BlendMode;
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
        blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
    } & {
        blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
    } & {
        circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
    } & {
        normalize<I extends _jimp_types.JimpClass>(image: I): I;
        invert<I extends _jimp_types.JimpClass>(image: I): I;
        brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
        posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
        greyscale<I extends _jimp_types.JimpClass>(image: I): I;
        opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        sepia<I extends _jimp_types.JimpClass>(image: I): I;
        fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
        convolution<I extends _jimp_types.JimpClass>(image: I, options: {
            kernel: number[][];
            edgeHandling?: _jimp_types.Edge | undefined;
        } | number[][]): I;
        opaque<I extends _jimp_types.JimpClass>(image: I): I;
        pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
            size: number;
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
            kernel: number[][];
            x?: number | undefined;
            y?: number | undefined;
            w?: number | undefined;
            h?: number | undefined;
        }): I;
        color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
    } & {
        contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
    } & {
        cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
    } & {
        crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
        autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
    } & {
        displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
    } & {
        dither<I extends _jimp_types.JimpClass>(image: I): I;
    } & {
        fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
    } & {
        flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
    } & {
        pHash<I extends _jimp_types.JimpClass>(image: I): string;
        hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
        distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
    } & {
        mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
    } & {
        print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
            font: print.BmFont<I>;
        }): I;
    } & {
        resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
        scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
        scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
    } & {
        rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
    } & {
        threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
    } & {
        quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
    }>>;
} & (new (...args: any[]) => _jimp_core.JimpInstanceMethods<{
    bitmap: _jimp_types.Bitmap;
    background: number;
    formats: _jimp_types.Format<any>[];
    mime?: string;
    inspect(): string;
    toString(): string;
    readonly width: number;
    readonly height: number;
    getBuffer<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T ? T extends Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
    getBase64<ProvidedMimeType extends "image/bmp" | "image/tiff" | "image/x-ms-bmp" | "image/gif" | "image/jpeg" | "image/png", Options extends (Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T ? T extends Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_1 ? T_1 extends Record<"image/tiff", Record<string, any> | undefined> ? T_1 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_2 ? T_2 extends Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_2 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_3 ? T_3 extends Record<"image/gif", Record<string, any> | undefined> ? T_3 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_4 ? T_4 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_4 extends Record<ProvidedMimeType, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> extends infer T_5 ? T_5 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> ? T_5 extends Record<ProvidedMimeType, infer O> ? O : never : never : never)>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
    write<Extension extends string, Mime extends (Record<"bmp", "image/bmp"> extends infer T ? T extends Record<"bmp", "image/bmp"> ? T extends Record<Extension, infer M> ? M : never : never : never) | (Record<"tiff", "image/tiff"> extends infer T_1 ? T_1 extends Record<"tiff", "image/tiff"> ? T_1 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"x-ms-bmp", "image/x-ms-bmp"> extends infer T_2 ? T_2 extends Record<"x-ms-bmp", "image/x-ms-bmp"> ? T_2 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"gif", "image/gif"> extends infer T_3 ? T_3 extends Record<"gif", "image/gif"> ? T_3 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"jpeg", "image/jpeg"> extends infer T_4 ? T_4 extends Record<"jpeg", "image/jpeg"> ? T_4 extends Record<Extension, infer M> ? M : never : never : never) | (Record<"png", "image/png"> extends infer T_5 ? T_5 extends Record<"png", "image/png"> ? T_5 extends Record<Extension, infer M> ? M : never : never : never), Options extends (Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_6 ? T_6 extends Record<"image/bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_6 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/tiff", Record<string, any> | undefined> extends infer T_7 ? T_7 extends Record<"image/tiff", Record<string, any> | undefined> ? T_7 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> extends infer T_8 ? T_8 extends Record<"image/x-ms-bmp", {
        palette?: _jimp_js_bmp.BmpColor[] | undefined;
        colors?: number | undefined;
        importantColors?: number | undefined;
        hr?: number | undefined;
        vr?: number | undefined;
        reserved1?: number | undefined;
        reserved2?: number | undefined;
    }> ? T_8 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/gif", Record<string, any> | undefined> extends infer T_9 ? T_9 extends Record<"image/gif", Record<string, any> | undefined> ? T_9 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> extends infer T_10 ? T_10 extends Record<"image/jpeg", _jimp_js_jpeg.JPEGOptions> ? T_10 extends Record<Mime, infer O> ? O : never : never : never) | (Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> extends infer T_11 ? T_11 extends Record<"image/png", Omit<_jimp_js_png.PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
        filterType?: _jimp_js_png.PNGFilterType;
        colorType?: _jimp_js_png.PNGColorType;
        inputColorType?: _jimp_js_png.PNGColorType;
    }> ? T_11 extends Record<Mime, infer O> ? O : never : never : never)>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
    clone<S extends {
        new (options?: _jimp_core.JimpConstructorOptions): any;
        read(url: string | Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/x-ms-bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/jpeg", _jimp_js_jpeg.DecodeJpegOptions> | Record<"image/png", _jimp_js_png.DecodePngOptions> | undefined): Promise<any & _jimp_core.JimpInstanceMethods<any, {
            blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
            gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends _jimp_types.JimpClass>(image: I): I;
            invert<I extends _jimp_types.JimpClass>(image: I): I;
            brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
            greyscale<I extends _jimp_types.JimpClass>(image: I): I;
            opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            sepia<I extends _jimp_types.JimpClass>(image: I): I;
            fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            convolution<I extends _jimp_types.JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: _jimp_types.Edge | undefined;
            } | number[][]): I;
            opaque<I extends _jimp_types.JimpClass>(image: I): I;
            pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends _jimp_types.JimpClass>(image: I): I;
        } & {
            fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends _jimp_types.JimpClass>(image: I): string;
            hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>>;
        fromBitmap(bitmap: _jimp_core.RawImageData): InstanceType<any> & _jimp_core.JimpInstanceMethods<any, {
            blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
            gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends _jimp_types.JimpClass>(image: I): I;
            invert<I extends _jimp_types.JimpClass>(image: I): I;
            brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
            greyscale<I extends _jimp_types.JimpClass>(image: I): I;
            opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            sepia<I extends _jimp_types.JimpClass>(image: I): I;
            fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            convolution<I extends _jimp_types.JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: _jimp_types.Edge | undefined;
            } | number[][]): I;
            opaque<I extends _jimp_types.JimpClass>(image: I): I;
            pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends _jimp_types.JimpClass>(image: I): I;
        } & {
            fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends _jimp_types.JimpClass>(image: I): string;
            hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>;
        fromBuffer(buffer: Buffer | ArrayBuffer, options?: Record<"image/tiff", Record<string, any> | undefined> | Record<"image/gif", Record<string, any> | undefined> | Record<"image/bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/x-ms-bmp", _jimp_js_bmp.DecodeBmpOptions> | Record<"image/jpeg", _jimp_js_jpeg.DecodeJpegOptions> | Record<"image/png", _jimp_js_png.DecodePngOptions> | undefined): Promise<any & _jimp_core.JimpInstanceMethods<any, {
            blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
        } & {
            blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
            gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
        } & {
            circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
        } & {
            normalize<I extends _jimp_types.JimpClass>(image: I): I;
            invert<I extends _jimp_types.JimpClass>(image: I): I;
            brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
            posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
            greyscale<I extends _jimp_types.JimpClass>(image: I): I;
            opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            sepia<I extends _jimp_types.JimpClass>(image: I): I;
            fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
            convolution<I extends _jimp_types.JimpClass>(image: I, options: {
                kernel: number[][];
                edgeHandling?: _jimp_types.Edge | undefined;
            } | number[][]): I;
            opaque<I extends _jimp_types.JimpClass>(image: I): I;
            pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
                size: number;
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
                kernel: number[][];
                x?: number | undefined;
                y?: number | undefined;
                w?: number | undefined;
                h?: number | undefined;
            }): I;
            color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
        } & {
            contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
        } & {
            cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
        } & {
            crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
            autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
        } & {
            displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
        } & {
            dither<I extends _jimp_types.JimpClass>(image: I): I;
        } & {
            fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
        } & {
            flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
        } & {
            pHash<I extends _jimp_types.JimpClass>(image: I): string;
            hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
            distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
        } & {
            mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
        } & {
            print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
                font: print.BmFont<I>;
            }): I;
        } & {
            resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
            scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
            scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
        } & {
            rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
        } & {
            threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
        } & {
            quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
        }>>;
    }>(this: S): S;
    getPixelIndex(x: number, y: number, edgeHandling?: _jimp_types.Edge): number;
    getPixelColor(x: number, y: number): number;
    setPixelColor(hex: number, x: number, y: number): any;
    hasAlpha(): boolean;
    composite<I extends unknown>(src: I, x?: number, y?: number, options?: {
        mode?: _jimp_core.BlendMode;
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
    blit<I extends _jimp_types.JimpClass>(image: I, options: blit.BlitOptions): I;
} & {
    blur<I extends _jimp_types.JimpClass>(image: I, r: number): I;
    gaussian<I extends _jimp_types.JimpClass>(image: I, r: number): I;
} & {
    circle<I extends _jimp_types.JimpClass>(image: I, options?: circle.CircleOptions): I;
} & {
    normalize<I extends _jimp_types.JimpClass>(image: I): I;
    invert<I extends _jimp_types.JimpClass>(image: I): I;
    brightness<I extends _jimp_types.JimpClass>(image: I, val: number): I;
    contrast<I extends _jimp_types.JimpClass>(image: I, val: number): I;
    posterize<I extends _jimp_types.JimpClass>(image: I, n: number): I;
    greyscale<I extends _jimp_types.JimpClass>(image: I): I;
    opacity<I extends _jimp_types.JimpClass>(image: I, f: number): I;
    sepia<I extends _jimp_types.JimpClass>(image: I): I;
    fade<I extends _jimp_types.JimpClass>(image: I, f: number): I;
    convolution<I extends _jimp_types.JimpClass>(image: I, options: {
        kernel: number[][];
        edgeHandling?: _jimp_types.Edge | undefined;
    } | number[][]): I;
    opaque<I extends _jimp_types.JimpClass>(image: I): I;
    pixelate<I extends _jimp_types.JimpClass>(image: I, options: number | {
        size: number;
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    convolute<I extends _jimp_types.JimpClass>(image: I, options: number[][] | {
        kernel: number[][];
        x?: number | undefined;
        y?: number | undefined;
        w?: number | undefined;
        h?: number | undefined;
    }): I;
    color<I extends _jimp_types.JimpClass>(image: I, actions: color.ColorAction[]): I;
} & {
    contain<I extends _jimp_types.JimpClass>(image: I, options: contain.ContainOptions): I;
} & {
    cover<I extends _jimp_types.JimpClass>(image: I, options: cover.CoverOptions): I;
} & {
    crop<I extends _jimp_types.JimpClass>(image: I, options: crop.CropOptions): I;
    autocrop<I extends _jimp_types.JimpClass>(image: I, options?: crop.AutocropOptions): I;
} & {
    displace<I extends _jimp_types.JimpClass>(image: I, options: displace.DisplaceOptions): I;
} & {
    dither<I extends _jimp_types.JimpClass>(image: I): I;
} & {
    fisheye<I extends _jimp_types.JimpClass>(image: I, options?: fisheye.FisheyeOptions): I;
} & {
    flip<I extends _jimp_types.JimpClass>(image: I, options: flip.FlipOptions): I;
} & {
    pHash<I extends _jimp_types.JimpClass>(image: I): string;
    hash<I extends _jimp_types.JimpClass>(image: I, base?: number): string;
    distanceFromHash<I extends _jimp_types.JimpClass>(image: I, compareHash: string): number;
} & {
    mask<I extends _jimp_types.JimpClass>(image: I, options: mask.MaskOptions): I;
} & {
    print<I extends _jimp_types.JimpClass>(image: I, { font, ...options }: print.PrintOptions & {
        font: print.BmFont<I>;
    }): I;
} & {
    resize<I extends _jimp_types.JimpClass>(image: I, options: resize.ResizeOptions): I;
    scale<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleOptions): I;
    scaleToFit<I extends _jimp_types.JimpClass>(image: I, options: resize.ScaleToFitOptions): I;
} & {
    rotate<I extends _jimp_types.JimpClass>(image: I, options: rotate.RotateOptions): I;
} & {
    threshold<I extends _jimp_types.JimpClass>(image: I, options: threshold.ThresholdOptions): I;
} & {
    quantize<I extends _jimp_types.JimpClass>(image: I, options: quantize.QuantizeOptions): I;
}>);
type JimpInstance = InstanceType<typeof Jimp>;

export { Jimp, type JimpInstance, JimpMime, defaultFormats, defaultPlugins };
