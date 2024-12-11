"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PNGColorType = exports.PNGFilterType = void 0;
/**
 * Filter method is a single-byte integer that indicates the preprocessing method applied to the image data before compression.
 */
var PNGFilterType;
(function (PNGFilterType) {
    PNGFilterType[PNGFilterType["AUTO"] = -1] = "AUTO";
    /** scanline is transmitted unmodified */
    PNGFilterType[PNGFilterType["NONE"] = 0] = "NONE";
    /** filter transmits the difference between each byte and the value of the corresponding byte of the prior pixel */
    PNGFilterType[PNGFilterType["SUB"] = 1] = "SUB";
    /** The Up() filter is just like the Sub() filter except that the pixel immediately above the current pixel, rather than just to its left, is used as the predictor. */
    PNGFilterType[PNGFilterType["UP"] = 2] = "UP";
    /** uses the average of the two neighboring pixels (left and above) to predict the value of a pixel */
    PNGFilterType[PNGFilterType["AVERAGE"] = 3] = "AVERAGE";
    /** computes a simple linear function of the three neighboring pixels (left, above, upper left), then chooses as predictor the neighboring pixel closest to the computed value. */
    PNGFilterType[PNGFilterType["PATH"] = 4] = "PATH";
})(PNGFilterType || (exports.PNGFilterType = PNGFilterType = {}));
/**
 * Color type is a single-byte integer that describes the interpretation of the image data.
 * Color type codes represent sums of the following values:
 *
 * 1 (palette used), 2 (color used), and 4 (alpha channel used).
 */
var PNGColorType;
(function (PNGColorType) {
    PNGColorType[PNGColorType["GRAYSCALE"] = 0] = "GRAYSCALE";
    PNGColorType[PNGColorType["COLOR"] = 2] = "COLOR";
    PNGColorType[PNGColorType["GRAYSCALE_ALPHA"] = 4] = "GRAYSCALE_ALPHA";
    PNGColorType[PNGColorType["COLOR_ALPHA"] = 6] = "COLOR_ALPHA";
})(PNGColorType || (exports.PNGColorType = PNGColorType = {}));
//# sourceMappingURL=constants.js.map