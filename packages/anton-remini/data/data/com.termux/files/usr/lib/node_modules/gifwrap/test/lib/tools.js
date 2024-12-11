'use strict';

const assert = require('chai').assert;
const Path = require('path');
const Jimp = require('jimp');
const Bitmaps = require('./bitmaps');
const { BitmapImage } = require('../../src/index');
const { GifFrame } = require('../../src/gifframe');

exports.checkBitmap = function (bitmap, width, height, rgbaOrBuf) {
    assert.strictEqual(bitmap.width, width, "width");
    assert.strictEqual(bitmap.height, height, "height");
    if (Buffer.isBuffer(rgbaOrBuf)) {
        assert.strictEqual(bitmap.data.length, rgbaOrBuf.length, "length");
        for (let i = 0; i < rgbaOrBuf.length; ++i ) {
            assert.strictEqual(rgbaOrBuf[i], bitmap.data[i], "at buffer index "+ i);
        }
    }
    else if (typeof rgbaOrBuf === 'number') {
        const rgba = rgbaOrBuf
        const buf = bitmap.data;
        for (let bi = 0; bi < buf.length; bi += 4) {
            const found = buf.readUInt32BE(bi);
            if (found !== rgba) {
                assert.fail(found, rgba, `buffer fill color ${found} != ${rgba}`);
            }
        }
    }
    else {
        throw new Error("last checkBitmap() param must be a color or a Buffer");
    }
}

exports.checkFrameDefaults = function (actualInfo, options, frameIndex = 0) {
    options = Object.assign({}, options); // don't munge caller
    options.xOffset = options.xOffset || 0;
    options.yOffset = options.yOffset || 0;
    options.delayCentisecs = options.delayCentisecs || 8;
    options.interlaced = (options.interlaced === true);
    options.disposalMethod =
            (options.disposalMethod || GifFrame.DisposeToBackgroundColor);
    exports.verifyFrameInfo(actualInfo, options, frameIndex);
};

exports.compareToFrameDump = function (actualFrames, expectedDump) {
    assert(Array.isArray(actualFrames));
    assert.strictEqual(actualFrames.length, expectedDump.length);
    for (let i = 0; i < actualFrames.length; ++i) {
        const actualFrame = actualFrames[i];
        const dump = expectedDump[i];
        exports.verifyFrameInfo(actualFrame, {
            xOffset: dump[0],
            yOffset: dump[1],
            bitmap: {
                width: dump[2],
                height: dump[3]
            },
            delayCentisecs: dump[4],
            interlaced: dump[5],
            disposalMethod: dump[6]
        }, i);
    }
};

exports.dumpFramesAsCode = function (frames) {
    let first = true;
    process.stdout.write("[\n");
    frames.forEach(f => {
        if (!first) {
            process.stdout.write(",\n");
        }
        process.stdout.write(`    [${f.xOffset}, ${f.yOffset}, `+
                `${f.bitmap.width}, ${f.bitmap.height}, `+
                `${f.delayCentisecs}, ${f.interlaced}, ${f.disposalMethod}]`);
        first = false;
    });
    process.stdout.write("\n]\n");
};

exports.getBitmap = function (bitmapName, transparentRGB) {
    const stringPic = Bitmaps.PREMADE[bitmapName];
    if (stringPic === undefined) {
        throw new Error(`Bitmap '${bitmapName}' not found`);
    }
    if (Array.isArray(stringPic[0])) {
        throw new Error(`'${bitmapName}' is a bitmap series`);
    }
    return _stringsToBitmap(stringPic, transparentRGB);
};

exports.getFixturePath = function (filename) {
    return Path.join(__dirname, "../fixtures", filename);
};

exports.getGifPath = function (filenameMinusExtension) {
    return exports.getFixturePath(filenameMinusExtension + '.gif');
};

exports.getImagePath = function (filename) {
    return exports.getFixturePath(filename);
};

exports.getSeries = function (seriesName, transparentRGB) {
    const series = Bitmaps.PREMADE[seriesName];
    if (series === undefined) {
        throw new Error(`Bitmap series '${seriesName}' not found`);
    }
    if (!Array.isArray(series[0])) {
        throw new Error(`'${seriesName}' is not a bitmap series`);
    }
    return series.map(stringPic =>
            (_stringsToBitmap(stringPic, transparentRGB)));
};

exports.loadBitmapImage = function (imagePath) {
    return new Promise((resolve, reject) => {
        new Jimp(imagePath, (err, jimp) => {
            if (err) return reject(err);
            resolve(new BitmapImage(jimp.bitmap));
        });
    });
};

exports.saveBitmapImage = function (bitmapImage, path) {
    let jimp = new Jimp(1, 1, 0);
    jimp.bitmap = bitmapImage.bitmap;
    return new Promise((resolve, reject) => {
        jimp.write(path, (err) => {
            if (err) return reject(err);
            resolve();
        });
    });
};

exports.verifyFrameInfo = function (actual, expected, frameIndex=0, note='') {
    expected = Object.assign({}, expected); // don't munge caller
    if (expected.xOffset !== undefined) {
        assert.strictEqual(actual.xOffset, expected.xOffset,
                `frame ${frameIndex} same x offset${note}`);
    }
    if (expected.yOffset !== undefined) {
        assert.strictEqual(actual.yOffset, expected.yOffset,
                `frame ${frameIndex} same y offset${note}`);
    }
    if (expected.bitmap !== undefined) {
        assert.strictEqual(actual.bitmap.width, expected.bitmap.width,
                `frame ${frameIndex} same width${note}`);
        assert.strictEqual(actual.bitmap.height, expected.bitmap.height,
                `frame ${frameIndex} same height${note}`);
    }
    if (expected.delayCentisecs !== undefined) {
        assert.strictEqual(actual.delayCentisecs, expected.delayCentisecs,
                `frame ${frameIndex} same delay${note}`);
    }
    if (expected.disposalMethod !== undefined) {
        assert.strictEqual(actual.disposalMethod, expected.disposalMethod,
                `frame ${frameIndex} same disposal method${note}`);
    }
    assert.strictEqual(actual.interlaced, (expected.interlaced === true),
            `frame ${frameIndex} same interlacing${note}`);
};

function _stringsToBitmap(stringPic, transparentRGB) {
    const trans = transparentRGB; // shortens code, leaves parameter clear
    const width = stringPic[0].length;
    const height = stringPic.length;
    const data = new Buffer(width * height * 4);
    let offset = 0;

    for (let y = 0; y < height; ++y) {
        const row = stringPic[y];
        if (row.length !== width) {
            throw new Error("Inconsistent pixel string length");
        }
        for (let x = 0; x < width; ++x) {
            if (Bitmaps.COLORS[row[x]] !== undefined) {
                const color = Bitmaps.COLORS[row[x]];
                const alpha = color & 0xff;
                if (alpha !== 0 || trans === undefined) {
                    data[offset] = (color >> 24) & 0xff;
                    data[offset + 1] = (color >> 16) & 0xff;
                    data[offset + 2] = (color >> 8) & 0xff;
                    data[offset + 3] = color & 0xff;
                }
                else {
                    // not concerned about speed
                    data[offset] = (trans >> 16) & 0xff;
                    data[offset + 1] = (trans >> 8) & 0xff;
                    data[offset + 2] = trans & 0xff;
                    data[offset + 3] = 0;
                }
                offset += 4;
            }
            else {
                const validChars = Object.keys(Bitmaps.COLORS).join('');
                throw new Error(`Invalid pixel char '${row[x]}'. `+
                        `Valid chars are "${validChars}".`);
            }
        }
    }
    return { width, height, data };
}
