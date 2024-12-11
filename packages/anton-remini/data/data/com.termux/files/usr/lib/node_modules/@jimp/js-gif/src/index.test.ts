import { expect, test, describe } from "vitest";
import { createJimp } from "@jimp/core";
import { getTestImagePath } from "@jimp/test-utils";

import gif from "./index.js";

const jimp = createJimp({ formats: [gif] });

describe("GIF", () => {
  test("load GIF", async () => {
    const image = await jimp.read(getTestImagePath("flower.gif"));
    expect(image.getPixelColor(10, 10)).toBe(0xfefefeff);
  });

  test("load animated GIF", async () => {
    const image = await jimp.read(getTestImagePath("animated.gif"));
    expect(image.getPixelColor(10, 10)).toBe(0xa1d2f1ff);
  });

  test("export GIF", async () => {
    const jgd = await jimp.read(getTestImagePath("flower.gif"));
    const buffer = await jgd.getBuffer("image/gif");
    expect(buffer.toString()).toMatch(/^GIF/);
  });
});
