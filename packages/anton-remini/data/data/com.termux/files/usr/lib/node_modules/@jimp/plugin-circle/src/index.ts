import { JimpClass } from "@jimp/types";
import { z } from "zod";

const CircleOptionsSchema = z.object({
  /** the x position to draw the circle */
  x: z.number().optional(),
  /** the y position to draw the circle */
  y: z.number().optional(),
  /** the radius of the circle */
  radius: z.number().min(0).optional(),
});

export type CircleOptions = z.infer<typeof CircleOptionsSchema>;

export const methods = {
  /**
   * Creates a circle out of an image.
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   *
   * image.circle();
   * // or
   * image.circle({ radius: 50, x: 25, y: 25 });
   * ```
   */
  circle<I extends JimpClass>(image: I, options: CircleOptions = {}) {
    const parsed = CircleOptionsSchema.parse(options);
    const radius =
      parsed.radius ||
      (image.bitmap.width > image.bitmap.height
        ? image.bitmap.height
        : image.bitmap.width) / 2;

    const center = {
      x: typeof parsed.x === "number" ? parsed.x : image.bitmap.width / 2,
      y: typeof parsed.y === "number" ? parsed.y : image.bitmap.height / 2,
    };

    image.scan((x, y, idx) => {
      const curR = Math.sqrt(
        Math.pow(x - center.x, 2) + Math.pow(y - center.y, 2),
      );

      if (radius - curR <= 0.0) {
        image.bitmap.data[idx + 3] = 0;
      } else if (radius - curR < 1.0) {
        image.bitmap.data[idx + 3] = 255 * (radius - curR);
      }
    });

    return image;
  },
};
