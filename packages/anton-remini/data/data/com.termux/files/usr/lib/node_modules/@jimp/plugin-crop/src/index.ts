import { JimpClass } from "@jimp/types";
import { colorDiff, intToRGBA, scan } from "@jimp/utils";
import { z } from "zod";

export const CropOptionsSchema = z.object({
  /** the x position to crop form */
  x: z.number(),
  /** the y position to crop form */
  y: z.number(),
  /** the width to crop form */
  w: z.number(),
  /** the height to crop form */
  h: z.number(),
});

export type CropOptions = z.infer<typeof CropOptionsSchema>;

const AutocropComplexOptionsSchema = z.object({
  /** percent of color difference tolerance (default value) */
  tolerance: z.number().min(0).max(1).optional(),
  /** flag to force cropping only if the image has a real "frame" i.e. all 4 sides have some border (default value) */
  cropOnlyFrames: z.boolean().optional(),
  /** force cropping top be symmetric */
  cropSymmetric: z.boolean().optional(),
  /** Amount of pixels in border to leave */
  leaveBorder: z.number().optional(),
  ignoreSides: z
    .object({
      north: z.boolean().optional(),
      south: z.boolean().optional(),
      east: z.boolean().optional(),
      west: z.boolean().optional(),
    })
    .optional(),
});

export type AutocropComplexOptions = z.infer<
  typeof AutocropComplexOptionsSchema
>;
export type AutocropOptions = number | AutocropComplexOptions;

