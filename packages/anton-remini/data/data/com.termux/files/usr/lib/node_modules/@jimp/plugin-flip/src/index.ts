import { JimpClass } from "@jimp/types";
import { z } from "zod";

const FlipOptionsSchema = z.object({
  /** if true the image will be flipped horizontally */
  horizontal: z.boolean().optional(),
  /** if true the image will be flipped vertically */
  vertical: z.boolean().optional(),
});

export type FlipOptions = z.infer<typeof FlipOptionsSchema>;

export const methods = {
  /**
   * Flip the image.
   * @param horizontal a Boolean, if true the image will be flipped horizontally
   * @param vertical a Boolean, if true the image will be flipped vertically
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   *
   * image.flip(true, false);
   * ```
   */
  flip<I extends JimpClass>(image: I, options: FlipOptions) {
    const { horizontal, vertical } = FlipOptionsSchema.parse(options);
    const bitmap = Buffer.alloc(image.bitmap.data.length);

    image.scan((x, y, idx) => {
      const _x = horizontal ? image.bitmap.width - 1 - x : x;
      const _y = vertical ? image.bitmap.height - 1 - y : y;
      const _idx = (image.bitmap.width * _y + _x) << 2;
      const data = image.bitmap.data.readUInt32BE(idx);

      bitmap.writeUInt32BE(data, _idx);
    });

    image.bitmap.data = Buffer.from(bitmap);

    return image;
  },
};
