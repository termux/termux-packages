import { expect, test, describe } from "vitest";
import png from "@jimp/js-png";
import jpeg from "@jimp/js-jpeg";
import { createJimp } from "@jimp/core";
import "@jimp/test-utils/image-snapshot";

import { methods } from "./index.js";

const jimp = createJimp({ formats: [png, jpeg], plugins: [methods] });

describe("Convolution", function () {
  const blurM = [
    [1 / 9, 1 / 9, 1 / 9],
    [1 / 9, 1 / 9, 1 / 9],
    [1 / 9, 1 / 9, 1 / 9],
  ];

  test("3x3 box blur matrix using convolute", async () => {
    const image = await jimp.read(__dirname + "/images/tiles.jpg");
    const output = await image.convolute(blurM).getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  test("new pixel value is greater than 255", async () => {
    const image = await jimp.read(__dirname + "/images/qr.jpg");

    const convolutionMatrix = [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 1, 0, 1, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
    ];

    const output = await image
      .convolution(convolutionMatrix)
      .getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });
});
