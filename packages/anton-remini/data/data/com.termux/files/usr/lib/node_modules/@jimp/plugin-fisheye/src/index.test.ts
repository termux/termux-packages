import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { methods } from "./index.js";

const Jimp = createJimp({ plugins: [methods] });

describe("Fisheye", () => {
  test("should create fisheye lens to image", () => {
    const img = Jimp.fromBitmap(
      makeTestImage(
        "0000000000",
        "0001221000",
        "0022222200",
        "0122112210",
        "0221001220",
        "0221001220",
        "0122112210",
        "0022222200",
        "0001221000",
        "0000000000",
      ),
    );

    expect(img.fisheye()).toMatchSnapshot();
  });

  test("should create fisheye lens to image with radius", async () => {
    const imgNormal = Jimp.fromBitmap(
      makeTestImage(
        "0000000000",
        "0000000000",
        "0000000000",
        "0000000000",
        "0001111000",
        "0001111000",
        "0000000000",
        "0000000000",
        "0000000000",
        "0000000000",
      ),
    );

    expect(imgNormal.fisheye({ radius: 1.8 })).toMatchSnapshot();
  });
});
