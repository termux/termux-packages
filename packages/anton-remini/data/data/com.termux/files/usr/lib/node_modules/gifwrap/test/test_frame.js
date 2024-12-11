'use strict';

const assert = require('chai').assert;
const Jimp = require('jimp');
const Tools = require('./lib/tools');
const { BitmapImage, Gif, GifFrame, GifError } = require('../src/index');

const SAMPLE_PNG_PATH = Tools.getFixturePath('lenna.png');
const SAMPLE_JPG_PATH = Tools.getFixturePath('pelagrina.jpg');

describe("GifFrame good construction behavior", () => {

    it("constructs an uncolored bitmap", (done) => {

        const f = new GifFrame(10, 5);
        Tools.checkBitmap(f.bitmap, 10, 5, 0);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("initializes options in an uncolored bitmap", (done) => {

        const f = new GifFrame(10, 5, { delayCentisecs: 100 });
        Tools.checkBitmap(f.bitmap, 10, 5, 0);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 100
        });
        done();
    });

    it("constructs an empty colored bitmap", (done) => {

        const color = 0x01020300;
        const f = new GifFrame(10, 5, color);
        Tools.checkBitmap(f.bitmap, 10, 5, color);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("initializes options in a colored bitmap", (done) => {

        const color = 0x010203ff;
        const f = new GifFrame(10, 5, color, { delayCentisecs: 100 });
        Tools.checkBitmap(f.bitmap, 10, 5, color);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 100
        });
        done();
    });

    it("sources from an existing bitmap, sharing", (done) => {

        const color = 0x010203ff;
        const j = new BitmapImage(10, 5, color);
        const f = new GifFrame(j.bitmap);
        assert.strictEqual(f.bitmap, j.bitmap);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("sources from an existing bitmap, sharing, with options", (done) => {

        const color = 0x010203ff;
        const j = new BitmapImage(10, 5, color);
        const f = new GifFrame(j.bitmap, { delayCentisecs: 100 });
        assert.strictEqual(f.bitmap, j.bitmap);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 100
        });
        done();
    });

    it("sources from an existing BitmapImage, copying", (done) => {

        const color = 0x010203ff;
        const j = new BitmapImage(10, 5, color);
        const f = new GifFrame(j);
        assert.notStrictEqual(f.bitmap, j.bitmap);
        assert.deepStrictEqual(f.bitmap, j.bitmap);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("sources from an existing BitmapImage, copying, with options", (done) => {

        const color = 0x010203ff;
        const j = new BitmapImage(10, 5, color);
        const f = new GifFrame(j, { delayCentisecs: 100 });
        assert.notStrictEqual(f.bitmap, j.bitmap);
        assert.deepStrictEqual(f.bitmap, j.bitmap);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 100
        });
        done();
    });

    it("initializes data params without options", (done) => {
        const bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f = new GifFrame(bitmap.width, bitmap.height, bitmap.data);
        assert.strictEqual(f.bitmap.width, bitmap.width);
        assert.strictEqual(f.bitmap.height, bitmap.height);
        assert.strictEqual(f.bitmap.data, bitmap.data);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("initializes data params with options", (done) => {
        const bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f = new GifFrame(bitmap.width, bitmap.height, bitmap.data,
                    { delayCentisecs: 200, interlaced: true });
        assert.strictEqual(f.bitmap.width, bitmap.width);
        assert.strictEqual(f.bitmap.height, bitmap.height);
        assert.strictEqual(f.bitmap.data, bitmap.data);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 200,
            interlaced: true
        });
        done();
    });

    it("initializes bitmap without options", (done) => {
        const bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f = new GifFrame(bitmap);
        assert.strictEqual(f.bitmap, bitmap);
        Tools.checkFrameDefaults(f);
        done();
    });

    it("initializes bitmap with options", (done) => {
        const bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f = new GifFrame(bitmap,
                    { delayCentisecs: 200, interlaced: true });
        assert.strictEqual(f.bitmap, bitmap);
        Tools.checkFrameDefaults(f, {
            delayCentisecs: 200,
            interlaced: true
        });
        done();
    });

    it("clones an existing frame", (done) => {

        const f1 = new GifFrame(5, 5, {
            delayCentisecs: 100,
            isInterlace: true
        });
        f1.bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f2 = new GifFrame(f1);
        Tools.verifyFrameInfo(f2, f1);
        assert.notStrictEqual(f2.bitmap, f1.bitmap);
        assert.deepStrictEqual(f2.bitmap, f1.bitmap);
        done();
    });
});

describe("GifFrame bad construction behavior", () => {

    it("won't accept garbage", (done) => {

        assert.throws(() => {
            new GifFrame();
        }, /requires parameters/);
        assert.throws(() => {
            new GifFrame(null);
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame(null, { interlaced: true });
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame("string");
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame("string", { interlaced: true });
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame(() => {});
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame({});
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame({ interlaced: true });
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame(new Buffer(25));
        }, /unrecognized/);
        done();
    });

    it("width requires height", (done) => {

        assert.throws(() => {
            new GifFrame(5);
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame(5, { interlaced: true });
        }, /unrecognized/);
        assert.throws(() => {
            new GifFrame(5, new Buffer(5));
        }, /unrecognized/);
        done();
    });
});

describe("GifFrame palette", () => {

    it("is monocolor without transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameMonoOpaque');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors, [0xFF0000]);
        assert.strictEqual(p.usesTransparency, false);
        done();
    });

    it("includes two colors without transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameBWOpaque');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors, [0x000000, 0xffffff]);
        assert.strictEqual(p.usesTransparency, false);
        done();
    });

    it("includes multiple colors without transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameMultiOpaque');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors,
                [0x0000ff, 0x00ff00, 0xff0000, 0xffffff]);
        assert.strictEqual(p.usesTransparency, false);
        done();
    });

    it("has only transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameNoColorTrans');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors, []);
        assert.strictEqual(p.usesTransparency, true);
        done();
    });

    it("is monocolor with transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameMonoTrans');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors, [0x00ff00]);
        assert.strictEqual(p.usesTransparency, true);
        done();
    });

    it("includes multiple colors with transparency", (done) => {

        const bitmap = Tools.getBitmap('singleFrameMultiPartialTrans');
        const f = new GifFrame(bitmap);
        const p = f.getPalette();
        assert.deepStrictEqual(p.colors,
                [0x000000, 0x0000ff, 0x00ff00, 0xff0000, 0xffffff]);
        assert.strictEqual(p.usesTransparency, true);
        done();
    });
});

function _assertDefaultFrameOptions(frame) {
    assert.strictEqual(frame.xOffset, 0);
    assert.strictEqual(frame.yOffset, 0);
    assert.strictEqual(frame.disposalMethod, GifFrame.DisposeToBackgroundColor);
    assert.strictEqual(typeof frame.delayCentisecs, 'number');
    assert.strictEqual(frame.interlaced, false);
}
