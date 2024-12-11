'use strict';

/** @namespace GifUtil */

const fs = require('fs');
const ImageQ = require('image-q');

const BitmapImage = require('./bitmapimage');
const { GifFrame } = require('./gifframe');
const { GifError } = require('./gif');
const { GifCodec } = require('./gifcodec');

const INVALID_SUFFIXES = ['.jpg', '.jpeg', '.png', '.bmp'];

const defaultCodec = new GifCodec();

/**
 * cloneFrames() clones provided frames. It's a utility method for cloning an entire array of frames at once.
 * 
 * @function cloneFrames
 * @memberof GifUtil
 * @param {GifFrame[]} frames An array of GifFrame instances to clone
 * @return {GifFrame[]} An array of GifFrame clones of the provided frames.
 */

exports.cloneFrames = function (frames) {
    let clones = [];
    frames.forEach(frame => {

        clones.push(new GifFrame(frame));
    });
    return clones;
}

/**
 * getColorInfo() gets information about the colors used in the provided frames. The method is able to return an array of all colors found across all frames.
 * 
 * `maxGlobalIndex` controls whether the computation short-circuits to avoid doing work that the caller doesn't need. The method only returns `colors` and `indexCount` for the colors across all frames when the number of indexes required to store the colors and transparency in a GIF (which is the value of `indexCount`) is less than or equal to `maxGlobalIndex`. Such short-circuiting is useful when the caller just needs to determine whether any frame includes transparency.
 * 
 * @function getColorInfo
 * @memberof GifUtil
 * @param {GifFrame[]} frames Frames to examine for color and transparency.
 * @param {number} maxGlobalIndex Maximum number of color indexes (including one for transparency) allowed among the returned compilation of colors. `colors` and `indexCount` are not returned if the number of color indexes required to accommodate  all frames exceeds this number. Returns `colors` and `indexCount` by default.
 * @returns {object} Object containing at least `palettes` and `usesTransparency`. `palettes` is an array of all the palettes returned by GifFrame#getPalette(). `usesTransparency` indicates whether at least one frame uses transparency. If `maxGlobalIndex` is not exceeded, the object also contains `colors`, an array of all colors (RGB) found across all palettes, sorted by increasing value, and `indexCount` indicating the number of indexes required to store the colors and the transparency in a GIF.
 * @throws {GifError} When any frame requires more than 256 color indexes.
 */

exports.getColorInfo = function (frames, maxGlobalIndex) {
    let usesTransparency = false;
    const palettes = [];
    for (let i = 0; i < frames.length; ++i) {
        let palette = frames[i].getPalette();
        if (palette.usesTransparency) {
            usesTransparency = true;
        }
        if (palette.indexCount > 256) {
            throw new GifError(`Frame ${i} uses more than 256 color indexes`);
        }
        palettes.push(palette);
    }
    if (maxGlobalIndex === 0) {
        return { usesTransparency, palettes };
    }

    const globalColorSet = new Set();
    palettes.forEach(palette => {

        palette.colors.forEach(color => {

            globalColorSet.add(color);
        });
    });
    let indexCount = globalColorSet.size;
    if (usesTransparency) {
        // odd that GIF requires a color table entry at transparent index
        ++indexCount;
    }
    if (maxGlobalIndex && indexCount > maxGlobalIndex) {
        return { usesTransparency, palettes };
    }
    
    const colors = new Array(globalColorSet.size);
    const iter = globalColorSet.values();
    for (let i = 0; i < colors.length; ++i) {
        colors[i] = iter.next().value;
    }
    colors.sort((a, b) => (a - b));
    return { colors, indexCount, usesTransparency, palettes };
};

/**
 * copyAsJimp() returns a Jimp that contains a copy of the provided bitmap image (which may be either a BitmapImage or a GifFrame). Modifying the Jimp does not affect the provided bitmap image. This method serves as a macro for simplifying working with Jimp.
 *
 * @function copyAsJimp
 * @memberof GifUtil
 * @param {object} Reference to the Jimp package, keeping this library from being dependent on Jimp.
 * @param {bitmapImageToCopy} Instance of BitmapImage (may be a GifUtil) with which to source the Jimp.
 * @return {object} An new instance of Jimp containing a copy of the image in bitmapImageToCopy.
 */
 
