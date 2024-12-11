import { expect, test, describe } from "vitest";
import "@jimp/test-utils";
import "@jimp/test-utils/image-snapshot";

import png from "@jimp/js-png";
import { createJimp } from "@jimp/core";

import { methods as quantize } from "./index.js";

const jimp = createJimp({ formats: [png], plugins: [quantize] });

describe("Quantize", () => {
  test("defines default threshold for lighter backgrounds", async () => {
    const testImage = await jimp.read(__dirname + "/images/colorful.png");
    const output = await testImage
      .quantize({
        colors: 8,
      })
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });
});
