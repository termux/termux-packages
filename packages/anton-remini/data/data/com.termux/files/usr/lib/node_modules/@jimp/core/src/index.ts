import { Bitmap, Format, JimpClass, Edge } from "@jimp/types";
import { cssColorToHex, scan, scanIterator } from "@jimp/utils";
import fileType from "file-type/core.js";
import { to } from "await-to-js";
import { existsSync, readFile, writeFile } from "@jimp/file-ops";
import mime from "mime/lite.js";

import { composite } from "./utils/composite.js";
import { BlendMode } from "./index.js";
import { attemptExifRotate } from "./utils/image-bitmap.js";

const emptyBitmap: Bitmap = {
  data: Buffer.alloc(0),
  width: 0,
  height: 0,
};

/**
 * Prepare a Buffer object from the arrayBuffer.
 */
function bufferFromArrayBuffer(arrayBuffer: ArrayBuffer) {
  const buffer = Buffer.alloc(arrayBuffer.byteLength);
  const view = new Uint8Array(arrayBuffer);

  for (let i = 0; i < buffer.length; ++i) {
    buffer[i] = view[i]!;
  }

  return buffer;
}

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
type JimpInstanceMethod<ClassInstance, MethodMap, Method> =
  Method extends JimpChainableMethod<infer Args>
    ? (
        ...args: Args
      ) => JimpInstanceMethods<ClassInstance, MethodMap> & ClassInstance
    : Method extends JimpMethod<infer Args, infer Return>
      ? (...args: Args) => Return
      : never;

/** Converts a Record of jimp plugin functions to a Record of Jimp class methods */
export type JimpInstanceMethods<ClassInstance, MethodMap> = {
  [Key in keyof MethodMap]: JimpInstanceMethod<
    ClassInstance,
    MethodMap,
    MethodMap[Key]
  >;
};

/** A Jimp instance method that can be chained. */
type JimpChainableMethod<
  Args extends any[] = any[],
  J extends JimpClass = JimpClass,
> = (img: J, ...args: Args) => J;

/** A Jimp instance method that returns anything. */
type JimpMethod<
  Args extends any[] = any[],
  ReturnType = any,
  J extends JimpClass = JimpClass,
> = (img: J, ...args: Args) => ReturnType;

export interface JimpPlugin {
  [key: string]: JimpChainableMethod | JimpMethod;
}

type UnionToIntersection<U> = (U extends any ? (k: U) => void : never) extends (
  k: infer I
) => void
  ? I
  : never;

type Constructor<T> = new (...args: any[]) => T;

type JimpFormat<
  MimeType extends string = string,
  EncodeOptions extends Record<string, any> | undefined = undefined,
  DecodeOptions extends Record<string, any> | undefined = undefined,
  T extends Format<MimeType, EncodeOptions, DecodeOptions> = Format<
    MimeType,
    EncodeOptions,
    DecodeOptions
  >,
> = () => T;

type CreateMimeTypeToExportOptions<T extends Format<string, any>> =
  T extends Format<infer M, infer O> ? Record<M, O> : never;
type CreateMimeTypeToDecodeOptions<T extends Format<string, any>> =
  T extends Format<infer M, any, infer O> ? Record<M, O> : never;
type GetOptionsForMimeType<Mime extends string, MimeTypeMap> =
  MimeTypeMap extends Record<Mime, infer O> ? O : never;

type PathWithExtension<E extends string> = `${string}.${E}`;
type MimeToExtension<M extends string> = `${string}/${M}`;
type CreateExtensionToMimeType<M extends string> =
  M extends MimeToExtension<infer E> ? Record<E, M> : never;
type GetMimeTypeForExtension<Mime extends string, MimeTypeMap> =
  MimeTypeMap extends Record<Mime, infer M> ? M : never;

/**
 * Create a Jimp class that support the given image formats and methods
 */
export function createJimp<
  Methods extends JimpPlugin[],
  Formats extends JimpFormat[],