export const methods = {
  /**
   * Crops the image at a given point to a give size.
   *
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   * const cropped = image.crop(150, 100);
   * ```
   */
  crop<I extends JimpClass>(image: I, options: CropOptions) {
    let { x, y, w, h } = CropOptionsSchema.parse(options);
    // round input
    x = Math.round(x);
    y = Math.round(y);
    w = Math.round(w);
    h = Math.round(h);

    if (x === 0 && w === image.bitmap.width) {
      // shortcut
      const start = (w * y + x) << 2;
      const end = start + ((h * w) << 2);

      image.bitmap.data = image.bitmap.data.slice(start, end);
    } else {
      const bitmap = Buffer.allocUnsafe(w * h * 4);
      let offset = 0;

      scan(image, x, y, w, h, function (_, __, idx) {
        const data = image.bitmap.data.readUInt32BE(idx);
        bitmap.writeUInt32BE(data, offset);
        offset += 4;
      });

      image.bitmap.data = bitmap;
    }

    image.bitmap.width = w;
    image.bitmap.height = h;

    return image;
  },

  /**
   * Autocrop same color borders from this image.
   * This function will attempt to crop out transparent pixels from the image.
   *
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   * const cropped = image.autocrop();
   * ```
   */
  autocrop<I extends JimpClass>(image: I, options: AutocropOptions = {}) {
    const {
      tolerance = 0.0002,
      cropOnlyFrames = true,
      cropSymmetric = false,
      leaveBorder = 0,
      ignoreSides: ignoreSidesArg,
    } = typeof options === "number"
      ? ({ tolerance: options } as AutocropComplexOptions)
      : AutocropComplexOptionsSchema.parse(options);
    const w = image.bitmap.width;
    const h = image.bitmap.height;
    const minPixelsPerSide = 1; // to avoid cropping completely the image, resulting in an invalid 0 sized image

    // i.e. north and south / east and west are cropped by the same value
    const ignoreSides = {
      north: false,
      south: false,
      east: false,
      west: false,
      ...ignoreSidesArg,
    };

    /**
     * All borders must be of the same color as the top left pixel, to be cropped.
     * It should be possible to crop borders each with a different color,
     * but since there are many ways for corners to intersect, it would
     * introduce unnecessary complexity to the algorithm.
     */

    // scan each side for same color borders
    let colorTarget = image.getPixelColor(0, 0); // top left pixel color is the target color
    const rgba1 = intToRGBA(colorTarget);

    // for north and east sides
    let northPixelsToCrop = 0;
    let eastPixelsToCrop = 0;
    let southPixelsToCrop = 0;
    let westPixelsToCrop = 0;

    // north side (scan rows from north to south)
    colorTarget = image.getPixelColor(0, 0);
    if (!ignoreSides.north) {
      north: for (let y = 0; y < h - minPixelsPerSide; y++) {
        for (let x = 0; x < w; x++) {
          const colorXY = image.getPixelColor(x, y);
          const rgba2 = intToRGBA(colorXY);

          if (colorDiff(rgba1, rgba2) > tolerance) {
            // this pixel is too distant from the first one: abort this side scan
            break north;
          }
        }

        // this row contains all pixels with the same color: increment this side pixels to crop
        northPixelsToCrop++;
      }
    }

    // west side (scan columns from west to east)
    colorTarget = image.getPixelColor(w, 0);
    if (!ignoreSides.west) {
      west: for (let x = 0; x < w - minPixelsPerSide; x++) {
        for (let y = 0 + northPixelsToCrop; y < h; y++) {
          const colorXY = image.getPixelColor(x, y);
          const rgba2 = intToRGBA(colorXY);

          if (colorDiff(rgba1, rgba2) > tolerance) {
            // this pixel is too distant from the first one: abort this side scan
            break west;
          }
        }

        // this column contains all pixels with the same color: increment this side pixels to crop
        westPixelsToCrop++;
      }
    }

    // south side (scan rows from south to north)
    colorTarget = image.getPixelColor(0, h);

    if (!ignoreSides.south) {
      south: for (
        let y = h - 1;
        y >= northPixelsToCrop + minPixelsPerSide;
        y--
      ) {
        for (let x = w - eastPixelsToCrop - 1; x >= 0; x--) {
          const colorXY = image.getPixelColor(x, y);
          const rgba2 = intToRGBA(colorXY);

          if (colorDiff(rgba1, rgba2) > tolerance) {
            // this pixel is too distant from the first one: abort this side scan
            break south;
          }
        }

        // this row contains all pixels with the same color: increment this side pixels to crop
        southPixelsToCrop++;
      }
    }

    // east side (scan columns from east to west)
    colorTarget = image.getPixelColor(w, h);
    if (!ignoreSides.east) {
      east: for (
        let x = w - 1;
        x >= 0 + westPixelsToCrop + minPixelsPerSide;
        x--
      ) {
        for (let y = h - 1; y >= 0 + northPixelsToCrop; y--) {
          const colorXY = image.getPixelColor(x, y);
          const rgba2 = intToRGBA(colorXY);

          if (colorDiff(rgba1, rgba2) > tolerance) {
            // this pixel is too distant from the first one: abort this side scan
            break east;
          }
        }

        // this column contains all pixels with the same color: increment this side pixels to crop
        eastPixelsToCrop++;
      }
    }

    // decide if a crop is needed
    let doCrop = false;

    // apply leaveBorder
    westPixelsToCrop -= leaveBorder;
    eastPixelsToCrop -= leaveBorder;
    northPixelsToCrop -= leaveBorder;
    southPixelsToCrop -= leaveBorder;

    if (cropSymmetric) {
      const horizontal = Math.min(eastPixelsToCrop, westPixelsToCrop);
      const vertical = Math.min(northPixelsToCrop, southPixelsToCrop);
      westPixelsToCrop = horizontal;
      eastPixelsToCrop = horizontal;
      northPixelsToCrop = vertical;
      southPixelsToCrop = vertical;
    }

    // make sure that crops are >= 0
    westPixelsToCrop = westPixelsToCrop >= 0 ? westPixelsToCrop : 0;
    eastPixelsToCrop = eastPixelsToCrop >= 0 ? eastPixelsToCrop : 0;
    northPixelsToCrop = northPixelsToCrop >= 0 ? northPixelsToCrop : 0;
    southPixelsToCrop = southPixelsToCrop >= 0 ? southPixelsToCrop : 0;

    // safety checks
    const widthOfRemainingPixels = w - (westPixelsToCrop + eastPixelsToCrop);
    const heightOfRemainingPixels = h - (southPixelsToCrop + northPixelsToCrop);

    if (cropOnlyFrames) {
      // crop image if all sides should be cropped
      doCrop =
        eastPixelsToCrop !== 0 &&
        northPixelsToCrop !== 0 &&
        westPixelsToCrop !== 0 &&
        southPixelsToCrop !== 0;
    } else {
      // crop image if at least one side should be cropped
      doCrop =
        eastPixelsToCrop !== 0 ||
        northPixelsToCrop !== 0 ||
        westPixelsToCrop !== 0 ||
        southPixelsToCrop !== 0;
    }

    if (doCrop) {
      // do the real crop
      this.crop(image, {
        x: westPixelsToCrop,
        y: northPixelsToCrop,
        w: widthOfRemainingPixels,
        h: heightOfRemainingPixels,
      });
    }

    return image;
  },
};
