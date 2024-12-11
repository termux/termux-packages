import { expect, test, describe } from "vitest";

import { colorDiff, scan } from "./index.js";
import { JimpClass } from "@jimp/types";

// Convert [0..1] float to a percent value with only one decimal.
const pct = (n: number) => ((n * 1000) << 0) / 10;

describe("colorDiff", () => {
  test("totally opaque (no alpha defined)", () => {
    expect(colorDiff({ r: 255, g: 0, b: 0 }, { r: 255, g: 0, b: 0 })).toEqual(
      0
    );

    expect(
      pct(colorDiff({ r: 255, g: 0, b: 0 }, { r: 0, g: 0, b: 0 }))
    ).toEqual(33.3);

    expect(
      pct(colorDiff({ r: 255, g: 0, b: 0 }, { r: 0, g: 255, b: 0 }))
    ).toEqual(66.6);

    expect(colorDiff({ r: 255, g: 0, b: 0 }, { r: 0, g: 255, b: 255 })).toEqual(
      1
    );

    expect(colorDiff({ r: 0, g: 0, b: 0 }, { r: 255, g: 255, b: 255 })).toEqual(
      1
    );
  });

  test("totally transparent", () => {
    expect(
      colorDiff({ r: 255, g: 0, b: 0, a: 0 }, { r: 255, g: 0, b: 0, a: 0 })
    ).toEqual(0);

    expect(
      colorDiff({ r: 0, g: 0, b: 0, a: 0 }, { r: 255, g: 255, b: 255, a: 0 })
    ).toEqual(1);
  });

  test("different alpha", () => {
    expect(
      pct(
        colorDiff(
          { r: 255, g: 0, b: 0, a: 100 },
          { r: 255, g: 0, b: 0, a: 150 }
        )
      )
    ).toEqual(3.8);

    expect(
      colorDiff({ r: 0, g: 0, b: 0, a: 0 }, { r: 255, g: 255, b: 255, a: 255 })
    ).toEqual(1);
  });
});

describe("scan", () => {
  class TestImage {
    public bitmap = {
      height: 3,
      width: 3,
      data: Buffer.from([
        0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
        0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
      ]),
    };
  }

  const img = new TestImage() as JimpClass;

  test("scan", () => {
    let count = 0;

    scan(img, function (_, __, idx) {
      count++;
      expect(img.bitmap.data[idx]).toBe(this.bitmap.data[idx]);
    });

    expect(count).toBe(img.bitmap.width * img.bitmap.height);
  });
});
