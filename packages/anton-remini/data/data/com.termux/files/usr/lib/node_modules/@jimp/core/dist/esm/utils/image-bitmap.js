import EXIFParser from "exif-parser";
/**
 * Obtains image orientation from EXIF metadata.
 *
 * @param img a Jimp image object
 * @returns a number 1-8 representing EXIF orientation,
 *          in particular 1 if orientation tag is missing
 */
export function getExifOrientation(img) {
    const _exif = img._exif;
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
function getExifOrientationTransformation(img) {
    const w = img.bitmap.width;
    const h = img.bitmap.height;
    switch (getExifOrientation(img)) {
        case 1: // Horizontal (normal)
            // does not need to be supported here
            return null;
        case 2: // Mirror horizontal
            return function (x, y) {
                return [w - x - 1, y];
            };
        case 3: // Rotate 180
            return function (x, y) {
                return [w - x - 1, h - y - 1];
            };
        case 4: // Mirror vertical
            return function (x, y) {
                return [x, h - y - 1];
            };
        case 5: // Mirror horizontal and rotate 270 CW
            return function (x, y) {
                return [y, x];
            };
        case 6: // Rotate 90 CW
            return function (x, y) {
                return [y, h - x - 1];
            };
        case 7: // Mirror horizontal and rotate 90 CW
            return function (x, y) {
                return [w - y - 1, h - x - 1];
            };
        case 8: // Rotate 270 CW
            return function (x, y) {
                return [w - y - 1, x];
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
function transformBitmap(img, width, height, transformation) {
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
function exifRotate(img) {
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
export async function attemptExifRotate(image, buffer) {
    try {
        image._exif =
            EXIFParser.create(buffer).parse();
        exifRotate(image); // EXIF data
    }
    catch {
        // do nothing
    }
}
//# sourceMappingURL=image-bitmap.js.map