import { expect, test, describe } from "vitest";

import { makeDonutTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { methods as color } from "./index.js";

const jimp = createJimp({ plugins: [color] });

describe("canvas color transformation", () => {
  const redDonutJGD = makeDonutTestImage(0x00000000, 0xff000088, 0xff0000ff);

  test("can apply more than one color transformation", () => {
    const image = jimp.fromBitmap(redDonutJGD);
    const newJGD = image.color([
      { apply: "hue", params: [-180] },
      { apply: "lighten", params: [25] },
    ]);

    expect(newJGD.bitmap).toMatchSnapshot();
  });

  test("lighten", () => {
    const image = jimp.fromBitmap(redDonutJGD);
    expect(image.color([{ apply: "lighten", params: [25] }])).toMatchSnapshot();
  });

  test("brighten", () => {
    const image = jimp.fromBitmap(redDonutJGD);
    expect(
      image.color([{ apply: "brighten", params: [25] }]),
    ).toMatchSnapshot();
  });

  test("spin hue", () => {
    const image = jimp.fromBitmap(redDonutJGD);
    expect(image.color([{ apply: "hue", params: [150] }])).toMatchSnapshot();
  });
});

describe("brightness", () => {
  test("brightness of 1 should be the same as no change", () => {
    const jgd = makeDonutTestImage(0xff000088, 0xff000088, 0xff000088);
    const image = jimp.fromBitmap(jgd);
    const image2 = jimp.fromBitmap(jgd);

    expect(image.brightness(1).bitmap).toStrictEqual(image2.bitmap);
  });

  test("should be able to brighten", () => {
    const jgd = makeDonutTestImage(0xaa000088, 0xaa000088, 0xaa000088);
    const image = jimp.fromBitmap(jgd);

    expect(image.brightness(2).bitmap).toMatchSnapshot();
  });

  test("should be able to darken", () => {
    const jgd = makeDonutTestImage(0xaa000088, 0xaa000088, 0xaa000088);
    const image = jimp.fromBitmap(jgd);

    expect(image.brightness(0.2).bitmap).toMatchSnapshot();
  });
});
