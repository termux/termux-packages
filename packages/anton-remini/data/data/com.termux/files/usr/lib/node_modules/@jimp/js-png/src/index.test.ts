import { expect, test, describe } from "vitest";
import { createJimp } from "@jimp/core";

import png from "./index.js";
import { getTestImagePath } from "@jimp/test-utils";

const jimp = createJimp({ formats: [png] });

describe("PNG", () => {
  test("load PNG", async () => {
    const image = await jimp.read(getTestImagePath("dice.png"));
    expect(image.getPixelColor(10, 10)).toBe(0x00000000);
    expect(image.getPixelColor(160, 80)).toBe(0x1c1cd4ff);
    expect(image.getPixelColor(400, 250)).toBe(0x7e0c0cda);
  });

  test("export PNG", async () => {
    const testImage = jimp.fromBitmap({
      width: 3,
      height: 3,
      data: [
        0xff0000ff, 0xff0080ff, 0xff00ffff, 0xff0080ff, 0xff00ffff, 0x8000ffff,
        0xff00ffff, 0x8000ffff, 0x0000ffff,
      ],
    });
    const buffer = await testImage.getBuffer("image/png");
    expect(buffer.toString()).toMatch(/^.PNG\r\n/);
  });
});
