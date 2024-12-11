import JPEG from "jpeg-js";
export default function jpeg() {
    return {
        mime: "image/jpeg",
        encode: (bitmap, { quality = 100 } = {}) => JPEG.encode(bitmap, quality).data,
        decode: (data, options) => JPEG.decode(data, options),
    };
}
//# sourceMappingURL=index.js.map