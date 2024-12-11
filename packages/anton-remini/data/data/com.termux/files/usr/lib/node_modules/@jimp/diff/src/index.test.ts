import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { diff } from "./index.js";

const Jimp = createJimp();

describe("Compare image difference", () => {
  const imgs = [
    Jimp.fromBitmap(makeTestImage("2222", "4444", "6666", "8888")),
    Jimp.fromBitmap(makeTestImage("2468", "2468", "2468", "2468")),
    Jimp.fromBitmap(makeTestImage("2212", "4434", "6656", "8878")),
    Jimp.fromBitmap(makeTestImage("2232", "4454", "6676", "8898")),
    Jimp.fromBitmap(makeTestImage("22322", "44544", "66766", "88988")),
  ] as const;

  test("images 0 and 1", () => {
    const result = diff(imgs[0], imgs[1]);

    expect(result.percent).toBe(0.75);
    expect(result.image).toMatchSnapshot();
  });

  test("images 0 and 2", () => {
    const result = diff(imgs[0], imgs[2]);

    expect(result.percent).toBe(0);
    expect(result.image).toMatchSnapshot();
  });

  test("images 0 and 3", () => {
    const result = diff(imgs[0], imgs[3]);

    expect(result.percent).toBe(0);
    expect(result.image).toMatchSnapshot();
  });

  test("allows to set a different threshold", () => {
    expect(diff(imgs[0], imgs[3], 0.1).percent).toBe(0);
    expect(diff(imgs[0], imgs[3], 0).percent).toBe(0.25);
  });

  test("throws an error if threshold is invalid", () => {
    expect(() => diff(imgs[0], imgs[3], -1)).toThrow(
      "threshold must be a number between 0 and 1",
    );
  });

  test("should resize image before diffing", () => {
    expect(diff(imgs[3], imgs[4]).percent).toStrictEqual(
      diff(imgs[4], imgs[3]).percent,
    );
  });
});
