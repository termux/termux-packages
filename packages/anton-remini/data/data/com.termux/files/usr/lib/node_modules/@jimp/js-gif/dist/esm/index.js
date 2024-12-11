import GIF from "omggif";
import { GifUtil, GifFrame, BitmapImage, GifCodec } from "gifwrap";
export default function gif() {
    return {
        mime: "image/gif",
        encode: async (bitmap) => {
            const gif = new BitmapImage(bitmap);
            GifUtil.quantizeDekker(gif, 256);
            const newFrame = new GifFrame(bitmap);
            const gifCodec = new GifCodec();
            const newGif = await gifCodec.encodeGif([newFrame], {});
            return newGif.buffer;
        },
        decode: (data) => {
            const gifObj = new GIF.GifReader(data);
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