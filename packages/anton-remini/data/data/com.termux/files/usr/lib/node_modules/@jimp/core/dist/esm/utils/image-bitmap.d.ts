import { JimpClass } from "@jimp/types";
/**
 * Obtains image orientation from EXIF metadata.
 *
 * @param img a Jimp image object
 * @returns a number 1-8 representing EXIF orientation,
 *          in particular 1 if orientation tag is missing
 */
export declare function getExifOrientation<I extends JimpClass>(img: I): number;
export declare function attemptExifRotate<I extends JimpClass>(image: I, buffer: Buffer): Promise<void>;
//# sourceMappingURL=image-bitmap.d.ts.map