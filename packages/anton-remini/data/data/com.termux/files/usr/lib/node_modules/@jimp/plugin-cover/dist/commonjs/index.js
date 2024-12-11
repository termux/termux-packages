"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.methods = void 0;
const core_1 = require("@jimp/core");
const plugin_resize_1 = require("@jimp/plugin-resize");
const plugin_crop_1 = require("@jimp/plugin-crop");
const zod_1 = require("zod");
const CoverOptionsSchema = zod_1.z.object({
    /** the width to resize the image to */
    w: zod_1.z.number(),
    /** the height to resize the image to */
    h: zod_1.z.number(),
    /** A bitmask for horizontal and vertical alignment */
    align: zod_1.z.number().optional(),
    /** a scaling method (e.g. ResizeStrategy.BEZIER) */
    mode: zod_1.z.nativeEnum(plugin_resize_1.ResizeStrategy).optional(),
});
exports.methods = {
    /**
     * Scale the image so the given width and height keeping the aspect ratio. Some parts of the image may be clipped.
     * @example
     * ```ts
     * import { Jimp } from "jimp";
     *
     * const image = await Jimp.read("test/image.png");
     *
     * image.cover(150, 100);
     * ```
     */
    cover(image, options) {
        const { w, h, align = core_1.HorizontalAlign.CENTER | core_1.VerticalAlign.MIDDLE, mode, } = CoverOptionsSchema.parse(options);
        const hbits = align & ((1 << 3) - 1);
        const vbits = align >> 3;
        // check if more flags than one is in the bit sets
        if (!((hbits !== 0 && !(hbits & (hbits - 1))) ||
            (vbits !== 0 && !(vbits & (vbits - 1))))) {
            throw new Error("only use one flag per alignment direction");
        }
        const alignH = hbits >> 1; // 0, 1, 2
        const alignV = vbits >> 1; // 0, 1, 2
        const f = w / h > image.bitmap.width / image.bitmap.height
            ? w / image.bitmap.width
            : h / image.bitmap.height;
        image = plugin_resize_1.methods.scale(image, {
            f,
            mode,
        });
        image = plugin_crop_1.methods.crop(image, {
            x: ((image.bitmap.width - w) / 2) * alignH,
            y: ((image.bitmap.height - h) / 2) * alignV,
            w,
            h,
        });
        return image;
    },
};
//# sourceMappingURL=index.js.map