import JPEG from "jpeg-js";
import { Format } from "@jimp/types";

export interface JPEGOptions {
  quality?: number;
}

export interface DecodeJpegOptions {
  useTArray?: false;
  colorTransform?: boolean;
  formatAsRGBA?: boolean;
  tolerantDecoding?: boolean;
  maxResolutionInMP?: number;
  maxMemoryUsageInMB?: number;
}

export default function jpeg() {
  return {
    mime: "image/jpeg",
    encode: (bitmap, { quality = 100 }: JPEGOptions = {}) =>
      JPEG.encode(bitmap, quality).data,
    decode: (data, options?: DecodeJpegOptions) => JPEG.decode(data, options),
  } satisfies Format<"image/jpeg">;
}
