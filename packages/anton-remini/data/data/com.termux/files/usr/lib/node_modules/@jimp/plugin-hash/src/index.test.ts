import { expect, test, describe } from "vitest";
import { getTestImagePath } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";
import bmp from "@jimp/js-bmp";
import png from "@jimp/js-png";
import jpeg from "@jimp/js-jpeg";
import tiff from "@jimp/js-tiff";

import { methods, compareHashes, distance } from "./index.js";

const Jimp = createJimp({
  formats: [bmp, png, jpeg, tiff],
  plugins: [methods],
});

describe("hash", () => {
  test("base 2", async () => {
    const image = await Jimp.read(getTestImagePath("dice.png"));

    expect(image.hash(2)).toBe(
      "1100010000011111011010111110000000010101001011010101101000010010",
    );
  });

  test("base 10 (decimal)", async () => {
    const image = await Jimp.read(getTestImagePath("cops.jpg"));

    expect(image.hash(10)).toBe("13442314021806033441");
  });

  test("base 16 (hex)", async () => {
    const image = await Jimp.read(getTestImagePath("rgb.tiff"));

    expect(image.hash(16)).toBe("949800481007044c");
  });

  test("base 64", async () => {
    const image = await Jimp.read(getTestImagePath("windows95.bmp"));

    expect(image.hash(64)).toBe("fb0xj0Mw400");
  });

  test("base 23", async function () {
    const image = await Jimp.read(getTestImagePath("panoramic.jpg"));

    expect(image.hash(23)).toBe("0m1m2id7l7cl4fb");
  });

  test("base 17", async () => {
    const image = await Jimp.read(getTestImagePath("dice.png"));

    expect(image.hash(17)).toBe("4ffe16bf68eee351");
  });
});

describe("pHash", () => {
  test("should calculate the distance using distanceFromHash", async function () {
    const image1 = await Jimp.read(getTestImagePath("dice.png"));
    const image2 = await Jimp.read(getTestImagePath("mask.png"));

    const hash = image1.pHash();

    expect(image2.distanceFromHash(hash)).toBe(distance(image1, image2));
  });

  test("should calculate the distance using compareHashes.", async function () {
    const image1 = await Jimp.read(getTestImagePath("dice.png"));
    const image2 = await Jimp.read(getTestImagePath("mask.png"));

    const hash1 = image1.pHash();
    const hash2 = image2.pHash();

    expect(compareHashes(hash1, hash2)).toBe(distance(image1, image2));
  });
});
