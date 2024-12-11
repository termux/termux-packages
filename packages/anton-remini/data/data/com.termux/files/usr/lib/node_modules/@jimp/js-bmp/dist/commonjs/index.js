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
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BmpCompression = void 0;
exports.msBmp = msBmp;
exports.default = bmp;
const BMP = __importStar(require("bmp-ts"));
const utils_1 = require("@jimp/utils");
var bmp_ts_1 = require("bmp-ts");
Object.defineProperty(exports, "BmpCompression", { enumerable: true, get: function () { return bmp_ts_1.BmpCompression; } });
function encode(image, options = {}) {
    (0, utils_1.scan)({ bitmap: image }, 0, 0, image.width, image.height, function (_, __, index) {
        const red = image.data[index + 0];
        const green = image.data[index + 1];
        const blue = image.data[index + 2];
        const alpha = image.data[index + 3];
        image.data[index + 0] = alpha;
        image.data[index + 1] = blue;
        image.data[index + 2] = green;
        image.data[index + 3] = red;
    });
    return BMP.encode({ ...image, ...options }).data;
}
function decode(data, options) {
    const result = BMP.decode(data, options);
    (0, utils_1.scan)({ bitmap: result }, 0, 0, result.width, result.height, function (_, __, index) {
        // const alpha = result.data[index + 0]!;
        const blue = result.data[index + 1];
        const green = result.data[index + 2];
        const red = result.data[index + 3];
        result.data[index + 0] = red;
        result.data[index + 1] = green;
        result.data[index + 2] = blue;
        result.data[index + 3] = 0xff;
    });
    return result;
}
function msBmp() {
    return {
        mime: "image/x-ms-bmp",
        encode,
        decode,
    };
}
function bmp() {
    return {
        mime: "image/bmp",
        encode,
        decode,
    };
}
//# sourceMappingURL=index.js.map