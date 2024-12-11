import { ResizeStrategy, methods as resizeMethods } from "@jimp/plugin-resize";
import { JimpClass } from "@jimp/types";
import { clone } from "@jimp/utils";
import { composite } from "@jimp/core";
import { methods as cropMethods } from "@jimp/plugin-crop";
import { z } from "zod";

const RotateOptionsSchema = z.union([
  z.number(),
  z.object({
    /** the number of degrees to rotate the image by */
    deg: z.number(),
    /** resize mode or a boolean, if false then the width and height of the image will not be changed */
    mode: z.union([z.boolean(), z.nativeEnum(ResizeStrategy)]).optional(),
  }),
]);

export type RotateOptions = z.infer<typeof RotateOptionsSchema>;

/** function to translate the x, y coordinate to the index of the pixel in the buffer */
function createIdxTranslationFunction(w: number) {
  return function (x: number, y: number) {
    return (y * w + x) << 2;
  };
}

/**
 * Rotates an image counter-clockwise by multiple of 90 degrees. NB: 'this' must be a Jimp object.
 *
 * This function is based on matrix rotation. Check this to get an initial idea how it works: https://stackoverflow.com/a/8664879/10561909
 *
 * @param deg the number of degrees to rotate the image by, it should be a multiple of 90
 */
function matrixRotate<I extends JimpClass>(image: I, deg: number) {
  if (Math.abs(deg) % 90 !== 0) {
    throw new Error("Unsupported matrix rotation degree");
  }

  const w = image.bitmap.width;
  const h = image.bitmap.height;

  // decide which rotation angle to use
  let angle;

  switch (deg) {
    // 90 degree & -270 degree are same
    case 90:
    case -270:
      angle = 90;
      break;

    case 180:
    case -180:
      angle = 180;
      break;

    case 270:
    case -90:
      angle = -90;
      break;

    default:
      throw new Error("Unsupported matrix rotation degree");
  }
  // After this switch block, angle will be 90, 180 or -90

  // calculate the new width and height
  const nW = angle === 180 ? w : h;
  const nH = angle === 180 ? h : w;

  const dstBuffer = Buffer.alloc(image.bitmap.data.length);

  const srcIdxFunction = createIdxTranslationFunction(w);
  const dstIdxFunction = createIdxTranslationFunction(nW);

  for (let x = 0; x < w; x++) {
    for (let y = 0; y < h; y++) {
      const srcIdx = srcIdxFunction(x, y);
      const pixelRGBA = image.bitmap.data.readUInt32BE(srcIdx);

      let dstIdx;
      switch (angle) {
        case 90:
          dstIdx = dstIdxFunction(y, w - x - 1);
          break;
        case -90:
          dstIdx = dstIdxFunction(h - y - 1, x);
          break;
        case 180:
          dstIdx = dstIdxFunction(w - x - 1, h - y - 1);
          break;
        default:
          throw new Error("Unsupported matrix rotation angle");
      }

      dstBuffer.writeUInt32BE(pixelRGBA, dstIdx);
    }
  }

  image.bitmap.data = dstBuffer;
  image.bitmap.width = nW;
  image.bitmap.height = nH;
}

function createTranslationFunction(deltaX: number, deltaY: number) {
  return function (x: number, y: number) {
    return {
      x: x + deltaX,
      y: y + deltaY,
    };
  };
}

/**
 * Rotates an image counter-clockwise by an arbitrary number of degrees. NB: 'this' must be a Jimp object.
 * @param {number} deg the number of degrees to rotate the image by
 */
