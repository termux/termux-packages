'use strict';

const assert = require('chai').assert;
const Tools = require('./lib/tools');
const { Gif, GifFrame, GifCodec, GifUtil, GifError } =
        require('../src/index');

describe("single frame decoding", () => {

    it("reads an opaque monocolor file", () => {

        const name = 'singleFrameMonoOpaque';
        const bitmap = Tools.getBitmap(name);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: false
            });
        });
    });

    it("reads an opaque multi-color file", () => {

        const name = 'singleFrameMultiOpaque';
        const bitmap = Tools.getBitmap(name);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: false
            });
        });
    });

    it("reads a purely transparent file", () => {

        const name = 'singleFrameNoColorTrans';
        const bitmap = Tools.getBitmap(name, 0);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: true
            });
        });
    });

    it("reads a monochrome file with transparency", () => {

        const name = 'singleFrameMonoTrans';
        const bitmap = Tools.getBitmap(name, 0);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: true
            });
        });
    });

    it("reads a multicolor file with transparency", () => {

        const name = 'singleFrameMultiTrans';
        const bitmap = Tools.getBitmap(name, 0);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: true
            });
        });
    });

    it("reads a multicolor file with custom transparency color", () => {

        const transRGB = 0x123456;
        const name = 'singleFrameMultiTrans';
        const bitmap = Tools.getBitmap(name, transRGB);
        const decoder = new GifCodec({ transparentRGB: transRGB });
        return GifUtil.read(Tools.getGifPath(name), decoder)
        .then(gif => {

            _compareGifToSeries(gif, [bitmap], {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: true
            });
        });
    });
});

describe("multiframe decoding", () => {

    it("reads a 2-frame multicolor file without transparency", () => {

        const name = 'twoFrameMultiOpaque';
        const series = Tools.getSeries(name);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, series, {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: false,
                delayCentisecs: 50
            });
        });
    });

    it("reads a 3-frame monocolor file with transparency", () => {

        const name = 'threeFrameMonoTrans';
        const series = Tools.getSeries(name);
        return GifUtil.read(Tools.getGifPath(name))
        .then(gif => {

            _compareGifToSeries(gif, series, {
                disposalMethod: GifFrame.DisposeToBackgroundColor,
                usesTransparency: true,
                delayCentisecs: 25
            });
        });
    });

    it("reads a large multiframe file w/out transparency", () => {

        return GifUtil.read(Tools.getGifPath('nburling-public'))
        .then(gif => {
        
            assert.strictEqual(gif.width, 238);
            assert.strictEqual(gif.height, 372);
            assert.strictEqual(gif.loops, 0);
            assert.strictEqual(gif.usesTransparency, false);
            assert(Array.isArray(gif.frames));
            assert.strictEqual(gif.frames.length, 24);
            for (let i = 0; i < gif.frames.length; ++i) {
                const frame = gif.frames[i];
                assert.strictEqual(frame.bitmap.width, gif.width);
                assert.strictEqual(frame.bitmap.height, gif.height);
                Tools.checkFrameDefaults(frame, {
                    xOffset: 0,
                    yOffset: 0,
                    disposalMethod: GifFrame.DisposeNothing,
                    delayCentisecs: 20
                }, i);
            }
            assert(Buffer.isBuffer(gif.buffer)); 
        });
    });

    it("reads a large multiframe file w/ offsets, w/out transparency", () => {

        return GifUtil.read(Tools.getGifPath('rnaples-offsets-public'))
        .then(gif => {

            assert.strictEqual(gif.width, 480);
            assert.strictEqual(gif.height, 693);
            assert.strictEqual(gif.loops, 0);
            assert.strictEqual(gif.usesTransparency, true);
            const frameDump = [ // generated via Tools.dumpFramesAsCode()
                [0, 0, 480, 693, 10, false, 1],
                [208, 405, 130, 111, 10, false, 1],
                [85, 0, 395, 516, 10, false, 1],
                [85, 0, 395, 309, 10, false, 1],
                [85, 0, 395, 309, 10, false, 1],
                [85, 0, 395, 309, 10, false, 1],
                [208, 0, 272, 516, 10, false, 1],
                [85, 0, 375, 516, 10, false, 1],
                [85, 2, 365, 514, 10, false, 1],
                [85, 36, 346, 480, 10, false, 1],
                [167, 79, 271, 213, 10, false, 1],
                [85, 103, 353, 413, 10, false, 1],
                [191, 142, 279, 374, 20, false, 1],
                [0, 0, 1, 1, 20, false, 1],
                [191, 142, 279, 374, 20, false, 1],
                [191, 142, 279, 374, 30, false, 1],
                [191, 142, 279, 374, 10, false, 1],
                [85, 183, 395, 211, 10, false, 1],
                [85, 183, 395, 258, 10, false, 1],
                [85, 183, 395, 333, 10, false, 1],
                [85, 183, 395, 363, 10, false, 1],
                [85, 183, 395, 405, 10, false, 1],
                [85, 183, 395, 442, 10, false, 1],
                [208, 405, 272, 284, 10, false, 1],
                [324, 499, 156, 194, 10, false, 1],
                [394, 546, 86, 147, 10, false, 1],
                [85, 183, 395, 510, 10, false, 1],
                [0, 0, 1, 1, 10, false, 1],
                [85, 183, 338, 333, 10, false, 1],
                [208, 405, 130, 111, 10, false, 1],
                [208, 247, 215, 269, 10, false, 1]
            ];
            Tools.compareToFrameDump(gif.frames, frameDump);
            assert(Buffer.isBuffer(gif.buffer));
        });
    });
});

describe("partial frame decoding", () => {

    it("renders partial frames properly onto full frames", () => {
        let actualBitmapImage;
        
        return GifUtil.read(Tools.getGifPath('rnaples-offsets-public'))
        .then(actualGif => {
            actualBitmapImage = actualGif.frames[10];
            return Tools.loadBitmapImage(Tools.getImagePath('rnaples-frame-10.png'));
        })
        .then(expectedBitmapImage => {
            const expectedBitmap = expectedBitmapImage.bitmap;
            Tools.checkBitmap(
                actualBitmapImage.bitmap,
                expectedBitmap.width,
                expectedBitmap.height,
                expectedBitmap.data
            );
        });
    });
});

function _compareGifToSeries(actualGif, expectedSeries, options) {

    assert.strictEqual(actualGif.width, expectedSeries[0].width);
    assert.strictEqual(actualGif.height, expectedSeries[0].height);
    if (options.loops === undefined) {
        assert.strictEqual(actualGif.loops, 0);
    }
    else {
        assert.strictEqual(actualGif.loops, options.loops);
    }
    if (options.usesTransparency !== undefined) {
        assert.strictEqual(actualGif.usesTransparency,
                options.usesTransparency);
    }
    if (options.optionization !== undefined) {
        assert.strictEqual(actualGif.optionization, options.optionization);
    }

    assert(Array.isArray(actualGif.frames));
    assert.strictEqual(actualGif.frames.length, expectedSeries.length);
    for (let i = 0; i < actualGif.frames.length; ++i) {
        const f = actualGif.frames[i];
        Tools.checkFrameDefaults(f, options, i);
        assert.deepStrictEqual(f.bitmap, expectedSeries[i],
                `frame ${i} same bitmap`);
    }
    assert(Buffer.isBuffer(actualGif.buffer)); 
}
