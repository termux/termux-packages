import { expect, test, describe } from "vitest";

import { methods } from "./index.js";
import { createJimp } from "@jimp/core";
import { makeTestImage } from "@jimp/test-utils";

const jimp = createJimp({ plugins: [methods] });

describe("Autocrop", () => {
  test("image with transparent surround color", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "          ",
        "    ◆◆    ",
        "   ◆▦▦◆   ",
        "  ◆▦▦▦▦◆  ",
        "   ◆▦▦◆   ",
        "    ◆◆    ",
        "          ",
      ),
    );

    expect(imgSrc.autocrop()).toMatchSnapshot();
  });

  test("image with opaque surround color", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥◆◆▥▥▥▥",
        "▥▥▥◆▦▦◆▥▥▥",
        "▥▥◆▦▦▦▦◆▥▥",
        "▥▥▥◆▦▦◆▥▥▥",
        "▥▥▥▥◆◆▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥",
      ),
    );

    expect(imgSrc.autocrop()).toMatchSnapshot();
  });

  test("image with one color border", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥   ◆◆   ▥▥",
        "▥▥  ◆▦▦◆  ▥▥",
        "▥▥ ◆▦▦▦▦◆ ▥▥",
        "▥▥  ◆▦▦◆  ▥▥",
        "▥▥   ◆◆   ▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥",
      ),
    );

    expect(imgSrc.autocrop()).toMatchSnapshot();
  });

  test("image border with small variation", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "323232323232",
        "232323232323",
        "32   ◆◆   32",
        "23  ◆▦▦◆  23",
        "32 ◆▦▦▦▦◆ 32",
        "23  ◆▦▦◆  23",
        "32   ◆◆   32",
        "232323232323",
        "323232323232",
      ),
    );
    expect(imgSrc.clone().autocrop()).toMatchSnapshot();
    expect(imgSrc.clone().autocrop(0.005)).toMatchSnapshot();
  });

  test("image border with small variation configured by options", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "323232323232",
        "232323232323",
        "32   ◆◆   32",
        "23  ◆▦▦◆  23",
        "32 ◆▦▦▦▦◆ 32",
        "23  ◆▦▦◆  23",
        "32   ◆◆   32",
        "232323232323",
        "323232323232",
      ),
    );
    expect(imgSrc.clone().autocrop()).toMatchSnapshot();
    expect(imgSrc.clone().autocrop({ tolerance: 0.005 })).toMatchSnapshot();
  });

  test("image without frame", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥   ◆◆   ",
        "▥▥  ◆▦▦◆  ",
        "▥▥ ◆▦▦▦▦◆ ",
        "▥▥  ◆▦▦◆  ",
        "▥▥   ◆◆   ",
        "▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥",
      ),
    );

    expect(imgSrc.autocrop({ cropOnlyFrames: false })).toMatchSnapshot();
  });

  test("image without frame configured by options", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥   ◆◆   ",
        "▥▥  ◆▦▦◆  ",
        "▥▥ ◆▦▦▦▦◆ ",
        "▥▥  ◆▦▦◆  ",
        "▥▥   ◆◆   ",
        "▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥",
      ),
    );

    expect(imgSrc.autocrop({ cropOnlyFrames: false })).toMatchSnapshot();
  });

  test("image with symmetric border configured by options", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥   ◆◆   ▥▥▥▥",
        "▥▥  ◆▦▦◆  ▥▥▥▥",
        "▥▥ ◆▦▦▦▦◆ ▥▥▥▥",
        "▥▥  ◆▦▦◆  ▥▥▥▥",
        "▥▥   ◆◆   ▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥▥▥",
      ),
    );

    expect(imgSrc.autocrop({ cropSymmetric: true })).toMatchSnapshot();
  });

  test("image without frame and with symmetric border configured by options", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥   ◆◆   ▥▥▥▥",
        "▥▥  ◆▦▦◆  ▥▥▥▥",
        "▥▥ ◆▦▦▦▦◆ ▥▥▥▥",
        "▥▥  ◆▦▦◆  ▥▥▥▥",
        "▥▥   ◆◆   ▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥▥▥▥▥▥▥",
      ),
    );
    expect(
      imgSrc.autocrop({ cropSymmetric: true, cropOnlyFrames: false }),
    ).toMatchSnapshot();
  });

  test("image without frame and with some border left", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "323232323232",
        "232323232323",
        "32   ◆◆   32",
        "23  ◆▦▦◆  23",
        "32 ◆▦▦▦▦◆ 32",
        "23  ◆▦▦◆  23",
        "32   ◆◆   32",
        "232323232323",
        "323232323232",
      ),
    );

    expect(
      imgSrc.autocrop({
        tolerance: 0.005,
        leaveBorder: 1,
      }),
    ).toMatchSnapshot();
  });

  test('image not cropped given an out of bounds "leaveBorder" value ', async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "323232323232",
        "232323232323",
        "32   ◆◆   32",
        "23  ◆▦▦◆  23",
        "32 ◆▦▦▦▦◆ 32",
        "23  ◆▦▦◆  23",
        "32   ◆◆   32",
        "232323232323",
        "323232323232",
      ),
    );
    expect(
      imgSrc.autocrop({
        tolerance: 0.005,
        leaveBorder: 100,
      }),
    ).toMatchSnapshot();
  });

  test("image with top and bottom frame and leaveBorder", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥",
        "   ◆◆   ",
        "  ◆▦▦◆  ",
        " ◆▦▦▦▦◆ ",
        "  ◆▦▦◆  ",
        "   ◆◆   ",
        "▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥",
        "▥▥▥▥▥▥▥▥",
      ),
    );
    expect(
      imgSrc.autocrop({
        cropSymmetric: true,
        cropOnlyFrames: false,
        leaveBorder: 2,
      }),
    ).toMatchSnapshot();
  });

  test("ignore sides north", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "          ",
        "    ◆◆    ",
        "   ◆▦▦◆   ",
        "  ◆▦▦▦▦◆  ",
        "   ◆▦▦◆   ",
        "    ◆◆    ",
        "          ",
      ),
    );
    expect(
      imgSrc.autocrop({ cropOnlyFrames: false, ignoreSides: { north: true } }),
    ).toMatchSnapshot();
  });

  test("ignore sides south and west", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "          ",
        "    ◆◆    ",
        "   ◆▦▦◆   ",
        "  ◆▦▦▦▦◆  ",
        "   ◆▦▦◆   ",
        "    ◆◆    ",
        "          ",
      ),
    );

    expect(
      imgSrc.autocrop({
        cropOnlyFrames: false,
        ignoreSides: { west: true, south: true },
      }),
    ).toMatchSnapshot();
  });

  test("ignore sides east", async () => {
    const imgSrc = jimp.fromBitmap(
      makeTestImage(
        "          ",
        "    ◆◆    ",
        "   ◆▦▦◆   ",
        "  ◆▦▦▦▦◆  ",
        "   ◆▦▦◆   ",
        "    ◆◆    ",
        "          ",
      ),
    );

    expect(
      imgSrc.autocrop({ cropOnlyFrames: false, ignoreSides: { east: true } }),
    ).toMatchSnapshot();
  });
});
