import { expect, test, describe } from "vitest";

import { makeTestImage } from "@jimp/test-utils";
import { createJimp } from "@jimp/core";

import { methods, ResizeStrategy } from "./index.js";

const jimp = createJimp({ plugins: [methods], formats: [] });

describe("Resize images", () => {
  const testImages = [
    {
      title: "max contrast 8x8",
      src: jimp.fromBitmap(
        makeTestImage(
          "■■■■□□□□",
          "■■■■□□□□",
          "■■■■□□□□",
          "■■■■□□□□",
          "□□□□■■■■",
          "□□□□■■■■",
          "□□□□■■■■",
          "□□□□■■■■"
        )
      ),
      tests: [
        { mode: "default", size: { height: 4, width: 4 } },
        { mode: "NEAREST_NEIGHBOR", size: { height: 4, width: 4 } },
        { mode: "BILINEAR", size: { height: 4, width: 4 } },
        { mode: "BICUBIC", size: { height: 4, width: 4 } },
        { mode: "HERMITE", size: { height: 4, width: 4 } },
        { mode: "BEZIER", size: { height: 4, width: 4 } },
        { mode: "default", size: { height: 5, width: 2 } },
        { mode: "NEAREST_NEIGHBOR", size: { height: 5, width: 2 } },
        { mode: "BILINEAR", size: { height: 5, width: 2 } },
        { mode: "BICUBIC", size: { height: 5, width: 2 } },
        { mode: "HERMITE", size: { height: 5, width: 2 } },
        { mode: "BEZIER", size: { height: 5, width: 2 } },
      ],
    },
    /**********************************************************************/
    {
      title: "max contrast 12x12 with dots",
      src: jimp.fromBitmap(
        makeTestImage(
          "■■■■■■□□□□□□",
          "■■■■■■□□□□□□",
          "■■■□■■□□■□□□",
          "■■■■■■□□□□□□",
          "■■■■■■□□□□□□",
          "■■■■■■□□□□□□",
          "□□□□□□■■■■■■",
          "□□□□□□■■■■■■",
          "□□□□□□■■■■■■",
          "□□□■□□■■□■■■",
          "□□□□□□■■■■■■",
          "□□□□□□■■■■■■"
        )
      ),
      tests: [
        { mode: "default", size: { height: 6, width: 6 } },
        { mode: "NEAREST_NEIGHBOR", size: { height: 6, width: 6 } },
        { mode: "BILINEAR", size: { height: 6, width: 6 } },
        { mode: "BICUBIC", size: { height: 6, width: 6 } },
        { mode: "HERMITE", size: { height: 6, width: 6 } },
        { mode: "BEZIER", size: { height: 6, width: 6 } },
      ],
    },
    /**********************************************************************/
    {
      title: "mutch contrast 4x4",
      src: jimp.fromBitmap(makeTestImage("▩▩▥▥", "▩▩▥▥", "▥▥▩▩", "▥▥▩▩")),
      tests: [
        { mode: "default", size: { height: 6, width: 6 } },
        { mode: "NEAREST_NEIGHBOR", size: { height: 6, width: 6 } },
        { mode: "BILINEAR", size: { height: 6, width: 6 } },
        { mode: "BICUBIC", size: { height: 6, width: 6 } },
        { mode: "HERMITE", size: { height: 6, width: 6 } },
        { mode: "BEZIER", size: { height: 6, width: 6 } },
      ],
    },
  ];

  testImages.forEach((image) => {
    describe(image.title, () => {
      image.tests.forEach(({ mode: modeType, size }) => {
        test(`to ${modeType} ${size.width}x${size.height}`, () => {
          const mode = ResizeStrategy[modeType as keyof typeof ResizeStrategy];

          expect(
            image.src.clone().resize({
              w: size.width,
              h: size.height,
              mode,
            })
          ).toMatchSnapshot();
        });
      });
    });
  });
});
