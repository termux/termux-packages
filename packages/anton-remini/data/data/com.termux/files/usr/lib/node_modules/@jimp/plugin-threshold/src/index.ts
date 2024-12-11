import { JimpClass } from "@jimp/types";
import { limit255 } from "@jimp/utils";
import { methods as color } from "@jimp/plugin-color";
import { z } from "zod";

const ThresholdOptionsSchema = z.object({
  /** A number auto limited between 0 - 255 */
  max: z.number().min(0).max(255),
  /** A number auto limited between 0 - 255 (default 255)  */
  replace: z.number().min(0).max(255).optional(),
  /** A boolean whether to apply greyscale beforehand (default true)  */
  autoGreyscale: z.boolean().optional(),
});

export type ThresholdOptions = z.infer<typeof ThresholdOptionsSchema>;

export const methods = {
  /**
   * Applies a minimum color threshold to a grayscale image.
   * Converts image to grayscale by default.
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   *
   * image.threshold({ max: 150 });
   * ```
   */
  threshold<I extends JimpClass>(image: I, options: ThresholdOptions) {
    let {
      max,
      replace = 255,
      // eslint-disable-next-line prefer-const
      autoGreyscale = true,
    } = ThresholdOptionsSchema.parse(options);

    max = limit255(max);
    replace = limit255(replace);

    if (autoGreyscale) {
      color.greyscale(image);
    }

    image.scan((_, __, idx) => {
      const grey =
        image.bitmap.data[idx]! < max ? image.bitmap.data[idx]! : replace;

      image.bitmap.data[idx] = grey;
      image.bitmap.data[idx + 1] = grey;
      image.bitmap.data[idx + 2] = grey;
    });

    return image;
  },
};
