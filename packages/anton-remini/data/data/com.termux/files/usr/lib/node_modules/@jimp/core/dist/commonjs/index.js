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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.composite = exports.getExifOrientation = void 0;
exports.createJimp = createJimp;
const types_1 = require("@jimp/types");
const utils_1 = require("@jimp/utils");
const core_js_1 = __importDefault(require("file-type/core.js"));
const await_to_js_1 = require("await-to-js");
const file_ops_1 = require("@jimp/file-ops");
const lite_js_1 = __importDefault(require("mime/lite.js"));
const composite_js_1 = require("./utils/composite.js");
const image_bitmap_js_1 = require("./utils/image-bitmap.js");
const emptyBitmap = {
    data: Buffer.alloc(0),
    width: 0,
    height: 0,
};
/**
 * Prepare a Buffer object from the arrayBuffer.
 */
function bufferFromArrayBuffer(arrayBuffer) {
    const buffer = Buffer.alloc(arrayBuffer.byteLength);
    const view = new Uint8Array(arrayBuffer);
    for (let i = 0; i < buffer.length; ++i) {
        buffer[i] = view[i];
    }
    return buffer;
}
var image_bitmap_js_2 = require("./utils/image-bitmap.js");
Object.defineProperty(exports, "getExifOrientation", { enumerable: true, get: function () { return image_bitmap_js_2.getExifOrientation; } });
var composite_js_2 = require("./utils/composite.js");
Object.defineProperty(exports, "composite", { enumerable: true, get: function () { return composite_js_2.composite; } });
__exportStar(require("./utils/constants.js"), exports);
/**
 * Create a Jimp class that support the given image formats and methods
 */
function createJimp({ plugins: pluginsArg, formats: formatsArg, } = {}) {
    const plugins = pluginsArg || [];
    const formats = (formatsArg || []).map((format) => format());
    const CustomJimp = class Jimp {
        /**
         * The bitmap data of the image
         */
        bitmap = emptyBitmap;
        /**  Default color to use for new pixels */
        background = 0x00000000;
        /** Formats that can be used with Jimp */
        formats = [];
        /** The original MIME type of the image */
        mime;
        constructor(options = emptyBitmap) {
            // Add the formats
            this.formats = formats;
            if ("data" in options) {
                this.bitmap = options;
            }
            else {
                this.bitmap = {
                    data: Buffer.alloc(options.width * options.height * 4),
                    width: options.width,
                    height: options.height,
                };
                if (options.color) {
                    this.background =
                        typeof options.color === "string"
                            ? (0, utils_1.cssColorToHex)(options.color)
                            : options.color;
                    for (let i = 0; i < this.bitmap.data.length; i += 4) {
                        this.bitmap.data.writeUInt32BE(this.background, i);
                    }
                }
            }
            // Add the plugins
            for (const methods of plugins) {
                for (const key in methods) {
                    this[key] = (...args) => {
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
        static async read(url, options) {
            if (Buffer.isBuffer(url) || url instanceof ArrayBuffer) {
                return this.fromBuffer(url);
            }
            if ((0, file_ops_1.existsSync)(url)) {
                return this.fromBuffer(await (0, file_ops_1.readFile)(url));
            }
            const [fetchErr, response] = await (0, await_to_js_1.to)(fetch(url));
            if (fetchErr) {
                throw new Error(`Could not load Buffer from URL: ${url}`);
            }
            if (!response.ok) {
                throw new Error(`HTTP Status ${response.status} for url ${url}`);
            }
            const [arrayBufferErr, data] = await (0, await_to_js_1.to)(response.arrayBuffer());
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
        static fromBitmap(bitmap) {
            let data;
            if (bitmap.data instanceof Buffer) {
                data = Buffer.from(bitmap.data);
            }
            if (bitmap.data instanceof Uint8Array ||
                bitmap.data instanceof Uint8ClampedArray) {
                data = Buffer.from(bitmap.data.buffer);
            }
            if (Array.isArray(bitmap.data)) {
                data = Buffer.concat(bitmap.data.map((hex) => Buffer.from(hex.toString(16).padStart(8, "0"), "hex")));
            }
            if (!data) {
                throw new Error("data must be a Buffer");
            }
            if (typeof bitmap.height !== "number" ||
                typeof bitmap.width !== "number") {
                throw new Error("bitmap must have width and height");
            }
            return new CustomJimp({
                height: bitmap.height,
                width: bitmap.width,
                data,
            });
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
        static async fromBuffer(buffer, options) {
            const actualBuffer = buffer instanceof ArrayBuffer ? bufferFromArrayBuffer(buffer) : buffer;
            const mime = await core_js_1.default.fromBuffer(actualBuffer);
            if (!mime || !mime.mime) {
                throw new Error("Could not find MIME for Buffer");
            }
            const format = formats.find((format) => format.mime === mime.mime);
            if (!format || !format.decode) {
                throw new Error(`Mime type ${mime.mime} does not support decoding`);
            }
            const image = new CustomJimp(await format.decode(actualBuffer, options?.[format.mime]));
            image.mime = mime.mime;
            (0, image_bitmap_js_1.attemptExifRotate)(image, actualBuffer);
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
            return ("<Jimp " +
                (this.bitmap === emptyBitmap
                    ? "pending..."
                    : this.bitmap.width + "x" + this.bitmap.height) +
                ">");
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
        async getBuffer(mime, options) {
            const format = this.formats.find((format) => format.mime === mime);
            if (!format || !format.encode) {
                throw new Error(`Unsupported MIME type: ${mime}`);
            }
            let outputImage;
            if (format.hasAlpha) {
                // eslint-disable-next-line @typescript-eslint/no-this-alias
                outputImage = this;
            }
            else {
                outputImage = new CustomJimp({
                    width: this.bitmap.width,
                    height: this.bitmap.height,
                    color: this.background,
                });
                (0, composite_js_1.composite)(outputImage, this);
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
        async getBase64(mime, options) {
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
        async write(path, options) {
            const mimeType = lite_js_1.default.getType(path);
            await (0, file_ops_1.writeFile)(path, await this.getBuffer(mimeType, options));
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
        clone() {
            return new CustomJimp({
                ...this.bitmap,
                data: Buffer.from(this.bitmap.data),
            });
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
        getPixelIndex(x, y, edgeHandling) {
            let xi;
            let yi;
            if (!edgeHandling) {
                edgeHandling = types_1.Edge.EXTEND;
            }
            if (typeof x !== "number" || typeof y !== "number") {
                throw new Error("x and y must be numbers");
            }
            // round input
            x = Math.round(x);
            y = Math.round(y);
            xi = x;
            yi = y;
            if (edgeHandling === types_1.Edge.EXTEND) {
                if (x < 0)
                    xi = 0;
                if (x >= this.bitmap.width)
                    xi = this.bitmap.width - 1;
                if (y < 0)
                    yi = 0;
                if (y >= this.bitmap.height)
                    yi = this.bitmap.height - 1;
            }
            if (edgeHandling === types_1.Edge.WRAP) {
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
        getPixelColor(x, y) {
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
        setPixelColor(hex, x, y) {
            if (typeof hex !== "number" ||
                typeof x !== "number" ||
                typeof y !== "number") {
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
        composite(src, x = 0, y = 0, options = {}) {
            return (0, composite_js_1.composite)(this, src, x, y, options);
        }
        scan(x, y, w, h, f) {
            return (0, utils_1.scan)(this, x, y, w, h, f);
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
            return (0, utils_1.scanIterator)(this, x, y, w, h);
        }
    };
    return CustomJimp;
}
//# sourceMappingURL=index.js.map