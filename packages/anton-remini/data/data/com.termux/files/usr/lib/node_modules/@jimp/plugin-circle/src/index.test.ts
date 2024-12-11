import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { methods } from "./index.js";

const Jimp = createJimp({ plugins: [methods] });

describe("Circle", () => {
  test("makes a circle based on image height and width", () => {
    const imgSrc = Jimp.fromBitmap(
      makeTestImage(
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
      ),
    );

    expect(imgSrc.circle()).toMatchSnapshot();
  });

  test("makes a circle using provided radius", () => {
    const imgSrc = Jimp.fromBitmap(
      makeTestImage(
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
      ),
    );

    expect(imgSrc.circle({ radius: 3 })).toMatchSnapshot();
  });

  test("should ", () => {
    const imgSrc = Jimp.fromBitmap(
      makeTestImage(
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
        "▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦▦",
      ),
    );

    expect(imgSrc.circle({ radius: 5, x: 5, y: 5 })).toMatchSnapshot();
  });
});
