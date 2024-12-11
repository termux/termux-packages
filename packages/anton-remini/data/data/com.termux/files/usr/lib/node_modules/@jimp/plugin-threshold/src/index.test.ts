import { expect, test, describe } from "vitest";
import "@jimp/test-utils";

import jpeg from "@jimp/js-jpeg";
import { methods as hash } from "@jimp/plugin-hash";
import { createJimp } from "@jimp/core";

import { methods as threshold } from "./index.js";
import { getTestImagePath } from "@jimp/test-utils";

const jimp = createJimp({ formats: [jpeg], plugins: [threshold, hash] });

describe("Threshold", () => {
  test("defines default threshold for lighter backgrounds", async () => {
    const testImage = await jimp.read(getTestImagePath("hands.jpg"));
    const expectedImage = await jimp.read(
      getTestImagePath("hands_mx200_rp255.jpg"),
    );
    const output = testImage.threshold({ max: 200, replace: 255 }).hash();

    expect(output).toStrictEqual(expectedImage.hash());
  });
});
