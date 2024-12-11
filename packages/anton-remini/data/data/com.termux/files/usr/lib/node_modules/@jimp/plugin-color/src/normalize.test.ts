import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";

import { methods } from "./index.js";
import { createJimp } from "@jimp/core";

const jimp = createJimp({ plugins: [methods] });

describe("Normalize", () => {
  test("change grayscale image", () => {
    const image = jimp.fromBitmap(makeTestImage("36▦", "6▦9", "▦9C"));
    expect(image.normalize()).toMatchSnapshot();
  });

  test("change red/blue image", () => {
    const image = jimp.fromBitmap({
      width: 3,
      height: 2,
      data: [
        0x000000ff, 0x400022ff, 0x40002200, 0x400000ff, 0x000022ff, 0x800055ff,
      ],
    });

    expect(image.normalize()).toMatchSnapshot();
  });
});