exports.copyAsJimp = function (jimp, bitmapImageToCopy) {
    return exports.shareAsJimp(jimp, new BitmapImage(bitmapImageToCopy));
};

/**
 * getMaxDimensions() returns the pixel width and height required to accommodate all of the provided frames, according to the offsets and dimensions of each frame.
 * 
 * @function getMaxDimensions
 * @memberof GifUtil
 * @param {GifFrame[]} frames Frames to measure for their aggregate maximum dimensions.
 * @return {object} An object of the form {maxWidth, maxHeight} indicating the maximum width and height required to accommodate all frames.
 */

exports.getMaxDimensions = function (frames) {
    let maxWidth = 0, maxHeight = 0;
    frames.forEach(frame => {
        const width = frame.xOffset + frame.bitmap.width;
        if (width > maxWidth) {
            maxWidth = width;
        }
        const height = frame.yOffset + frame.bitmap.height;
        if (height > maxHeight) {
            maxHeight = height;
        }
    });
    return { maxWidth, maxHeight };
};

/**
 * Quantizes colors so that there are at most a given number of color indexes (including transparency) across all provided images. Uses an algorithm by Anthony Dekker.
 * 
 * The method treats different RGBA combinations as different colors, so if the frame has multiple alpha values or multiple RGB values for an alpha value, the caller may first want to normalize them by converting all transparent pixels to the same RGBA values.
 * 
 * The method may increase the number of colors if there are fewer than the provided maximum.
 * 
 * @function quantizeDekker
 * @memberof GifUtil
 * @param {BitmapImage|BitmapImage[]} imageOrImages Image or array of images (such as GifFrame instances) to be color-quantized. Quantizing across multiple images ensures color consistency from frame to frame.
 * @param {number} maxColorIndexes The maximum number of color indexes that will exist in the palette after completing quantization. Defaults to 256.
 * @param {object} dither (optional) An object configuring the dithering to apply. The properties are as followings, imported from the [`image-q` package](https://github.com/ibezkrovnyi/image-quantization) without explanation: { `ditherAlgorithm`: One of 'FloydSteinberg', 'FalseFloydSteinberg', 'Stucki', 'Atkinson', 'Jarvis', 'Burkes', 'Sierra', 'TwoSierra', 'SierraLite'; `minimumColorDistanceToDither`: (optional) A number defaulting to 0; `serpentine`: (optional) A boolean defaulting to true; `calculateErrorLikeGIMP`: (optional) A boolean defaulting to false. }
 */

exports.quantizeDekker = function (imageOrImages, maxColorIndexes, dither) {
    maxColorIndexes = maxColorIndexes || 256;
    _quantize(imageOrImages, 'NeuQuantFloat', maxColorIndexes, 0, dither);
}

/**
 * Quantizes colors so that there are at most a given number of color indexes (including transparency) across all provided images. Uses an algorithm by Leon Sorokin. This quantization method differs from the other two by likely never increasing the number of colors, should there be fewer than the provided maximum.
 * 
 * The method treats different RGBA combinations as different colors, so if the frame has multiple alpha values or multiple RGB values for an alpha value, the caller may first want to normalize them by converting all transparent pixels to the same RGBA values.
 * 
 * @function quantizeSorokin
 * @memberof GifUtil
 * @param {BitmapImage|BitmapImage[]} imageOrImages Image or array of images (such as GifFrame instances) to be color-quantized. Quantizing across multiple images ensures color consistency from frame to frame.
 * @param {number} maxColorIndexes The maximum number of color indexes that will exist in the palette after completing quantization. Defaults to 256.
 * @param {string} histogram (optional) Histogram method: 'top-pop' for global top-population, 'min-pop' for minimum-population threshhold within subregions. Defaults to 'min-pop'.
 * @param {object} dither (optional) An object configuring the dithering to apply, as explained for `quantizeDekker()`.
 */

