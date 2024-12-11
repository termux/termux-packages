import { JimpClass } from "@jimp/types";
import { clone } from "@jimp/utils";
import { z } from "zod";

const FisheyeOptionsSchema = z.object({
  /** the radius of the circle */
  radius: z.number().min(0).optional(),
});

export type FisheyeOptions = z.infer<typeof FisheyeOptionsSchema>;

export const methods = {
  /**
   * Adds a fisheye effect to the image.
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   *
   * image.fisheye();
   * ```
   */
  fisheye<I extends JimpClass>(image: I, options: FisheyeOptions = {}) {
    const { radius = 2.5 } = FisheyeOptionsSchema.parse(options);
    const source = clone(image);
    const { width, height } = source.bitmap;

    source.scan((x, y) => {
      const hx = x / width;
      const hy = y / height;
      const rActual = Math.sqrt(Math.pow(hx - 0.5, 2) + Math.pow(hy - 0.5, 2));
      const rn = 2 * Math.pow(rActual, radius);
      const cosA = (hx - 0.5) / rActual;
      const sinA = (hy - 0.5) / rActual;
      const newX = Math.round((rn * cosA + 0.5) * width);
      const newY = Math.round((rn * sinA + 0.5) * height);
      const color = source.getPixelColor(newX, newY);

      image.setPixelColor(color, x, y);
    });

    /* Set center pixel color, otherwise it will be transparent */
    image.setPixelColor(
      source.getPixelColor(width / 2, height / 2),
      width / 2,
      height / 2,
    );

    return image;
  },
};
