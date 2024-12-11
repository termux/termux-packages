import { PNG, PNGOptions as PNGJSOptions } from "pngjs";
import { Format } from "@jimp/types";
import { PNGFilterType, PNGColorType } from "./constants.js";

export type { PNGOptions as PNGJSOptions } from "pngjs";
export type PNGOptions = Omit<
  PNGJSOptions,
  "filterType" | "colorType" | "inputColorType"
> & {
  filterType?: PNGFilterType;
  colorType?: PNGColorType;
  inputColorType?: PNGColorType;
};

export interface DecodePngOptions {
  checkCRC?: boolean | undefined;
  skipRescale?: boolean | undefined;
}

export * from "./constants.js";

export default function png() {
  return {
    mime: "image/png",
    hasAlpha: true,
    encode: (
      bitmap,
      {
        deflateLevel = 9,
        deflateStrategy = 3,
        filterType = PNGFilterType.AUTO,
        colorType,
        inputHasAlpha = true,
        ...options
      }: PNGOptions = {}
    ) => {
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
        colorType:
          typeof colorType !== "undefined"
            ? colorType
            : inputHasAlpha
              ? PNGColorType.COLOR_ALPHA
              : PNGColorType.COLOR,
        inputHasAlpha,
      });
    },
    decode: (data, options?: DecodePngOptions) => {
      const result = PNG.sync.read(data, options);

      return {
        data: result.data,
        width: result.width,
        height: result.height,
      };
    },
  } satisfies Format<"image/png">;
}
