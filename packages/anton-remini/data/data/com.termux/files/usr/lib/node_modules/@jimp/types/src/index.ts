import { z } from "zod";

export enum Edge {
  EXTEND = 1,
  WRAP = 2,
  CROP = 3,
}

export interface Bitmap {
  data: Buffer;
  width: number;
  height: number;
}

export interface Format<
  Mime extends string = string,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ExportOptions extends Record<string, any> | undefined = undefined,
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  DecodeOptions extends Record<string, any> | undefined = undefined,
> {
  mime: Mime;
  hasAlpha?: boolean;
  encode: (image: Bitmap, options?: ExportOptions) => Promise<Buffer> | Buffer;
  decode: (data: Buffer, options?: DecodeOptions) => Promise<Bitmap> | Bitmap;
}

export interface RGBColor {
  r: number;
  g: number;
  b: number;
}

export interface RGBAColor {
  r: number;
  g: number;
  b: number;
  a: number;
}

export const JimpClassSchema = z.object({
  bitmap: z.object({
    data: z.union([z.instanceof(Buffer), z.instanceof(Uint8Array)]),
    width: z.number(),
    height: z.number(),
  }),
});

export interface JimpClass {
  background: number;
  bitmap: Bitmap;

  getPixelIndex: (x: number, y: number, edgeHandling?: Edge) => number;
  getPixelColor: (x: number, y: number) => number;
  setPixelColor: (hex: number, x: number, y: number) => JimpClass;

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  scan(f: (x: number, y: number, idx: number) => any): JimpClass;
  scan(
    x: number,
    y: number,
    w: number,
    h: number,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    cb: (x: number, y: number, idx: number) => any
  ): JimpClass;
  scan(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    x: number | ((x: number, y: number, idx: number) => any),
    y?: number,
    w?: number,
    h?: number,
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    f?: (x: number, y: number, idx: number) => any
  ): JimpClass;
}
