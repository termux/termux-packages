import { expect, test, describe } from "vitest";
import { makeTestImage } from "@jimp/test-utils";
import png from "@jimp/js-png";
import jpeg from "@jimp/js-jpeg";
import { Edge } from "@jimp/types";
import { createJimp } from "@jimp/core";

import { methods } from "./index.js";

const jimp = createJimp({ formats: [png, jpeg], plugins: [methods] });

describe("Convolution", function () {
  const imgMid = jimp.fromBitmap(
    makeTestImage(
      "22222222",
      "22222222",
      "22888822",
      "22888822",
      "22888822",
      "22888822",
      "22222222",
      "22222222",
    ),
  );
  /** stores the Jimp instances of the JGD images above. */
  const imgTopLeft = jimp.fromBitmap(
    makeTestImage(
      "88222222",
      "88222222",
      "22222222",
      "22222222",
      "22222222",
      "22222222",
      "22222222",
      "22222222",
    ),
  );

  const sharpM = [
    [-1, -1, 0],
    [-1, 1, 1],
    [0, 1, 1],
  ];

  test("3x3 sharp matrix on EDGE_EXTEND", () => {
    expect(imgMid.clone().convolution(sharpM)).toMatchSnapshot();
    expect(imgTopLeft.clone().convolution(sharpM)).toMatchSnapshot();
  });

  test("3x3 sharp matrix on EDGE_WRAP", () => {
    expect(
      imgMid.clone().convolution({ kernel: sharpM, edgeHandling: Edge.WRAP }),
    ).toMatchSnapshot();
    expect(
      imgTopLeft
        .clone()
        .convolution({ kernel: sharpM, edgeHandling: Edge.WRAP }),
    ).toMatchSnapshot();
  });

  test("3x3 sharp matrix on EDGE_CROP", () => {
    expect(
      imgMid.clone().convolution({ kernel: sharpM, edgeHandling: Edge.CROP }),
    ).toMatchSnapshot();
    expect(
      imgTopLeft
        .clone()
        .convolution({ kernel: sharpM, edgeHandling: Edge.CROP }),
    ).toMatchSnapshot();
  });
});
