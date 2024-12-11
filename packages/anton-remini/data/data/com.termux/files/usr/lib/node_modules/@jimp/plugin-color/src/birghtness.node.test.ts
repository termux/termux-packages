import { expect, test, describe } from "vitest";
import png from "@jimp/js-png";
import jpeg from "@jimp/js-jpeg";
import { createJimp } from "@jimp/core";
import "@jimp/test-utils/image-snapshot";

import { methods } from "./index.js";

const jimp = createJimp({ formats: [png, jpeg], plugins: [methods] });

describe("Brightness", function () {
  test("3x3 box blur matrix using convolute", async () => {
    const image = await jimp.read(__dirname + "/images/tiles.jpg");
    const output = await image.brightness(2).getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });
});
