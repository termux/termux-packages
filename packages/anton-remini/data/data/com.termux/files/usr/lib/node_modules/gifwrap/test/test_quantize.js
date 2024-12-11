'use strict';

const assert = require('chai').assert;
const Jimp = require('jimp');
const Tools = require('./lib/tools');
const { BitmapImage, GifUtil } = require('../src/index');

describe("graphics color index reduction", () => {

    it("Dekker-quantizes down to 32 colors", () => {

        return _graphicsTest('quantizeDekker', 32);
    });

    it("Dekker-quantizes down to 256 colors", () => {

        return _graphicsTest('quantizeDekker', 256);
    });

    it("Sorokin-quantizes down to 32 colors", () => {

        return _graphicsTest('quantizeSorokin', 32);
    });

    it("Sorokin-quantizes down to 256 colors", () => {

        return _graphicsTest('quantizeSorokin', 256);
    });

    it("Wu-quantizes down to 32 colors", () => {

        return _graphicsTest('quantizeWu', 32);
    });

    it("Wu-quantizes down to 256 colors", () => {

        return _graphicsTest('quantizeWu', 256);
    });
});

describe("photo color index reduction", () => {

    it("Dekker-quantizes down to 32 colors", () => {

        return _photoTest('quantizeDekker', 32);
    });

    it("Dekker-quantizes down to 256 colors", () => {

        return _photoTest('quantizeDekker', 256);
    });

    it("Sorokin-quantizes down to 32 colors", () => {

        return _photoTest('quantizeSorokin', 32);
    });

    it("Sorokin-quantizes down to 256 colors", () => {

        return _photoTest('quantizeSorokin', 256);
    });

    it("Wu-quantizes down to 32 colors", () => {

        return _photoTest('quantizeWu', 32);
    });

    it("Wu-quantizes down to 256 colors", () => {

        return _photoTest('quantizeWu', 256);
    });
});

describe("dithering", () => {

    it("FloydSteinberg-dither of Dekker-quantized 256 colors", () => {

        return _ditherTest('quantizeDekker', 256, null, 'FloydSteinberg');
    });

    it("FloydSteinberg-dither of Sorokin-quantized 256 colors", () => {

        return _ditherTest('quantizeSorokin', 256, 'min-pop', 'FloydSteinberg');
    });

    it("FloydSteinberg-dither of Wu-quantized 256 colors", () => {

        return _ditherTest('quantizeWu', 256, 5, 'FloydSteinberg');
    });
});

describe("reduce colors across a series of images", () => {

    const specialOpaque = 0xffffffff;
    const specialTransparent = 0;

    it("Dekker-quantizes an opaque image series down to 256 colors", (done) => {

        _seriesTest('quantizeDekker', specialOpaque);
        done();
    });

    it("Dekker-quantizes an image series with transparency down to 256 colors", (done) => {

        _seriesTest('quantizeDekker', specialTransparent);
        done();
    });

    it("Sorokin-quantizes an opaque image series down to 256 colors", (done) => {

        _seriesTest('quantizeSorokin', specialOpaque);
        done();
    });

    it("Sorokin-quantizes an image series with transparency down to 256 colors", (done) => {

        _seriesTest('quantizeSorokin', specialTransparent);
        done();
    });

    it("Wu-quantizes an opaque image series down to 256 colors", (done) => {

        _seriesTest('quantizeWu', specialOpaque);
        done();
    });

    it("Wu-quantizes an image series with transparency down to 256 colors", (done) => {

        _seriesTest('quantizeWu', specialTransparent);
        done();
    });
});

function _ditherTest(method, maxColors, modifier, ditherAlg) {
    return _reductionTest("sculptmap.png", false, method, maxColors, modifier, {
        ditherAlgorithm: ditherAlg
    });
}

function _graphicsTest(method, maxColors) {
    return _reductionTest("sculptmap.png", false, method, maxColors)
    .then(() => {

        return _reductionTest("rosewithtrans.png", true, method, maxColors);
    })
}

function _hasTransparency(colorSet) {
    for (let rgba of colorSet.values()) {
        if ((rgba & 0xff) === 0x00) {
            return true;
        }
    }
    return false;
}