>({
  plugins: pluginsArg,
  formats: formatsArg,
}: {
  /** Plugins that add methods to the created Jimp class */
  plugins?: Methods;
  /** Image formats the Jimp class should support */
  formats?: Formats;
} = {}) {
  type ExtraMethodMap = JimpInstanceMethods<
    InstanceType<typeof CustomJimp>,
    UnionToIntersection<Methods[number]>
  >;
  type SupportedMimeTypes = ReturnType<Formats[number]>["mime"];
  type MimeTypeToExportOptions = CreateMimeTypeToExportOptions<
    ReturnType<Formats[number]>
  >;
  type MimeTypeToDecodeOptions = CreateMimeTypeToDecodeOptions<
    ReturnType<Formats[number]>
  >;
  type ExtensionToMimeType = CreateExtensionToMimeType<SupportedMimeTypes>;

  const plugins = pluginsArg || [];
  const formats = (formatsArg || []).map((format) => format());

  const CustomJimp = class Jimp implements JimpClass {
    /**
     * The bitmap data of the image
     */
    bitmap: Bitmap = emptyBitmap;

    /**  Default color to use for new pixels */
    background = 0x00000000;

    /** Formats that can be used with Jimp */
    formats: Format<any>[] = [];

    /** The original MIME type of the image */
    mime?: string;

    constructor(options: JimpConstructorOptions = emptyBitmap) {
      // Add the formats
      this.formats = formats;

      if ("data" in options) {
        this.bitmap = options;
      } else {
        this.bitmap = {
          data: Buffer.alloc(options.width * options.height * 4),
          width: options.width,
          height: options.height,
        };

        if (options.color) {
          this.background =
            typeof options.color === "string"
              ? cssColorToHex(options.color)
              : options.color;

          for (let i = 0; i < this.bitmap.data.length; i += 4) {
            this.bitmap.data.writeUInt32BE(this.background, i);
          }
        }
      }

      // Add the plugins
      for (const methods of plugins) {
        for (const key in methods) {
          (this as any)[key] = (...args: any[]) => {
            const result = methods[key]?.(this, ...args);

            if (typeof result === "object" && "bitmap" in result) {
              this.bitmap = result.bitmap;
              return this;
            }

            return result;
          };
        }
      }
    }

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
    static async read(
      url: string | Buffer | ArrayBuffer,
      options?: MimeTypeToDecodeOptions
    ) {
      if (Buffer.isBuffer(url) || url instanceof ArrayBuffer) {
        return this.fromBuffer(url);
      }

      if (existsSync(url)) {
        return this.fromBuffer(await readFile(url));
      }

      const [fetchErr, response] = await to(fetch(url));

      if (fetchErr) {
        throw new Error(`Could not load Buffer from URL: ${url}`);
      }

      if (!response.ok) {
        throw new Error(`HTTP Status ${response.status} for url ${url}`);
      }

      const [arrayBufferErr, data] = await to(response.arrayBuffer());

      if (arrayBufferErr) {
        throw new Error(`Could not load Buffer from ${url}`);
      }

      const buffer = bufferFromArrayBuffer(data);
      return this.fromBuffer(buffer, options);
    }

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
    static fromBitmap(bitmap: RawImageData) {
      let data: Buffer | undefined;

      if (bitmap.data instanceof Buffer) {
        data = Buffer.from(bitmap.data);
      }

      if (
        bitmap.data instanceof Uint8Array ||
        bitmap.data instanceof Uint8ClampedArray
      ) {
        data = Buffer.from(bitmap.data.buffer);
      }

      if (Array.isArray(bitmap.data)) {
        data = Buffer.concat(
          bitmap.data.map((hex) =>
            Buffer.from(hex.toString(16).padStart(8, "0"), "hex")
          )
        );
      }

      if (!data) {
        throw new Error("data must be a Buffer");
      }

      if (
        typeof bitmap.height !== "number" ||
        typeof bitmap.width !== "number"
      ) {
        throw new Error("bitmap must have width and height");
      }

      return new CustomJimp({
        height: bitmap.height,
        width: bitmap.width,
        data,
      }) as InstanceType<typeof CustomJimp> & ExtraMethodMap;
    }

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
    static async fromBuffer(
      buffer: Buffer | ArrayBuffer,
      options?: MimeTypeToDecodeOptions
    ) {
      const actualBuffer =
        buffer instanceof ArrayBuffer ? bufferFromArrayBuffer(buffer) : buffer;

      const mime = await fileType.fromBuffer(actualBuffer);

      if (!mime || !mime.mime) {
        throw new Error("Could not find MIME for Buffer");
      }

      const format = formats.find((format) => format.mime === mime.mime);

      if (!format || !format.decode) {
        throw new Error(`Mime type ${mime.mime} does not support decoding`);
      }

      const image = new CustomJimp(
        await format.decode(actualBuffer, options?.[format.mime])
      ) as InstanceType<typeof CustomJimp> & ExtraMethodMap;

      image.mime = mime.mime;

      attemptExifRotate(image, actualBuffer);

      return image;
    }

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
    inspect() {
      return (
        "<Jimp " +
        (this.bitmap === emptyBitmap
          ? "pending..."
          : this.bitmap.width + "x" + this.bitmap.height) +
        ">"
      );
    }

    /**
     * Nicely format Jimp object when converted to a string
     * @returns pretty printed
     */
    toString() {
      return "[object Jimp]";
    }

    /** Get the width of the image */
    get width() {
      return this.bitmap.width;
    }

    /** Get the height of the image */
    get height() {
      return this.bitmap.height;
    }

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
    async getBuffer<
      ProvidedMimeType extends SupportedMimeTypes,
      Options extends GetOptionsForMimeType<
        ProvidedMimeType,
        MimeTypeToExportOptions
      >,
    >(mime: ProvidedMimeType, options?: Options) {
      const format = this.formats.find((format) => format.mime === mime);

      if (!format || !format.encode) {
        throw new Error(`Unsupported MIME type: ${mime}`);
      }

      let outputImage: Jimp;

      if (format.hasAlpha) {
        // eslint-disable-next-line @typescript-eslint/no-this-alias
        outputImage = this;
      } else {
        outputImage = new CustomJimp({
          width: this.bitmap.width,
          height: this.bitmap.height,
          color: this.background,
        });

        composite(outputImage, this);
      }

      return format.encode(outputImage.bitmap, options);
    }

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
    async getBase64<
      ProvidedMimeType extends SupportedMimeTypes,
      Options extends GetOptionsForMimeType<
        ProvidedMimeType,
        MimeTypeToExportOptions
      >,
    >(mime: ProvidedMimeType, options?: Options) {
      const data = await this.getBuffer(mime, options);
      return "data:" + mime + ";base64," + data.toString("base64");
    }

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
    async write<
      Extension extends string,
      Mime extends GetMimeTypeForExtension<Extension, ExtensionToMimeType>,
      Options extends GetOptionsForMimeType<Mime, MimeTypeToExportOptions>,
    >(path: PathWithExtension<Extension>, options?: Options) {
      const mimeType = mime.getType(path);
      await writeFile(
        path,
        await this.getBuffer(mimeType as SupportedMimeTypes, options)
      );
    }

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
    clone<S extends typeof CustomJimp>(this: S) {
      return new CustomJimp({
        ...(this as any).bitmap,
        data: Buffer.from((this as any).bitmap.data),
      }) as unknown as S;
    }

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
    getPixelIndex(x: number, y: number, edgeHandling?: Edge) {
      let xi;
      let yi;

      if (!edgeHandling) {
        edgeHandling = Edge.EXTEND;
      }

      if (typeof x !== "number" || typeof y !== "number") {
        throw new Error("x and y must be numbers");
      }

      // round input
      x = Math.round(x);
      y = Math.round(y);
      xi = x;
      yi = y;

      if (edgeHandling === Edge.EXTEND) {
        if (x < 0) xi = 0;
        if (x >= this.bitmap.width) xi = this.bitmap.width - 1;
        if (y < 0) yi = 0;
        if (y >= this.bitmap.height) yi = this.bitmap.height - 1;
      }

      if (edgeHandling === Edge.WRAP) {
        if (x < 0) {
          xi = this.bitmap.width + x;
        }

        if (x >= this.bitmap.width) {
          xi = x % this.bitmap.width;
        }

        if (y < 0) {
          yi = this.bitmap.height + y;
        }

        if (y >= this.bitmap.height) {
          yi = y % this.bitmap.height;
        }
      }

      let i = (this.bitmap.width * yi + xi) << 2;

      // if out of bounds index is -1
      if (xi < 0 || xi >= this.bitmap.width) {
        i = -1;
      }

      if (yi < 0 || yi >= this.bitmap.height) {
        i = -1;
      }

      return i;
    }

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
    getPixelColor(x: number, y: number) {
      if (typeof x !== "number" || typeof y !== "number") {
        throw new Error("x and y must be numbers");
      }

      const idx = this.getPixelIndex(x, y);
      return this.bitmap.data.readUInt32BE(idx);
    }

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
    setPixelColor(hex: number, x: number, y: number) {
      if (
        typeof hex !== "number" ||
        typeof x !== "number" ||
        typeof y !== "number"
      ) {
        throw new Error("hex, x and y must be numbers");
      }

      const idx = this.getPixelIndex(x, y);
      this.bitmap.data.writeUInt32BE(hex, idx);

      return this;
    }

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
    hasAlpha() {
      const { width, height, data } = this.bitmap;
      const byteLen = (width * height) << 2;

      for (let idx = 3; idx < byteLen; idx += 4) {
        if (data[idx] !== 0xff) {
          return true;
        }
      }

      return false;
    }

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
    composite<I extends typeof this>(
      src: I,
      x = 0,
      y = 0,
      options: {
        mode?: BlendMode;
        opacitySource?: number;
        opacityDest?: number;
      } = {}
    ) {
      return composite(this, src, x, y, options);
    }

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
    scan(f: (x: number, y: number, idx: number) => any): this;
    scan(
      x: number,
      y: number,
      w: number,
      h: number,
      cb: (x: number, y: number, idx: number) => any
    ): this;
    scan(
      x: number | ((x: number, y: number, idx: number) => any),
      y?: number,
      w?: number,
      h?: number,
      f?: (x: number, y: number, idx: number) => any
    ): this {
      return scan(this, x as any, y as any, w as any, h as any, f as any);
    }

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
    scanIterator(x = 0, y = 0, w = this.bitmap.width, h = this.bitmap.height) {
      if (typeof x !== "number" || typeof y !== "number") {
        throw new Error("x and y must be numbers");
      }

      if (typeof w !== "number" || typeof h !== "number") {
        throw new Error("w and h must be numbers");
      }

      return scanIterator(this, x, y, w, h);
    }
  };

  return CustomJimp as typeof CustomJimp & Constructor<ExtraMethodMap>;
}
