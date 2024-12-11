import { JimpClass, JimpClassSchema } from "@jimp/types";
import { limit255, scan } from "@jimp/utils";
import { z } from "zod";

const BlitOptionsSchemaComplex = z.object({
  src: JimpClassSchema,
  /** the x position to blit the image */
  x: z.number().optional(),
  /** the y position to blit the image */
  y: z.number().optional(),
  /** the x position from which to crop the source image */
  srcX: z.number().optional(),
  /** the y position from which to crop the source image */
  srcY: z.number().optional(),
  /** the width to which to crop the source image */
  srcW: z.number().optional(),
  /** the height to which to crop the source image */
  srcH: z.number().optional(),
});

type BlitOptionsComplex = z.infer<typeof BlitOptionsSchemaComplex>;

const BlitOptionsSchema = z.union([JimpClassSchema, BlitOptionsSchemaComplex]);

export type BlitOptions = z.infer<typeof BlitOptionsSchema>;

export const methods = {
  /**
   * Short for "bit-block transfer".
   * It involves the transfer of a block of pixel data from one area of a computer's memory to another area, typically for the purpose of rendering images on the screen or manipulating them in various ways.
   * It's a fundamental operation in computer graphics utilized in various applications, from operating systems to video games.
   *
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   * const parrot = await Jimp.read("test/party-parrot.png");
   *
   * image.blit({ src: parrot, x: 10, y: 10 });
   * ```
   */
  blit<I extends JimpClass>(image: I, options: BlitOptions) {
    const parsed = BlitOptionsSchema.parse(options);
    let {
      // eslint-disable-next-line prefer-const
      src,
      x = 0,
      y = 0,
      srcX = 0,
      srcY = 0,
      srcW = src.bitmap.width,
      srcH = src.bitmap.height,
    } = "bitmap" in parsed ? ({ src: parsed } as BlitOptionsComplex) : parsed;

    if (!("bitmap" in src)) {
      throw new Error("The source must be a Jimp image");
    }

    if (typeof x !== "number" || typeof y !== "number") {
      throw new Error("x and y must be numbers");
    }

    // round input
    x = Math.round(x);
    y = Math.round(y);

    // round input
    srcX = Math.round(srcX);
    srcY = Math.round(srcY);
    srcW = Math.round(srcW);
    srcH = Math.round(srcH);

    const maxWidth = image.bitmap.width;
    const maxHeight = image.bitmap.height;

    scan(src, srcX, srcY, srcW, srcH, function (sx, sy, idx) {
      const xOffset = x + sx - srcX;
      const yOffset = y + sy - srcY;

      if (
        xOffset >= 0 &&
        yOffset >= 0 &&
        maxWidth - xOffset > 0 &&
        maxHeight - yOffset > 0
      ) {
        const dstIdx = image.getPixelIndex(xOffset, yOffset);
        const srcColor = {
          r: src.bitmap.data[idx] || 0,
          g: src.bitmap.data[idx + 1] || 0,
          b: src.bitmap.data[idx + 2] || 0,
          a: src.bitmap.data[idx + 3] || 0,
        };

        const dst = {
          r: image.bitmap.data[dstIdx] || 0,
          g: image.bitmap.data[dstIdx + 1] || 0,
          b: image.bitmap.data[dstIdx + 2] || 0,
          a: image.bitmap.data[dstIdx + 3] || 0,
        };

        image.bitmap.data[dstIdx] =
          ((srcColor.a * (srcColor.r - dst.r) - dst.r + 255) >> 8) + dst.r;
        image.bitmap.data[dstIdx + 1] =
          ((srcColor.a * (srcColor.g - dst.g) - dst.g + 255) >> 8) + dst.g;
        image.bitmap.data[dstIdx + 2] =
          ((srcColor.a * (srcColor.b - dst.b) - dst.b + 255) >> 8) + dst.b;
        image.bitmap.data[dstIdx + 3] = limit255(dst.a + srcColor.a);
      }
    });

    return image;
  },
};
