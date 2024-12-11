import { describe, expect, test } from "vitest";
import { createJimp } from "@jimp/core";
import { makeTestImage } from "@jimp/test-utils";

import { methods } from "./index.js";

const jimp = createJimp({ plugins: [methods] });

describe("Flipping plugin", () => {
  test("can flip horizontally", () => {
    const src = jimp.fromBitmap(
      makeTestImage(
        "AAAABBBB",
        "AAABAAAB",
        "ABABABAB",
        "CCCCCCCC",
        "CCCCCCCC",
        "CCCCCCCC",
        "AACCCCAA",
      ),
    );

    expect(src.flip({ horizontal: true })).toMatchSnapshot();
  });

  test("can flip vertically", () => {
    const src = jimp.fromBitmap(
      makeTestImage(
        "AAAABBBB",
        "AAABAAAB",
        "ABABABAB",
        "CCCCCCCC",
        "CCCCCCCC",
        "CCCCCCCC",
        "AACCCCAA",
      ),
    );

    expect(src.flip({ vertical: true })).toMatchSnapshot();
  });

  test("can flip both horizontally and vertically at once", async () => {
    const src = jimp.fromBitmap(
      makeTestImage(
        "AAAABBBB",
        "AAABAAAB",
        "ABABABAB",
        "CCCCCCCC",
        "CCCCCCCC",
        "CCCCCCCC",
        "AACCCCAA",
      ),
    );

    expect(src.flip({ horizontal: true, vertical: true })).toMatchSnapshot();
  });
});
