"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = gif;
const omggif_1 = __importDefault(require("omggif"));
const gifwrap_1 = require("gifwrap");
function gif() {
    return {
        mime: "image/gif",
        encode: async (bitmap) => {
            const gif = new gifwrap_1.BitmapImage(bitmap);
            gifwrap_1.GifUtil.quantizeDekker(gif, 256);
            const newFrame = new gifwrap_1.GifFrame(bitmap);
            const gifCodec = new gifwrap_1.GifCodec();
            const newGif = await gifCodec.encodeGif([newFrame], {});
            return newGif.buffer;
        },
        decode: (data) => {
            const gifObj = new omggif_1.default.GifReader(data);
            const gifData = Buffer.alloc(gifObj.width * gifObj.height * 4);
            gifObj.decodeAndBlitFrameRGBA(0, gifData);
            return {
                data: gifData,
                width: gifObj.width,
                height: gifObj.height,
            };
        },
    };
}
//# sourceMappingURL=index.js.map