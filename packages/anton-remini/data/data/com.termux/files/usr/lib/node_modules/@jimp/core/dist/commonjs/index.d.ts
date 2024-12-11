import { Bitmap, Format, JimpClass, Edge } from "@jimp/types";
import { BlendMode } from "./index.js";
export { getExifOrientation } from "./utils/image-bitmap.js";
export { composite } from "./utils/composite.js";
export * from "./utils/constants.js";
export interface RawImageData {
    width: number;
    height: number;
    data: Buffer | Uint8Array | Uint8ClampedArray | number[];
}
/**
 * Instead of loading an image into an instance you can initialize a new Jimp instance with a empty bitmap.
 */
export interface JimpSimpleConstructorOptions {
    height: number;
    width: number;
    /**
     * Initialize the image with a color for each pixel
     */
    color?: number | string;
}
export type JimpConstructorOptions = Bitmap | JimpSimpleConstructorOptions;
/** Converts a jimp plugin function to a Jimp class method */
type JimpInstanceMethod<ClassInstance, MethodMap, Method> = Method extends JimpChainableMethod<infer Args> ? (...args: Args) => JimpInstanceMethods<ClassInstance, MethodMap> & ClassInstance : Method extends JimpMethod<infer Args, infer Return> ? (...args: Args) => Return : never;
/** Converts a Record of jimp plugin functions to a Record of Jimp class methods */
export type JimpInstanceMethods<ClassInstance, MethodMap> = {
    [Key in keyof MethodMap]: JimpInstanceMethod<ClassInstance, MethodMap, MethodMap[Key]>;
};
/** A Jimp instance method that can be chained. */
type JimpChainableMethod<Args extends any[] = any[], J extends JimpClass = JimpClass> = (img: J, ...args: Args) => J;
/** A Jimp instance method that returns anything. */
type JimpMethod<Args extends any[] = any[], ReturnType = any, J extends JimpClass = JimpClass> = (img: J, ...args: Args) => ReturnType;
export interface JimpPlugin {
    [key: string]: JimpChainableMethod | JimpMethod;
}
type UnionToIntersection<U> = (U extends any ? (k: U) => void : never) extends (k: infer I) => void ? I : never;
type Constructor<T> = new (...args: any[]) => T;
type JimpFormat<MimeType extends string = string, EncodeOptions extends Record<string, any> | undefined = undefined, DecodeOptions extends Record<string, any> | undefined = undefined, T extends Format<MimeType, EncodeOptions, DecodeOptions> = Format<MimeType, EncodeOptions, DecodeOptions>> = () => T;
type CreateMimeTypeToExportOptions<T extends Format<string, any>> = T extends Format<infer M, infer O> ? Record<M, O> : never;
type CreateMimeTypeToDecodeOptions<T extends Format<string, any>> = T extends Format<infer M, any, infer O> ? Record<M, O> : never;
type GetOptionsForMimeType<Mime extends string, MimeTypeMap> = MimeTypeMap extends Record<Mime, infer O> ? O : never;
type MimeToExtension<M extends string> = `${string}/${M}`;
type CreateExtensionToMimeType<M extends string> = M extends MimeToExtension<infer E> ? Record<E, M> : never;
type GetMimeTypeForExtension<Mime extends string, MimeTypeMap> = MimeTypeMap extends Record<Mime, infer M> ? M : never;
/**
 * Create a Jimp class that support the given image formats and methods
 */
