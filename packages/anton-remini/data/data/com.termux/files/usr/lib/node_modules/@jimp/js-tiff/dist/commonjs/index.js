"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = tiff;
const utif2_1 = __importDefault(require("utif2"));
function getDimensionValue(dimension) {
    if (typeof dimension === "number") {
        return dimension;
    }
    if (dimension instanceof Uint8Array) {
        return dimension[0];
    }
    if (typeof dimension[0] === "string") {
        return parseInt(dimension[0]);
    }
    return dimension[0];
}
function tiff() {
    return {
        mime: "image/tiff",
        encode: (bitmap) => {
            const tiff = utif2_1.default.encodeImage(bitmap.data, bitmap.width, bitmap.height);
            return Buffer.from(tiff);
        },
        decode: (data) => {
            const ifds = utif2_1.default.decode(data);
            const page = ifds[0];
            if (!page) {
                throw new Error("No page found in TIFF");
            }
            if (!page.t256) {
                throw new Error("No image width found in TIFF");
            }
            if (!page.t257) {
                throw new Error("No image height found in TIFF");
            }
            ifds.forEach((ifd) => {
                utif2_1.default.decodeImage(data, ifd);
            });
            const rgba = utif2_1.default.toRGBA8(page);
            return {
                data: Buffer.from(rgba),
                width: getDimensionValue(page.t256),
                height: getDimensionValue(page.t257),
            };
        },
    };
}
//# sourceMappingURL=index.js.map