exports.quantizeSorokin = function (imageOrImages, maxColorIndexes, histogram, dither) {
    maxColorIndexes = maxColorIndexes || 256;
    histogram = histogram || 'min-pop';
    let histogramID;
    switch (histogram) {
        case 'min-pop':
        histogramID = 2;
        break;

        case 'top-pop':
        histogramID = 1;
        break

        default:
        throw new Error(`Invalid quantizeSorokin histogram '${histogram}'`);
    }
    _quantize(imageOrImages, 'RGBQuant', maxColorIndexes, histogramID, dither);
}

/**
 * Quantizes colors so that there are at most a given number of color indexes (including transparency) across all provided images. Uses an algorithm by Xiaolin Wu.
 * 
 * The method treats different RGBA combinations as different colors, so if the frame has multiple alpha values or multiple RGB values for an alpha value, the caller may first want to normalize them by converting all transparent pixels to the same RGBA values.
 * 
 * The method may increase the number of colors if there are fewer than the provided maximum.
 * 
 * @function quantizeWu
 * @memberof GifUtil
 * @param {BitmapImage|BitmapImage[]} imageOrImages Image or array of images (such as GifFrame instances) to be color-quantized. Quantizing across multiple images ensures color consistency from frame to frame.
 * @param {number} maxColorIndexes The maximum number of color indexes that will exist in the palette after completing quantization. Defaults to 256.
 * @param {number} significantBits (optional) This is the number of significant high bits in each RGB color channel. Takes integer values from 1 through 8. Higher values correspond to higher quality. Defaults to 5.
 * @param {object} dither (optional) An object configuring the dithering to apply, as explained for `quantizeDekker()`.
 */

exports.quantizeWu = function (imageOrImages, maxColorIndexes, significantBits, dither) {
    maxColorIndexes = maxColorIndexes || 256;
    significantBits = significantBits || 5;
    if (significantBits < 1 || significantBits > 8) {
        throw new Error("Invalid quantization quality");
    }
    _quantize(imageOrImages, 'WuQuant', maxColorIndexes, significantBits, dither);
}

/**
 * read() decodes an encoded GIF, whether provided as a filename or as a byte buffer.
 * 
 * @function read
 * @memberof GifUtil
 * @param {string|Buffer} source Source to decode. When a string, it's the GIF filename to load and parse. When a Buffer, it's an encoded GIF to parse.
 * @param {object} decoder An optional GIF decoder object implementing the `decode` method of class GifCodec. When provided, the method decodes the GIF using this decoder. When not provided, the method uses GifCodec.
 * @return {Promise} A Promise that resolves to an instance of the Gif class, representing the decoded GIF.
 */

exports.read = function (source, decoder) {
    decoder = decoder || defaultCodec;
    if (Buffer.isBuffer(source)) {
        return decoder.decodeGif(source);
    }
    return _readBinary(source)
    .then(buffer => {

        return decoder.decodeGif(buffer);
    });
};

/**
 * shareAsJimp() returns a Jimp that shares a bitmap with the provided bitmap image (which may be either a BitmapImage or a GifFrame). Modifying the image in either the Jimp or the BitmapImage affects the other objects. This method serves as a macro for simplifying working with Jimp.
 *
 * @function shareAsJimp
 * @memberof GifUtil
 * @param {object} Reference to the Jimp package, keeping this library from being dependent on Jimp.
 * @param {bitmapImageToShare} Instance of BitmapImage (may be a GifUtil) with which to source the Jimp.
 * @return {object} An new instance of Jimp that shares the image in bitmapImageToShare.
 */
 
exports.shareAsJimp = function (jimp, bitmapImageToShare) {
    const jimpImage = new jimp(bitmapImageToShare.bitmap.width,
            bitmapImageToShare.bitmap.height, 0);
    jimpImage.bitmap.data = bitmapImageToShare.bitmap.data;
    return jimpImage;
};

/**
 * write() encodes a GIF and saves it as a file.
 * 
 * @function write
 * @memberof GifUtil
 * @param {string} path Filename to write GIF out as. Will overwrite an existing file.
 * @param {GifFrame[]} frames Array of frames to be written into GIF.
 * @param {object} spec An optional object that may provide values for `loops` and `colorScope`, as defined for the Gif class. However, `colorSpace` may also take the value Gif.GlobalColorsPreferred (== 0) to indicate that the encoder should attempt to create only a global color table. `loop` defaults to 0, looping indefinitely, and `colorScope` defaults to Gif.GlobalColorsPreferred.
 * @param {object} encoder An optional GIF encoder object implementing the `encode` method of class GifCodec. When provided, the method encodes the GIF using this encoder. When not provided, the method uses GifCodec.
 * @return {Promise} A Promise that resolves to an instance of the Gif class, representing the encoded GIF.
 */

