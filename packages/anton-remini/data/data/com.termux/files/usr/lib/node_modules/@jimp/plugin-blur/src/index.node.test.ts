import { describe, expect, test } from "vitest";
import { createJimp } from "@jimp/core";
import { getTestImagePath } from "@jimp/test-utils";
import "@jimp/test-utils/image-snapshot";
import png from "@jimp/js-png";

import * as blur from "./index.js";

const Jimp = createJimp({ formats: [png], plugins: [blur.methods] });

describe("hasAlpha", () => {
  test("image with alpha", async () => {
    const image = await Jimp.read(getTestImagePath("dice.png"));
    const output = await image.blur(16).getBuffer("image/png");
    expect(output).toMatchImageSnapshot();
  });
});
