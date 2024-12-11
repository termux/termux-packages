import EXIFParser, { ExifData } from "exif-parser";
import { JimpClass } from "@jimp/types";

/**
 * Obtains image orientation from EXIF metadata.
 *
 * @param img a Jimp image object
 * @returns a number 1-8 representing EXIF orientation,
 *          in particular 1 if orientation tag is missing
 */
export function getExifOrientation<I extends JimpClass>(img: I) {
  const _exif = (img as unknown as { _exif: ExifData })._exif;
  return (_exif && _exif.tags && _exif.tags.Orientation) || 1;
}

/**
 * Returns a function which translates EXIF-rotated coordinates into
 * non-rotated ones.
 *
 * Transformation reference: http://sylvana.net/jpegcrop/exif_orientation.html.
 *
 * @param img a Jimp image object
 * @returns transformation function for transformBitmap().
 */
function getExifOrientationTransformation<I extends JimpClass>(img: I) {
  const w = img.bitmap.width;
  const h = img.bitmap.height;

  switch (getExifOrientation(img)) {
    case 1: // Horizontal (normal)
      // does not need to be supported here
      return null;

    case 2: // Mirror horizontal
      return function (x: number, y: number) {
        return [w - x - 1, y] as const;
      };

    case 3: // Rotate 180
      return function (x: number, y: number) {
        return [w - x - 1, h - y - 1] as const;
      };

    case 4: // Mirror vertical
      return function (x: number, y: number) {
        return [x, h - y - 1] as const;
      };

    case 5: // Mirror horizontal and rotate 270 CW
      return function (x: number, y: number) {
        return [y, x] as const;
      };

    case 6: // Rotate 90 CW
      return function (x: number, y: number) {
        return [y, h - x - 1] as const;
      };

    case 7: // Mirror horizontal and rotate 90 CW
      return function (x: number, y: number) {
        return [w - y - 1, h - x - 1] as const;
      };

    case 8: // Rotate 270 CW
      return function (x: number, y: number) {
        return [w - y - 1, x] as const;
      };

    default:
      return null;
  }
}

/**
 * Transforms bitmap in place (moves pixels around) according to given
 * transformation function.
 *
 * @param img a Jimp image object, which bitmap is supposed to
 *        be transformed
 * @param width bitmap width after the transformation
 * @param height bitmap height after the transformation
 * @param transformation transformation function which defines pixel
 *        mapping between new and source bitmap. It takes a pair of coordinates
 *        in the target, and returns a respective pair of coordinates in
 *        the source bitmap, i.e. has following form:
 *        `function(new_x, new_y) { return [src_x, src_y] }`.
 */
function transformBitmap<I extends JimpClass>(
  img: I,
  width: number,
  height: number,
  transformation: (x: number, y: number) => readonly [number, number]
) {
  // Underscore-prefixed values are related to the source bitmap
  // Their counterparts with no prefix are related to the target bitmap
  const _data = img.bitmap.data;
  const _width = img.bitmap.width;

  const data = Buffer.alloc(_data.length);

  for (let x = 0; x < width; x++) {
    for (let y = 0; y < height; y++) {
      const [_x, _y] = transformation(x, y);

      const idx = (width * y + x) << 2;
      const _idx = (_width * _y + _x) << 2;

      const pixel = _data.readUInt32BE(_idx);
      data.writeUInt32BE(pixel, idx);
    }
  }

  img.bitmap.data = data;
  img.bitmap.width = width;
  img.bitmap.height = height;

  // @ts-expect-error Accessing private property
  img._exif.tags.Orientation = 1;
}

/**
 * Automagically rotates an image based on its EXIF data (if present).
 * @param img  a Jimp image object
 */
function exifRotate<I extends JimpClass>(img: I) {
  if (getExifOrientation(img) < 2) {
    return;
  }

  const transformation = getExifOrientationTransformation(img);
  const swapDimensions = getExifOrientation(img) > 4;

  const newWidth = swapDimensions ? img.bitmap.height : img.bitmap.width;
  const newHeight = swapDimensions ? img.bitmap.width : img.bitmap.height;

  if (transformation) {
    transformBitmap(img, newWidth, newHeight, transformation);
  }
}

export async function attemptExifRotate<I extends JimpClass>(
  image: I,
  buffer: Buffer
) {
  try {
    (image as unknown as { _exif: ExifData })._exif =
      EXIFParser.create(buffer).parse();

    exifRotate(image); // EXIF data
  } catch {
    // do nothing
  }
}
