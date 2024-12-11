"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = jpeg;
const jpeg_js_1 = __importDefault(require("jpeg-js"));
function jpeg() {
    return {
        mime: "image/jpeg",
        encode: (bitmap, { quality = 100 } = {}) => jpeg_js_1.default.encode(bitmap, quality).data,
        decode: (data, options) => jpeg_js_1.default.decode(data, options),
    };
}
//# sourceMappingURL=index.js.map