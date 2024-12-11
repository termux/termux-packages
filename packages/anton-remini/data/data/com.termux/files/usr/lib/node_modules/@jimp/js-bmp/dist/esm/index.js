import * as BMP from "bmp-ts";
import { scan } from "@jimp/utils";
export { BmpCompression } from "bmp-ts";
function encode(image, options = {}) {
    scan({ bitmap: image }, 0, 0, image.width, image.height, function (_, __, index) {
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
    scan({ bitmap: result }, 0, 0, result.width, result.height, function (_, __, index) {
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
export function msBmp() {
    return {
        mime: "image/x-ms-bmp",
        encode,
        decode,
    };
}
export default function bmp() {
    return {
        mime: "image/bmp",
        encode,
        decode,
    };
}
//# sourceMappingURL=index.js.map