function _photoTest(method, maxColors) {
    return _reductionTest("hairstreak.jpg", false, method, maxColors);
}

function _reductionTest(sourceFile, usesTransparency, method, maxColors, modifier, dither) {
    const baseFile = sourceFile.substr(0, sourceFile.length - 4);
    const suffix = method.substr(8);
    let expectedFile = `quantized/${baseFile}${maxColors}_${suffix}`;
    if (dither) {
        expectedFile += '_' + dither.ditherAlgorithm;
    }
    expectedFile += '.png';
    const label = `${method}(${maxColors}) - ${baseFile}`;
    const writeFile = null; //expectedFile;
    let work;

    return new Promise((resolve, reject) => {
        new Jimp(Tools.getFixturePath(sourceFile), (err, manyJimp) => {

            if (err) return reject(err);
            new Jimp(Tools.getFixturePath(expectedFile), (err, limitedJimp) => {

                if (err) return reject(err);
                work = new BitmapImage(manyJimp.bitmap);

                const inputColorSet = work.getRGBASet();
                assert.strictEqual(_hasTransparency(inputColorSet), usesTransparency, label);
                assert.isAtLeast(inputColorSet.size, maxColors + 1, label);

                if (method === 'quantizeDekker') {
                    GifUtil[method](work, maxColors, dither);
                }
                else {
                    GifUtil[method](work, maxColors, modifier, dither);
                }

                const workBuf = work.bitmap.data;
                const limitedBuf = limitedJimp.bitmap.data;
                assert.strictEqual(workBuf.length, manyJimp.bitmap.data.length, label);
                assert.strictEqual(workBuf.compare(limitedBuf), 0, label);

                const outputColorSet = work.getRGBASet();
                assert.strictEqual(_hasTransparency(outputColorSet), usesTransparency, label);
                assert.isAtMost(outputColorSet.size, maxColors, label);
                resolve();
            });
        });
    })
    .then(() => {
        if (writeFile) {
            return _writeJimp(writeFile, work.bitmap);
        }
    });
}

function _seriesTest(method, specialColor) {
    const images = [];
    const width = 32, height = 32;
    const maxColors = 256;

    let image = new BitmapImage(width, height);
    let buf = image.bitmap.data;
    let bi = 0;
    for (let y = 0; y < height; ++y) {
        for (let x = 0; x < width; ++x) {
            buf[bi] = x * 8;
            buf[bi + 1] = y * 8;
            buf[bi + 3] = 255;
            bi += 4;
        }
    }
    images.push(image); // 32 * 32 = 1024 colors

    image = new BitmapImage(width, height);
    buf = image.bitmap.data;
    bi = 0;
    for (let y = 0; y < height; ++y) {
        for (let x = 0; x < width; ++x) {
            buf[bi] = x * 8 + 4;
            buf[bi + 1] = y * 8 + 4;
            buf[bi + 3] = 255;
            bi += 4;
        }
    }
    images.push(image); // 32 * 32 = 1024 more colors

    image = new BitmapImage(width, height);
    buf = image.bitmap.data;
    bi = 0;
    for (let y = 0; y < height; ++y) {
        for (let x = 0; x < width; ++x) {
            if (x < width / 2) {
                buf.writeUInt32BE(255, bi);
            }
            else {
                buf.writeUInt32BE(specialColor, bi);
            }
            bi += 4;
        }
    }
    images.push(image); // 1 more color (white), which should be there

    GifUtil[method](images, maxColors);

    const colorSet = new Set();
    images.forEach(image => {

        buf = image.bitmap.data;
        for (let bi = 0; bi < buf.length; bi += 4) {
            colorSet.add(buf.readUInt32BE(bi, true));
        }
    });
    assert.isAtMost(colorSet.size, maxColors);
    assert(colorSet.has(specialColor), "has special color");
}

function _writeJimp(filename, bitmap) {

    const jimp = new Jimp(1, 1);
    jimp.bitmap = bitmap;

    return new Promise((resolve, reject) => {

        jimp.write(filename, (err) => {
            if (err) return reject(err);
            resolve();
        });
    }).then(() => {

        console.log(`WROTE ${filename}`);
    })
    .catch((err) => {

        console.log(`WRITE FAILED ${err.stack}`);
    });
}