function advancedRotate<I extends JimpClass>(
  image: I,
  deg: number,
  mode: boolean | ResizeStrategy
) {
  const rad = (deg * Math.PI) / 180;
  const cosine = Math.cos(rad);
  const sine = Math.sin(rad);

  // the final width and height will change if resize == true
  let w = image.bitmap.width;
  let h = image.bitmap.height;

  if (mode === true || typeof mode === "string") {
    // resize the image to it maximum dimension and blit the existing image
    // onto the center so that when it is rotated the image is kept in bounds

    // http://stackoverflow.com/questions/3231176/how-to-get-size-of-a-rotated-rectangle
    // Plus 1 border pixel to ensure to show all rotated result for some cases.
    w =
      Math.ceil(
        Math.abs(image.bitmap.width * cosine) +
          Math.abs(image.bitmap.height * sine)
      ) + 1;
    h =
      Math.ceil(
        Math.abs(image.bitmap.width * sine) +
          Math.abs(image.bitmap.height * cosine)
      ) + 1;
    // Ensure destination to have even size to a better result.
    if (w % 2 !== 0) {
      w++;
    }

    if (h % 2 !== 0) {
      h++;
    }

    const c = clone(image);

    image.scan((_, __, idx) => {
      image.bitmap.data.writeUInt32BE(image.background, idx);
    });

    const max = Math.max(w, h, image.bitmap.width, image.bitmap.height);
    image = resizeMethods.resize(image, {
      h: max,
      w: max,
      mode: mode === true ? undefined : mode,
    });

    image = composite(
      image,
      c,
      image.bitmap.width / 2 - c.bitmap.width / 2,
      image.bitmap.height / 2 - c.bitmap.height / 2
    );
  }

  const bW = image.bitmap.width;
  const bH = image.bitmap.height;
  const dstBuffer = Buffer.alloc(image.bitmap.data.length);

  const translate2Cartesian = createTranslationFunction(-(bW / 2), -(bH / 2));
  const translate2Screen = createTranslationFunction(
    bW / 2 + 0.5,
    bH / 2 + 0.5
  );

  for (let y = 1; y <= bH; y++) {
    for (let x = 1; x <= bW; x++) {
      const cartesian = translate2Cartesian(x, y);
      const source = translate2Screen(
        cosine * cartesian.x - sine * cartesian.y,
        cosine * cartesian.y + sine * cartesian.x
      );
      const dstIdx = (bW * (y - 1) + x - 1) << 2;

      if (source.x >= 0 && source.x < bW && source.y >= 0 && source.y < bH) {
        const srcIdx = ((bW * (source.y | 0) + source.x) | 0) << 2;
        const pixelRGBA = image.bitmap.data.readUInt32BE(srcIdx);
        dstBuffer.writeUInt32BE(pixelRGBA, dstIdx);
      } else {
        // reset off-image pixels
        dstBuffer.writeUInt32BE(image.background, dstIdx);
      }
    }
  }

  image.bitmap.data = dstBuffer;

  if (mode === true || typeof mode === "string") {
    // now crop the image to the final size
    const x = Math.max(bW / 2 - w / 2, 0);
    const y = Math.max(bH / 2 - h / 2, 0);
    image = cropMethods.crop(image, { x, y, w, h });
  }
}

export const methods = {
  /**
   * Rotates the image counter-clockwise by a number of degrees. By default the width and height of the image will be resized appropriately.
   * @example
   * ```ts
   * import { Jimp } from "jimp";
   *
   * const image = await Jimp.read("test/image.png");
   *
   * image.rotate(90);
   * ```
   */
  rotate<I extends JimpClass>(image: I, options: RotateOptions) {
    const parsed = RotateOptionsSchema.parse(options);
    const actualOptions = typeof parsed === "number" ? { deg: parsed } : parsed;
    const { mode = true } = actualOptions;
    let { deg } = actualOptions;

    // No need to do extra rotation
    deg %= 360;

    // no rotation for 0, 360, -360, 720, -720, ...
    if (deg % 360 === 0) {
      return image;
    }

    // use matrixRotate if the angle is a multiple of 90 degrees (eg: 180 or -90) and resize is allowed or not needed.
    const matrixRotateAllowed =
      deg % 90 === 0 &&
      (mode || image.bitmap.width === image.bitmap.height || deg % 180 === 0);

    if (matrixRotateAllowed) {
      matrixRotate(image, deg);
    } else {
      advancedRotate(image, deg, mode);
    }

    return image;
  },
};
