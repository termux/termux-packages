import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { methods } from "./index.js";

const jimp = createJimp({ plugins: [methods] });

describe("Mask", () => {
  const imgSrcOpaq = jimp.fromBitmap(
    // prettier-ignore
    makeTestImage(
      "▴□▾□■□",
      "■▴■▾■□",
      "■□▴□▾□",
      "■□■▴■▾"
    ),
  );
  const imgSrcAlpa = jimp.fromBitmap(
    // prettier-ignore
    makeTestImage(
      "▴▵▾▿",
      "▴▵▾▿",
      "▴▵▾▿"
    ),
  );
  const maskGrayBig = jimp.fromBitmap(
    // prettier-ignore
    makeTestImage(
      "048840",
      "8CFFC8",
      "8CFFC8",
      "048840"
    ),
  );
  const maskGraySmall = jimp.fromBitmap(
    // prettier-ignore
    makeTestImage(
      "0369",
      "369C",
      "69CF"
    ),
  );
  const maskColor = jimp.fromBitmap(
    // prettier-ignore
    makeTestImage(
      "▴▴▾▾",
      "▪▪▰▰",
      "□□□□"
    ),
  );

  test("Affect opaque image with a gray mask with the same size", () => {
    expect(imgSrcOpaq.clone().mask(maskGrayBig)).toMatchSnapshot();
  });

  test("Affect opaque image with a gray mask with the same size, blited", () => {
    expect(
      imgSrcOpaq.clone().mask({ src: maskGrayBig, x: 1, y: 1 }),
    ).toMatchSnapshot();
  });

  test("Affect opaque image with a gray mask with the same size, blited negative", () => {
    expect(
      imgSrcOpaq.clone().mask({ src: maskGrayBig, x: -1, y: -1 }),
    ).toMatchSnapshot();
  });

  test("Affect opaque image with a smaller gray mask", () => {
    expect(imgSrcOpaq.clone().mask(maskGraySmall)).toMatchSnapshot();
  });

  test("Affect opaque image with a smaller gray mask, blited", () => {
    expect(
      imgSrcOpaq.clone().mask({ src: maskGraySmall, x: 1, y: 1 }),
    ).toMatchSnapshot();
  });

  test("Affect alpha image with a bigger gray mask", () => {
    expect(imgSrcAlpa.clone().mask(maskGrayBig)).toMatchSnapshot();
  });

  test("Affect alpha image with a bigger gray mask, blited", () => {
    expect(
      imgSrcAlpa.clone().mask({ src: maskGrayBig, x: -1, y: -1 }),
    ).toMatchSnapshot();
  });

  test("Affect opaque image with a colored mask", () => {
    expect(
      imgSrcOpaq.clone().mask({ src: maskColor, x: 1, y: 1 }),
    ).toMatchSnapshot();
  });
});
