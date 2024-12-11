/**
 * Loads a Bitmap Font from a file.
 * @param file A path or URL to a font file
 * @returns A collection of Jimp images that can be used to print text
 * @example
 * ```ts
 * import { Jimp, loadFont } from "jimp";
 * import { SANS_10_BLACK } from "jimp/fonts";
 *
 * const font = await loadFont(SANS_10_BLACK);
 * const image = new Jimp({ width: 200, height: 100, color: 0xffffffff });
 *
 * image.print(font, 10, 10, "Hello world!");
 * ```
 */
export declare function loadFont(file: string): Promise<{
    chars: Record<string, import("./types.js").BmCharacter>;
    kernings: Record<string, import("./types.js").BmKerning>;
    pages: ({
        bitmap: import("@jimp/types").Bitmap;
        background: number;
        formats: import("@jimp/types").Format<any>[];
        mime?: string;
        inspect(): string;
        toString(): string;
        readonly width: number;
        readonly height: number;
        getBuffer<ProvidedMimeType extends "image/png", Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T ? T extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/png", Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T ? T extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends Record<"png", "image/png"> extends infer T ? T extends Record<"png", "image/png"> ? T extends Record<Extension, infer M> ? M : never : never : never, Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_1 ? T_1 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_1 extends Record<Mime, infer O> ? O : never : never : never>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
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
        getBuffer<ProvidedMimeType extends "image/png", Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T ? T extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        getBase64<ProvidedMimeType extends "image/png", Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T ? T extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T extends Record<ProvidedMimeType, infer O> ? O : never : never : never>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        write<Extension extends string, Mime extends Record<"png", "image/png"> extends infer T ? T extends Record<"png", "image/png"> ? T extends Record<Extension, infer M> ? M : never : never : never, Options extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> extends infer T_1 ? T_1 extends Record<"image/png", Omit<import("@jimp/js-png").PNGJSOptions, "filterType" | "colorType" | "inputColorType"> & {
            filterType?: import("@jimp/js-png").PNGFilterType;
            colorType?: import("@jimp/js-png").PNGColorType;
            inputColorType?: import("@jimp/js-png").PNGColorType;
        }> ? T_1 extends Record<Mime, infer O> ? O : never : never : never>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
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
    }, import("@jimp/core").JimpPlugin>)[];
    common: import("./types.js").BmCommonProps;
    info: Record<string, any>;
}>;
//# sourceMappingURL=load-font.d.ts.map