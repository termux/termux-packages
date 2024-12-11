import { expect, test, describe } from "vitest";
import "@jimp/test-utils/image-snapshot";
import { createJimp } from "@jimp/core";

import png from "./index.js";

const jimp = createJimp({ formats: [png] });

describe("PNG", () => {
  test("should use png options", async () => {
    const testImage = jimp.fromBitmap({
      width: 20,
      height: 20,
      data: [
        0xff0000ff, 0xff0080ff, 0xff00ffff, 0xff0080ff, 0xff00ffff, 0x8000ffff,
        0xff00ffff, 0x8000ffff, 0x0000ffff, 0xff0000ff, 0xff0080ff, 0xff00ffff,
        0xff0080ff, 0xff00ffff, 0x8000ffff, 0xff00ffff, 0x8000ffff, 0x0000ffff,
        0xff0000ff, 0xff0080ff, 0xff00ffff, 0xff0080ff, 0xff00ffff, 0x8000ffff,
        0xff00ffff, 0x8000ffff, 0x0000ffff, 0xff0000ff, 0xff0080ff, 0xff00ffff,
        0xff0080ff, 0xff00ffff, 0x8000ffff, 0xff00ffff, 0x8000ffff, 0x0000ffff,
      ],
    });
    const image = await testImage.getBuffer("image/png", {
      deflateStrategy: 0,
      colorType: 0,
    });
    expect(image).toMatchImageSnapshot();
  });
});
