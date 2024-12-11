import { PNG } from "pngjs";
import { PNGFilterType, PNGColorType } from "./constants.js";
export * from "./constants.js";
export default function png() {
    return {
        mime: "image/png",
        hasAlpha: true,
        encode: (bitmap, { deflateLevel = 9, deflateStrategy = 3, filterType = PNGFilterType.AUTO, colorType, inputHasAlpha = true, ...options } = {}) => {
            const png = new PNG({
                width: bitmap.width,
                height: bitmap.height,
            });
            png.data = bitmap.data;
            return PNG.sync.write(png, {
                ...options,
                deflateLevel,
                deflateStrategy,
                filterType,
                colorType: typeof colorType !== "undefined"
                    ? colorType
                    : inputHasAlpha
                        ? PNGColorType.COLOR_ALPHA
                        : PNGColorType.COLOR,
                inputHasAlpha,
            });
        },
        decode: (data, options) => {
            const result = PNG.sync.read(data, options);
            return {
                data: result.data,
                width: result.width,
                height: result.height,
            };
        },
    };
}
//# sourceMappingURL=index.js.map