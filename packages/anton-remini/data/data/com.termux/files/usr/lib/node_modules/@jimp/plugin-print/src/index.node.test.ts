import { expect, test, describe } from "vitest";
import "@jimp/test-utils/image-snapshot";
import { HorizontalAlign, VerticalAlign, createJimp } from "@jimp/core";
import png from "@jimp/js-png";
import jpeg from "@jimp/js-jpeg";

import { methods, measureText, measureTextHeight } from "./index.js";
import { loadFont } from "./load-font.js";
import * as fonts from "./fonts.js";

const Jimp = createJimp({ plugins: [methods], formats: [png, jpeg] });

async function createTextImage(
  width: number,
  height: number,
  font: string,
  {
    x = 0,
    y = 0,
    text,
    maxWidth,
    maxHeight,
  }: {
    text:
      | string
      | {
          text: string;
          alignmentX?: HorizontalAlign;
          alignmentY?: VerticalAlign;
        };
    maxWidth?: number;
    maxHeight?: number;
    x?: number;
    y?: number;
  },
) {
  const loadedFont = await loadFont(font);
  const image = new Jimp({ width, height, color: 0xffffffff });

  return image
    .print({ font: loadedFont, x, y, text, maxWidth, maxHeight })
    .getBuffer("image/png");
}

describe("Write text over image", function () {
  const fontDefs = {
    SANS_8_BLACK: { w: 28, h: 28, bg: 0xffffffff },

    SANS_16_BLACK: { w: 54, h: 54, bg: 0xffffffff },
    SANS_32_BLACK: { w: 114, h: 114, bg: 0xffffffff },
    SANS_64_BLACK: { w: 220, h: 220, bg: 0xffffffff },

    SANS_8_WHITE: { w: 28, h: 28, bg: 0x000000ff },

    SANS_16_WHITE: { w: 54, h: 54, bg: 0x000000ff },
    SANS_32_WHITE: { w: 114, h: 114, bg: 0x000000ff },
    SANS_64_WHITE: { w: 220, h: 220, bg: 0x000000ff },
  };

  Object.entries(fontDefs).forEach(([fontName, conf]) => {
    test("Jimp preset " + fontName + " bitmap font", async () => {
      const font = await loadFont(fonts[fontName as keyof typeof fonts]);
      const image = new Jimp({ width: conf.w, height: conf.h, color: conf.bg });
      const output = await image
        .print({
          font,
          x: 0,
          y: 0,
          text: "This is only a test.",
          maxWidth: image.bitmap.width,
        })
        .getBuffer("image/png");

      expect(output).toMatchImageSnapshot();
    });
  });

  test("Jimp preset SANS_16_BLACK bitmap font positioned", async () => {
    const font = await loadFont(fonts.SANS_16_BLACK);
    const image = new Jimp({ width: 300, height: 100, color: 0xff8800ff });
    const output = await image
      .print({
        font,
        x: 150,
        y: 50,
        text: "This is only a test.",
        maxWidth: 100,
      })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("Jimp loads font from URL", async () => {
    const font = await loadFont(
      "https://raw.githubusercontent.com/jimp-dev/jimp/main/plugins/plugin-print/fonts/open-sans/open-sans-16-black/open-sans-16-black.fnt",
    );
    const image = new Jimp({ width: 300, height: 100, color: 0xff8800ff });
    const output = await image
      .print({
        font,
        x: 150,
        y: 50,
        text: "This is only a test.",
        maxWidth: 100,
      })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("Max width works without spaces", async () => {
    const font = await loadFont(
      "https://raw.githubusercontent.com/jimp-dev/jimp/main/plugins/plugin-print/fonts/open-sans/open-sans-16-black/open-sans-16-black.fnt",
    );
    const image = new Jimp({ width: 300, height: 100, color: 0xff8800ff });
    const output = await image
      .print({
        font,
        x: 150,
        y: 50,
        text: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        maxWidth: 100,
      })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("Jimp renders ? for unknown characters", async () => {
    const font = await loadFont(fonts.SANS_16_BLACK);
    const image = new Jimp({ width: 300, height: 100, color: 0xff8800ff });
    const output = await image
      .print({ font, x: 0, y: 0, text: "ツ ツ ツ", maxWidth: 100 })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("Jimp can print numbers too", async () => {
    const font = await loadFont(fonts.SANS_16_BLACK);
    const image = new Jimp({ width: 300, height: 100, color: 0xff8800ff });
    const output = await image
      .print({ font, x: 0, y: 0, text: 12345678, maxWidth: 100 })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("left-align text by default", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: "This is only a test.",
      maxWidth: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("left-align text by default when passing object", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: { text: "This is only a test." },
      maxWidth: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("left-align text when passing object with alignmentX", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: {
        text: "This is only a test.",
        alignmentX: HorizontalAlign.LEFT,
      },
      maxWidth: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("center-align text when passing object with alignmentX", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: {
        text: "This is only a test.",
        alignmentX: HorizontalAlign.CENTER,
      },
      maxWidth: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("right-align text when passing object with alignmentX", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: {
        text: "This is only a test.",
        alignmentX: HorizontalAlign.RIGHT,
      },
      maxWidth: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("middle-align text when passing object with alignmentY", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: {
        text: "This is only a test.",
        alignmentY: VerticalAlign.MIDDLE,
      },
      maxWidth: 100,
      maxHeight: 240,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("middle-align text when passing object with alignmentY can offset y", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      y: 50,
      text: {
        text: "This is only a test.",
        alignmentY: VerticalAlign.MIDDLE,
      },
      maxWidth: 100,
      maxHeight: 240,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("bottom-align text when passing object with alignmentY", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      text: {
        text: "This is only a test.",
        alignmentY: VerticalAlign.BOTTOM,
      },
      maxWidth: 100,
      maxHeight: 240,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("bottom-align text when passing object with alignmentY offset y", async () => {
    const textImage = await createTextImage(320, 240, fonts.SANS_16_BLACK, {
      y: 100,
      text: {
        text: "This is only a test.",
        alignmentY: VerticalAlign.BOTTOM,
      },
      maxWidth: 100,
      maxHeight: 100,
    });

    expect(textImage).toMatchImageSnapshot();
  });

  test("exposes print y position in cb", async () => {
    const loadedFont = await loadFont(fonts.SANS_16_BLACK);
    const image = new Jimp({ width: 500, height: 500, color: 0xffffffff });

    image.print({
      font: loadedFont,
      x: 0,
      y: 0,
      text: "One two three four fix six seven eight nine ten eleven twelve",
      maxWidth: 250,
      cb: ({ x, y }) => {
        image.print({
          font: loadedFont,
          x,
          y: y + 50,
          text: "thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty",
          maxWidth: 250,
        });
      },
    });

    const output = await image.getBuffer("image/png");
    expect(output).toMatchImageSnapshot();
  });

  test("measureText is consistent with measureTextWidth", async () => {
    const font = await loadFont(fonts.SANS_16_BLACK);

    const text = "n n n";
    const width = measureText(font, text);
    const height = measureTextHeight(font, text, width);
    const lineHeight = measureTextHeight(font, text, Infinity);

    expect(height).toEqual(lineHeight);
  });

  test("text with newlines, default alignment", async () => {
    const textImage = await createTextImage(100, 240, fonts.SANS_16_BLACK, {
      text: "This \nis only \na \ntest.",
      maxWidth: 300,
    });

    expect(textImage).toMatchImageSnapshot();
  });
});
