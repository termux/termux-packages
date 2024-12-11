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
exports.methods = void 0;
const constants_js_1 = require("./constants.js");
const zod_1 = require("zod");
const resize_js_1 = __importDefault(require("./modules/resize.js"));
const resize2_js_1 = require("./modules/resize2.js");
__exportStar(require("./constants.js"), exports);
const ResizeOptionsSchema = zod_1.z.union([
    zod_1.z.object({
        /** the width to resize the image to */
        w: zod_1.z.number().min(0),
        /** the height to resize the image to */
        h: zod_1.z.number().min(0).optional(),
        /** a scaling method (e.g. ResizeStrategy.BEZIER) */
        mode: zod_1.z.nativeEnum(constants_js_1.ResizeStrategy).optional(),
    }),
    zod_1.z.object({
        /** the width to resize the image to */
        w: zod_1.z.number().min(0).optional(),
        /** the height to resize the image to */
        h: zod_1.z.number().min(0),
        /** a scaling method (e.g. ResizeStrategy.BEZIER) */
        mode: zod_1.z.nativeEnum(constants_js_1.ResizeStrategy).optional(),
    }),
]);
const ScaleToFitOptionsSchema = zod_1.z.object({
    /** the width to resize the image to */
    w: zod_1.z.number().min(0),
    /** the height to resize the image to */
    h: zod_1.z.number().min(0),
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: zod_1.z.nativeEnum(constants_js_1.ResizeStrategy).optional(),
});
const ScaleComplexOptionsSchema = zod_1.z.object({
    /** the width to resize the image to */
    f: zod_1.z.number().min(0),
    /** a scaling method (e.g. Jimp.RESIZE_BEZIER) */
    mode: zod_1.z.nativeEnum(constants_js_1.ResizeStrategy).optional(),
});
exports.methods = {
    /**
     * Resizes the image to a set width and height using a 2-pass bilinear algorithm
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.resize({ w: 150 });
     * ```
     */
    resize(image, options) {
        const { mode } = ResizeOptionsSchema.parse(options);
        let w;
        let h;
        if (typeof options.w === "number") {
            w = options.w;
            h = options.h ?? image.bitmap.height * (w / image.bitmap.width);
        }
        else if (typeof options.h === "number") {
            h = options.h;
            w = options.w ?? image.bitmap.width * (h / image.bitmap.height);
        }
        else {
            throw new Error("w must be a number");
        }
        // round inputs
        w = Math.round(w) || 1;
        h = Math.round(h) || 1;
        if (mode && typeof resize2_js_1.operations[mode] === "function") {
            const dst = {
                data: Buffer.alloc(w * h * 4),
                width: w,
                height: h,
            };
            resize2_js_1.operations[mode](image.bitmap, dst);
            image.bitmap = dst;
        }
        else {
            const resize = new resize_js_1.default(image.bitmap.width, image.bitmap.height, w, h, true, true, (buffer) => {
                image.bitmap.data = Buffer.from(buffer);
                image.bitmap.width = w;
                image.bitmap.height = h;
            });
            resize.resize(image.bitmap.data);
        }
        return image;
    },
    /**
     * Uniformly scales the image by a factor.
     * @param f the factor to scale the image by
     * @param mode (optional) a scaling method (e.g. Jimp.RESIZE_BEZIER)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.scale(0.5);
     * ```
     */
    scale(image, options) {
        const { f, mode } = typeof options === "number"
            ? { f: options }
            : ScaleComplexOptionsSchema.parse(options);
        const w = image.bitmap.width * f;
        const h = image.bitmap.height * f;
        return this.resize(image, { w, h, mode: mode });
    },
    /**
     * Scale the image to the largest size that fits inside the rectangle that has the given width and height.
     * @param w the width to resize the image to
     * @param h the height to resize the image to
     * @param mode a scaling method (e.g. ResizeStrategy.BEZIER)
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.scaleToFit(100, 100);
     * ```
     */
    scaleToFit(image, options) {
        const { h, w, mode } = ScaleToFitOptionsSchema.parse(options);
        const f = w / h > image.bitmap.width / image.bitmap.height
            ? h / image.bitmap.height
            : w / image.bitmap.width;
        return this.scale(image, { f, mode: mode });
    },
};
//# sourceMappingURL=index.js.map