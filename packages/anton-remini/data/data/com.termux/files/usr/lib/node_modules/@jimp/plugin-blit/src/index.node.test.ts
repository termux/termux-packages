import { expect, test, describe } from "vitest";
import { createJimp } from "@jimp/core";
import jpeg from "@jimp/js-jpeg";
import png from "@jimp/js-png";
import "@jimp/test-utils/image-snapshot";
import { getTestImagePath } from "@jimp/test-utils";

import * as blit from "./index.js";

const Jimp = createJimp({ formats: [jpeg, png], plugins: [blit.methods] });

describe("Blit over image", function () {
  test("blit alpha", async () => {
    const dice = await Jimp.read(getTestImagePath("dice.png"));
    const image = await Jimp.read(getTestImagePath("cops.jpg"));
    const output = await image.blit({ src: dice }).getBuffer("image/png");

    expect(output).toMatchImageSnapshot();
  });

  async function createCat(catNum: number, len: number) {
    const imgHeight = 60;

    const butt = await Jimp.read(__dirname + "/images/cat_butt.png");
    const head = await Jimp.read(__dirname + "/images/cat_head.png");
    const fuzz = await Jimp.read(__dirname + "/images/cat_fuzz.png");

    let longCat = len;
    longCat = longCat > 20 ? 20 : longCat;
    longCat = longCat <= 1 ? 1 : longCat;

    const cat =
      Math.floor(catNum * (head.bitmap.height / imgHeight)) * imgHeight;

    const newImage = new Jimp({
      width:
        butt.bitmap.width + head.bitmap.width + fuzz.bitmap.width * longCat,
      height: imgHeight,
      color: 0x00000000,
    });

    newImage.blit({
      src: butt,
      x: 0,
      y: 0,
      srcX: 0,
      srcY: cat,
      srcW: butt.bitmap.width,
      srcH: imgHeight,
    });
    for (let i = 0; i < longCat; i++) {
      newImage.blit({
        src: fuzz,
        x: butt.bitmap.width + fuzz.bitmap.width * i,
        y: 0,
        srcX: 0,
        srcY: cat,
        srcW: fuzz.bitmap.width,
        srcH: imgHeight,
      });
    }

    newImage.blit({
      src: head,
      x: butt.bitmap.width + fuzz.bitmap.width * longCat,
      y: 0,
      srcX: 0,
      srcY: cat,
      srcW: head.bitmap.width,
      srcH: imgHeight,
    });

    return newImage;
  }

  test("uses src params correctly", async () => {
    const small = await createCat(0.3, 1);
    expect(await small.getBuffer("image/png")).toMatchImageSnapshot();

    const medium = await createCat(0.6, 7);
    expect(await medium.getBuffer("image/png")).toMatchImageSnapshot();

    const large = await createCat(0.9, 20);
    expect(await large.getBuffer("image/png")).toMatchImageSnapshot();
  });
});
