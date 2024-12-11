import { describe, expect, test } from "vitest";
import { createJimp } from "@jimp/core";
import { makeTestImage } from "@jimp/test-utils";

import { methods } from "./index.js";

const jimp = createJimp({ plugins: [methods] });

describe("Rotate a image with even size", () => {
  const imgSrc = jimp.fromBitmap(
    makeTestImage(
      "▰▴▴▴▪▪▪▰",
      "▴▴▴▴▪▪▪▪",
      "▴▴▴▴▪▪▪▪",
      "▴▴▴▴▪▪▪▪",
      "▪▪▪▪▴▴▴▴",
      "▪▪▪▪▴▴▴▴",
      "▪▪▪▪▴▴▴▴",
      "▦▪▪▪▴▴▴▦",
    ),
  );

  const angles = [
    1, 91, 30, 45, 60, 90, -90, 120, 135, 180, 225, 270, 315, 360,
  ];

  angles.forEach((angle) => {
    test(`${angle} degrees`, () => {
      expect(imgSrc.clone().rotate(angle)).toMatchSnapshot();
    });
  });
});

describe("Rotate a image with odd size", () => {
  const imgSrc = jimp.fromBitmap(
    makeTestImage(
      "▴▴▴▦▪▪▪",
      "▴▴▴▦▪▪▪",
      "▴▴▴▦▪▪▪",
      "▦▦▦▦▦▦▦",
      "▴▴▴▦▴▴▴",
      "▴▴▴▦▴▴▴",
      "▴▴▴▦▴▴▴",
    ),
  );

  const angles = [45, 135, 225, 315];

  angles.forEach((angle) => {
    test(`${angle} degrees`, () => {
      expect(imgSrc.clone().rotate(angle)).toMatchSnapshot();
    });
  });
});

describe("Rotate a non-square image", () => {
  const imgSrc = jimp.fromBitmap(
    makeTestImage("▴▴▴▴▪▪▪▪", "▴▴▴▴▪▪▪▪", "▦▦▦▦▴▴▴▴", "▦▦▦▦▴▴▴▴"),
  );

  const angles = [1, 10, 30, 45, 90, -90, 135, 180, 225, 315, -180, -270];

  angles.forEach((angle) => {
    test(`${angle} degrees`, () => {
      expect(imgSrc.clone().rotate(angle)).toMatchSnapshot();
    });
  });
});

describe("Rotate a non-square image without resizing", () => {
  const imgSrc = jimp.fromBitmap(
    makeTestImage("□□□□□□□□", "▹▹▹▹▹▹▹▹", "▿▿▿▿▿▿▿▿", "□□□□□□□□"),
  );

  const angles = [90, 180, 270, 45];

  angles.forEach((angle) => {
    test(`${angle} degrees`, () => {
      expect(
        imgSrc.clone().rotate({ deg: angle, mode: false }),
      ).toMatchSnapshot();
    });
  });
});
