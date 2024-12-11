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
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = png;
const pngjs_1 = require("pngjs");
const constants_js_1 = require("./constants.js");
__exportStar(require("./constants.js"), exports);
function png() {
    return {
        mime: "image/png",
        hasAlpha: true,
        encode: (bitmap, { deflateLevel = 9, deflateStrategy = 3, filterType = constants_js_1.PNGFilterType.AUTO, colorType, inputHasAlpha = true, ...options } = {}) => {
            const png = new pngjs_1.PNG({
                width: bitmap.width,
                height: bitmap.height,
            });
            png.data = bitmap.data;
            return pngjs_1.PNG.sync.write(png, {
                ...options,
                deflateLevel,
                deflateStrategy,
                filterType,
                colorType: typeof colorType !== "undefined"
                    ? colorType
                    : inputHasAlpha
                        ? constants_js_1.PNGColorType.COLOR_ALPHA
                        : constants_js_1.PNGColorType.COLOR,
                inputHasAlpha,
            });
        },
        decode: (data, options) => {
            const result = pngjs_1.PNG.sync.read(data, options);
            return {
                data: result.data,
                width: result.width,
                height: result.height,
            };
        },
    };
}
//# sourceMappingURL=index.js.map