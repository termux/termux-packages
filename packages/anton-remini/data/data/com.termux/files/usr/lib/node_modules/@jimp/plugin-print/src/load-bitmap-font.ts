import parseASCII from "parse-bmfont-ascii";
import parseXML from "parse-bmfont-xml";
import readBinary from "parse-bmfont-binary";
import { BmCharacter, BmKerning, BmFont, BmCommonProps } from "./types.js";
import png from "@jimp/js-png";
import { createJimp } from "@jimp/core";
import path from "path";
import xmlPackage from "simple-xml-to-json";

const { convertXML } = xmlPackage;

export const isWebWorker =
  typeof self !== "undefined" && self.document === undefined;

const CharacterJimp = createJimp({ formats: [png] });
const HEADER = Buffer.from([66, 77, 70, 3]);

function isBinary(buf: Buffer | string) {
  if (typeof buf === "string") {
    return buf.substring(0, 3) === "BMF";
  }

  const startOfHeader = buf.slice(0, 4);

  return (
    buf.length > 4 &&
    startOfHeader[0] === HEADER[0] &&
    startOfHeader[1] === HEADER[1] &&
    startOfHeader[2] === HEADER[2]
  );
}

export interface LoadedFont {
  chars: BmCharacter[];
  kernings: BmKerning[];
  common: BmCommonProps;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  info: Record<string, any>;
  pages: string[];
}

function parseFont(file: string, data: Buffer | string): LoadedFont {
  if (isBinary(data)) {
    if (typeof data === "string") {
      data = Buffer.from(data, "binary");
    }

    return readBinary(data);
  }

  data = data.toString().trim();

  if (/.json$/.test(file) || data.charAt(0) === "{") {
    return JSON.parse(data);
  }

  if (/.xml$/.test(file) || data.charAt(0) === "<") {
    return parseXML(data);
  }

  return parseASCII(data);
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function parseNumbersInObject<T extends Record<string, any>>(obj: T) {
  for (const key in obj) {
    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (obj as any)[key] = parseInt(obj[key], 10);
    } catch {
      // do nothing
    }

    if (typeof obj[key] === "object") {
      parseNumbersInObject(obj[key]);
    }
  }

  return obj;
}

/**
 *
 * @param bufferOrUrl A URL to a file or a buffer
 * @returns
 */
export async function loadBitmapFontData(
  bufferOrUrl: string | Buffer
): Promise<LoadedFont> {
  if (isWebWorker && typeof bufferOrUrl === "string") {
    const res = await fetch(bufferOrUrl);
    const text = await res.text();
    const json = convertXML(text);

    const font = json.font.children.reduce(
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (acc: Record<string, any>, i: any) => ({ ...acc, ...i }),
      {}
    );
    const pages: LoadedFont["pages"] = [];
    const chars: LoadedFont["chars"] = [];
    const kernings: LoadedFont["kernings"] = [];

    for (let i = 0; i < font.pages.children.length; i++) {
      const p = font.pages.children[i].page;
      const id = parseInt(p.id, 10);
      pages[id] = parseNumbersInObject(p.file);
    }

    for (let i = 0; i < font.chars.children.length; i++) {
      chars.push(parseNumbersInObject(font.chars.children[i].char));
    }

    for (let i = 0; i < font.kernings.children.length; i++) {
      kernings.push(parseNumbersInObject(font.kernings.children[i].kerning));
    }

    return {
      info: font.info,
      common: font.common,
      pages,
      chars,
      kernings,
    } satisfies LoadedFont;
  } else if (typeof bufferOrUrl === "string") {
    const res = await fetch(bufferOrUrl);
    const text = await res.text();

    return parseFont(bufferOrUrl, text);
  } else {
    return parseFont("", bufferOrUrl);
  }
}

type RawFont = Awaited<ReturnType<typeof loadBitmapFontData>>;
export type ResolveBmFont = Omit<BmFont, "pages"> & Pick<RawFont, "pages">;

export async function processBitmapFont(file: string, font: LoadedFont) {
  const chars: Record<string, BmCharacter> = {};
  const kernings: Record<string, BmKerning> = {};

  for (let i = 0; i < font.chars.length; i++) {
    const char = font.chars[i]!;
    chars[String.fromCharCode(char.id)] = char;
  }

  for (let i = 0; i < font.kernings.length; i++) {
    const firstString = String.fromCharCode(font.kernings[i]!.first);

    kernings[firstString] = kernings[firstString]! || {};
    kernings[firstString]![String.fromCharCode(font.kernings[i]!.second)] =
      font.kernings[i]!.amount;
  }

  return {
    ...font,
    chars,
    kernings,
    pages: await Promise.all(
      font.pages.map(async (page) =>
        CharacterJimp.read(path.join(path.dirname(file), page))
      )
    ),
  };
}