export declare function createJimp<Methods extends JimpPlugin[], Formats extends JimpFormat[]>({ plugins: pluginsArg, formats: formatsArg, }?: {
    /** Plugins that add methods to the created Jimp class */
    plugins?: Methods;
    /** Image formats the Jimp class should support */
    formats?: Formats;
}): {
    new (options?: JimpConstructorOptions): {
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    };
    /**
     * Create a Jimp instance from a URL, a file path, or a Buffer
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * // Read from a file path
     * const image = await Jimp.read("test/image.png");
     *
     * // Read from a URL
     * const image = await Jimp.read("https://upload.wikimedia.org/wikipedia/commons/0/01/Bot-Test.jpg");
     * ```
     */
    read(url: string | Buffer | ArrayBuffer, options?: CreateMimeTypeToDecodeOptions<ReturnType<Formats[number]>>): Promise<{
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    } & JimpInstanceMethods<{
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, UnionToIntersection<Methods[number]>>>;
    /**
     * Create a Jimp instance from a bitmap.
     * The difference between this and just using the constructor is that this will
     * convert raw image data into the bitmap format that Jimp uses.
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = Jimp.fromBitmap({
     *   data: Buffer.from([
     *     0xffffffff, 0xffffffff, 0xffffffff,
     *     0xffffffff, 0xffffffff, 0xffffffff,
     *     0xffffffff, 0xffffffff, 0xffffffff,
     *   ]),
     *   width: 3,
     *   height: 3,
     * });
     * ```
     */
    fromBitmap(bitmap: RawImageData): InstanceType<any> & JimpInstanceMethods<{
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, UnionToIntersection<Methods[number]>>;
    /**
     * Parse a bitmap with the loaded image types.
     *
     * @param buffer Raw image data
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const buffer = await fs.readFile("test/image.png");
     * const image = await Jimp.fromBuffer(buffer);
     * ```
     */
    fromBuffer(buffer: Buffer | ArrayBuffer, options?: CreateMimeTypeToDecodeOptions<ReturnType<Formats[number]>>): Promise<{
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    } & JimpInstanceMethods<{
        /**
         * The bitmap data of the image
         */
        bitmap: Bitmap;
        /**  Default color to use for new pixels */
        background: number;
        /** Formats that can be used with Jimp */
        formats: Format<any>[];
        /** The original MIME type of the image */
        mime?: string;
        /**
         * Nicely format Jimp object when sent to the console e.g. console.log(image)
         * @returns Pretty printed jimp object
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = await Jimp.read("test/image.png");
         *
         * console.log(image);
         * ```
         */
        inspect(): string;
        /**
         * Nicely format Jimp object when converted to a string
         * @returns pretty printed
         */
        toString(): string;
        /** Get the width of the image */
        readonly width: number;
        /** Get the height of the image */
        readonly height: number;
        /**
         * Converts the Jimp instance to an image buffer
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         * import { promises as fs } from "fs";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * await image.write("test/output.jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
        /**
         * Converts the image to a base 64 string
         *
         * @param mime The mime type to export to
         * @param options The options to use when exporting
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * const base64 = image.getBase64("image/jpeg", {
         *   quality: 50,
         * });
         * ```
         */
        getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
        /**
         * Write the image to a file
         * @param path the path to write the image to
         * @param options the options to use when writing the image
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBuffer(Buffer.from([
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
         * ]));
         *
         * await image.write("test/output.png");
         * ```
         */
        write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
        /**
         * Clone the image into a new Jimp instance.
         * @param this
         * @returns A new Jimp instance
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * const clone = image.clone();
         * ```
         */
        clone<S extends any>(this: S): S;
        /**
         * Returns the offset of a pixel in the bitmap buffer
         * @param x the x coordinate
         * @param y the y coordinate
         * @param edgeHandling (optional) define how to sum pixels from outside the border
         * @returns the index of the pixel or -1 if not found
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelIndex(1, 1); // 2
         * ```
         */
        getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
        /**
         * Returns the hex color value of a pixel
         * @param x the x coordinate
         * @param y the y coordinate
         * @returns the color of the pixel
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.getPixelColor(1, 1); // 0xffffffff
         * ```
         */
        getPixelColor(x: number, y: number): number;
        /**
         * Sets the hex colour value of a pixel
         *
         * @param hex color to set
         * @param x the x coordinate
         * @param y the y coordinate
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.setPixelColor(0xff0000ff, 0, 0);
         * ```
         */
        setPixelColor(hex: number, x: number, y: number): any;
        /**
         * Determine if the image contains opaque pixels.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.hasAlpha(); // false
         * image2.hasAlpha(); // true
         * ```
         */
        hasAlpha(): boolean;
        /**
         * Composites a source image over to this image respecting alpha channels
         * @param src the source Jimp instance
         * @param x the x position to blit the image
         * @param y the y position to blit the image
         * @param options determine what mode to use
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
         * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
         *
         * image.composite(image2, 3, 3);
         * ```
         */
        composite<I extends any>(src: I, x?: number, y?: number, options?: {
            mode?: BlendMode;
            opacitySource?: number;
            opacityDest?: number;
        }): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(f: (x: number, y: number, idx: number) => any): any;
        /**
         * Scan through the image and call the callback for each pixel
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * image.scan((x, y, idx) => {
         *   // do something with the pixel
         * });
         *
         * // Or scan through just a region
         * image.scan(0, 0, 2, 2, (x, y, idx) => {
         *   // do something with the pixel
         * });
         * ```
         */
        scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
        /**
         * Iterate scan through a region of the bitmap
         * @param x the x coordinate to begin the scan at
         * @param y the y coordinate to begin the scan at
         * @param w the width of the scan region
         * @param h the height of the scan region
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
         *
         * for (const { x, y, idx, image } of j.scanIterator()) {
         *   // do something with the pixel
         * }
         * ```
         */
        scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
            x: number;
            y: number;
            idx: number;
            image: any;
        }, void, unknown>;
    }, UnionToIntersection<Methods[number]>>>;
} & Constructor<JimpInstanceMethods<{
    /**
     * The bitmap data of the image
     */
    bitmap: Bitmap;
    /**  Default color to use for new pixels */
    background: number;
    /** Formats that can be used with Jimp */
    formats: Format<any>[];
    /** The original MIME type of the image */
    mime?: string;
    /**
     * Nicely format Jimp object when sent to the console e.g. console.log(image)
     * @returns Pretty printed jimp object
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * console.log(image);
     * ```
     */
    inspect(): string;
    /**
     * Nicely format Jimp object when converted to a string
     * @returns pretty printed
     */
    toString(): string;
    /** Get the width of the image */
    readonly width: number;
    /** Get the height of the image */
    readonly height: number;
    /**
     * Converts the Jimp instance to an image buffer
     * @param mime The mime type to export to
     * @param options The options to use when exporting
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     * import { promises as fs } from "fs";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * await image.write("test/output.jpeg", {
     *   quality: 50,
     * });
     * ```
     */
    getBuffer<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<Buffer>;
    /**
     * Converts the image to a base 64 string
     *
     * @param mime The mime type to export to
     * @param options The options to use when exporting
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = Jimp.fromBuffer(Buffer.from([
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     * ]));
     *
     * const base64 = image.getBase64("image/jpeg", {
     *   quality: 50,
     * });
     * ```
     */
    getBase64<ProvidedMimeType extends ReturnType<Formats[number]>["mime"], Options extends GetOptionsForMimeType<ProvidedMimeType, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(mime: ProvidedMimeType, options?: Options | undefined): Promise<string>;
    /**
     * Write the image to a file
     * @param path the path to write the image to
     * @param options the options to use when writing the image
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = Jimp.fromBuffer(Buffer.from([
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     *   0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
     * ]));
     *
     * await image.write("test/output.png");
     * ```
     */
    write<Extension extends string, Mime extends GetMimeTypeForExtension<Extension, CreateExtensionToMimeType<ReturnType<Formats[number]>["mime"]>>, Options extends GetOptionsForMimeType<Mime, CreateMimeTypeToExportOptions<ReturnType<Formats[number]>>>>(path: `${string}.${Extension}`, options?: Options | undefined): Promise<void>;
    /**
     * Clone the image into a new Jimp instance.
     * @param this
     * @returns A new Jimp instance
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * const clone = image.clone();
     * ```
     */
    clone<S extends {
        new (options?: JimpConstructorOptions): any;
        /**
         * Create a Jimp instance from a URL, a file path, or a Buffer
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * // Read from a file path
         * const image = await Jimp.read("test/image.png");
         *
         * // Read from a URL
         * const image = await Jimp.read("https://upload.wikimedia.org/wikipedia/commons/0/01/Bot-Test.jpg");
         * ```
         */
        read(url: string | Buffer | ArrayBuffer, options?: CreateMimeTypeToDecodeOptions<ReturnType<Formats[number]>>): Promise<any & JimpInstanceMethods<any, UnionToIntersection<Methods[number]>>>;
        /**
         * Create a Jimp instance from a bitmap.
         * The difference between this and just using the constructor is that this will
         * convert raw image data into the bitmap format that Jimp uses.
         *
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const image = Jimp.fromBitmap({
         *   data: Buffer.from([
         *     0xffffffff, 0xffffffff, 0xffffffff,
         *     0xffffffff, 0xffffffff, 0xffffffff,
         *     0xffffffff, 0xffffffff, 0xffffffff,
         *   ]),
         *   width: 3,
         *   height: 3,
         * });
         * ```
         */
        fromBitmap(bitmap: RawImageData): InstanceType<any> & JimpInstanceMethods<any, UnionToIntersection<Methods[number]>>;
        /**
         * Parse a bitmap with the loaded image types.
         *
         * @param buffer Raw image data
         * @example
         * ```ts
         * import { Jimp } from "jimp";
         *
         * const buffer = await fs.readFile("test/image.png");
         * const image = await Jimp.fromBuffer(buffer);
         * ```
         */
        fromBuffer(buffer: Buffer | ArrayBuffer, options?: CreateMimeTypeToDecodeOptions<ReturnType<Formats[number]>>): Promise<any & JimpInstanceMethods<any, UnionToIntersection<Methods[number]>>>;
    }>(this: S): S;
    /**
     * Returns the offset of a pixel in the bitmap buffer
     * @param x the x coordinate
     * @param y the y coordinate
     * @param edgeHandling (optional) define how to sum pixels from outside the border
     * @returns the index of the pixel or -1 if not found
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * image.getPixelIndex(1, 1); // 2
     * ```
     */
    getPixelIndex(x: number, y: number, edgeHandling?: Edge): number;
    /**
     * Returns the hex color value of a pixel
     * @param x the x coordinate
     * @param y the y coordinate
     * @returns the color of the pixel
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * image.getPixelColor(1, 1); // 0xffffffff
     * ```
     */
    getPixelColor(x: number, y: number): number;
    /**
     * Sets the hex colour value of a pixel
     *
     * @param hex color to set
     * @param x the x coordinate
     * @param y the y coordinate
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * image.setPixelColor(0xff0000ff, 0, 0);
     * ```
     */
    setPixelColor(hex: number, x: number, y: number): any;
    /**
     * Determine if the image contains opaque pixels.
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffaa });
     * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
     *
     * image.hasAlpha(); // false
     * image2.hasAlpha(); // true
     * ```
     */
    hasAlpha(): boolean;
    /**
     * Composites a source image over to this image respecting alpha channels
     * @param src the source Jimp instance
     * @param x the x position to blit the image
     * @param y the y position to blit the image
     * @param options determine what mode to use
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 10, height: 10, color: 0xffffffff });
     * const image2 = new Jimp({ width: 3, height: 3, color: 0xff0000ff });
     *
     * image.composite(image2, 3, 3);
     * ```
     */
    composite<I extends any>(src: I, x?: number, y?: number, options?: {
        mode?: BlendMode;
        opacitySource?: number;
        opacityDest?: number;
    }): any;
    /**
     * Scan through the image and call the callback for each pixel
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * image.scan((x, y, idx) => {
     *   // do something with the pixel
     * });
     *
     * // Or scan through just a region
     * image.scan(0, 0, 2, 2, (x, y, idx) => {
     *   // do something with the pixel
     * });
     * ```
     */
    scan(f: (x: number, y: number, idx: number) => any): any;
    /**
     * Scan through the image and call the callback for each pixel
     *
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * image.scan((x, y, idx) => {
     *   // do something with the pixel
     * });
     *
     * // Or scan through just a region
     * image.scan(0, 0, 2, 2, (x, y, idx) => {
     *   // do something with the pixel
     * });
     * ```
     */
    scan(x: number, y: number, w: number, h: number, cb: (x: number, y: number, idx: number) => any): any;
    /**
     * Iterate scan through a region of the bitmap
     * @param x the x coordinate to begin the scan at
     * @param y the y coordinate to begin the scan at
     * @param w the width of the scan region
     * @param h the height of the scan region
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = new Jimp({ width: 3, height: 3, color: 0xffffffff });
     *
     * for (const { x, y, idx, image } of j.scanIterator()) {
     *   // do something with the pixel
     * }
     * ```
     */
    scanIterator(x?: number, y?: number, w?: number, h?: number): Generator<{
        x: number;
        y: number;
        idx: number;
        image: any;
    }, void, unknown>;
}, UnionToIntersection<Methods[number]>>>;
//# sourceMappingURL=index.d.ts.map