import { expect, test, describe } from "vitest";
import { createJimp } from "@jimp/core";
import { makeTestImage } from "@jimp/test-utils";

import { methods as crop } from "./index.js";

const jimp = createJimp({ plugins: [crop], formats: [] });

describe("crop", () => {
  // 6x5 size
  const testImage = makeTestImage(
    "  ◆◆  ",
    " ◆▦▦◆ ",
    "◆▦▦▦▦◆",
    " ◆▦▦◆ ",
    "  ◆◆  ",
  );

  test("full width from top", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 0, y: 0, w: 6, h: 2 }),
    ).toMatchSnapshot();
  });

  test("full width from bottom", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 0, y: 3, w: 6, h: 2 }),
    ).toMatchSnapshot();
  });

  test("full width from middle", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 0, y: 2, w: 6, h: 2 }),
    ).toMatchSnapshot();
  });

  test("full height from left", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 0, y: 0, w: 2, h: 5 }),
    ).toMatchSnapshot();
  });

  test("full height from right", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 4, y: 0, w: 2, h: 5 }),
    ).toMatchSnapshot();
  });

  test("full height from middle", () => {
    expect(
      jimp.fromBitmap(testImage).crop({ x: 2, y: 0, w: 2, h: 5 }),
    ).toMatchSnapshot();
  });
});
