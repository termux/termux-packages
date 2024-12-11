import {
  isWebWorker,
  loadBitmapFontData,
  processBitmapFont,
} from "./load-bitmap-font.js";

/**
 * Loads a Bitmap Font from a file.
 * @param file A path or URL to a font file
 * @returns A collection of Jimp images that can be used to print text
 * @example
 * ```ts
 * import { Jimp, loadFont } from "jimp";
 * import { SANS_10_BLACK } from "jimp/fonts";
 *
 * const font = await loadFont(SANS_10_BLACK);
 * const image = new Jimp({ width: 200, height: 100, color: 0xffffffff });
 *
 * image.print(font, 10, 10, "Hello world!");
 * ```
 */
export async function loadFont(file: string) {
  let fileOrBuffer: string | Buffer = file;

  if (typeof window === "undefined" && !isWebWorker) {
    const { existsSync, promises: fs } = await import("fs");

    if (existsSync(file)) {
      fileOrBuffer = await fs.readFile(file);
    }
  }

  const data = await loadBitmapFontData(fileOrBuffer);
  return processBitmapFont(file, data);
}