exports.write = function (path, frames, spec, encoder) {
    encoder = encoder || defaultCodec;
    const matches = path.match(/\.[a-zA-Z]+$/); // prevent accidents
    if (matches !== null &&
            INVALID_SUFFIXES.includes(matches[0].toLowerCase()))
    {
        throw new Error(`GIF '${path}' has an unexpected suffix`);
    }

    return encoder.encodeGif(frames, spec)
    .then(gif => {

        return _writeBinary(path, gif.buffer)
        .then(() => {

            return gif;
        });
    });
};

function _quantize(imageOrImages, method, maxColorIndexes, modifier, dither) {
    const images = Array.isArray(imageOrImages) ? imageOrImages : [imageOrImages];
    const ditherAlgs = [
        'FloydSteinberg',
        'FalseFloydSteinberg',
        'Stucki',
        'Atkinson',
        'Jarvis',
        'Burkes',
        'Sierra',
        'TwoSierra',
        'SierraLite'
    ];

    if (dither) {
        if (ditherAlgs.indexOf(dither.ditherAlgorithm) < 0) {
            throw new Error(`Invalid ditherAlgorithm '${dither.ditherAlgorithm}'`);
        }
        if (dither.serpentine === undefined) {
            dither.serpentine = true;
        }
        if (dither.minimumColorDistanceToDither === undefined) {
            dither.minimumColorDistanceToDither = 0;
        }
        if (dither.calculateErrorLikeGIMP === undefined) {
            dither.calculateErrorLikeGIMP = false;
        }
    }

    const distCalculator = new ImageQ.distance.Euclidean();
    const quantizer = new ImageQ.palette[method](distCalculator, maxColorIndexes, modifier);
    let imageMaker;
    if (dither) {
        imageMaker = new ImageQ.image.ErrorDiffusionArray(
            distCalculator,
            ImageQ.image.ErrorDiffusionArrayKernel[dither.ditherAlgorithm],
            dither.serpentine,
            dither.minimumColorDistanceToDither,
            dither.calculateErrorLikeGIMP
        );
    }
    else {
        imageMaker = new ImageQ.image.NearestColor(distCalculator);
    }

    const inputContainers = [];
    images.forEach(image => {

        const imageBuf = image.bitmap.data;
        const inputBuf = new ArrayBuffer(imageBuf.length);
        const inputArray = new Uint32Array(inputBuf);
        for (let bi = 0, ai = 0; bi < imageBuf.length; bi += 4, ++ai) {
            inputArray[ai] = imageBuf.readUInt32LE(bi, true);
        }
        const inputContainer = ImageQ.utils.PointContainer.fromUint32Array(
                inputArray, image.bitmap.width, image.bitmap.height);
        quantizer.sample(inputContainer);
        inputContainers.push(inputContainer);
    });
    
    const limitedPalette = quantizer.quantizeSync();

    for (let i = 0; i < images.length; ++i) {
        const imageBuf = images[i].bitmap.data;
        const outputContainer = imageMaker.quantizeSync(inputContainers[i], limitedPalette);
        const outputArray = outputContainer.toUint32Array();
        for (let bi = 0, ai = 0; bi < imageBuf.length; bi += 4, ++ai) {
            imageBuf.writeUInt32LE(outputArray[ai], bi);
        }
    }
}

function _readBinary(path) {
    // TBD: add support for URLs
    return new Promise((resolve, reject) => {

        fs.readFile(path, (err, buffer) => {

            if (err) {
                return reject(err);
            }
            return resolve(buffer);
        });
    });
}

function _writeBinary(path, buffer) {
    // TBD: add support for URLs
    return new Promise((resolve, reject) => {

        fs.writeFile(path, buffer, err => {
            
            if (err) {
                return reject(err);
            }
            return resolve();
        });
    });
}
