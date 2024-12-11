'use strict';

const Omggif = require('omggif');
const { Gif, GifError } = require('./gif');

// allow circular dependency with GifUtil
function GifUtil() {
    const data = require('./gifutil');

    GifUtil = function () {
      return data;
    };

  return data;
}

const { GifFrame } = require('./gifframe');

const PER_GIF_OVERHEAD = 200; // these are guesses at upper limits
const PER_FRAME_OVERHEAD = 100;

// Note: I experimented with accepting a global color table when encoding and returning the global color table when decoding. Doing this properly greatly increased the complexity of the code and the amount of clock cycles required. The main issue is that each frame can specify any color of the global color table to be transparent within the frame, while this GIF library strives to hide GIF formatting details from its clients. E.g. it's possible to have 256 colors in the global color table and different transparencies in each frame, requiring clients to either provide per-frame transparency indexes, or for arcane reasons that won't be apparent to client developers, encode some GIFs with local color tables that previously decoded with global tables.

/** @class GifCodec */

class GifCodec
{
    // _transparentRGBA - RGB given to transparent pixels (alpha=0) on decode; defaults to null indicating 0x000000, which is fastest

    /**
     * GifCodec is a class that both encodes and decodes GIFs. It implements both the `encode()` method expected of an encoder and the `decode()` method expected of a decoder, and it wraps the `omggif` GIF encoder/decoder package. GifCodec serves as this library's default encoder and decoder, but it's possible to wrap other GIF encoders and decoders for use by `gifwrap` as well. GifCodec will not encode GIFs with interlacing.
     * 
     * Instances of this class are stateless and can be shared across multiple encodings and decodings.
     * 
     * Its constructor takes one option argument:
     * 
     * @param {object} options Optionally takes an objection whose only possible property is `transparentRGB`. Images are internally represented in RGBA format, where A is the alpha value of a pixel. When `transparentRGB` is provided, this RGB value (excluding alpha) is assigned to transparent pixels, which are also given alpha value 0x00. (All opaque pixels are given alpha value 0xFF). The RGB color of transparent pixels shouldn't matter for most applications. Defaults to 0x000000.
     */

    constructor(options = {}) {
        this._transparentRGB = null; // 0x000000
        if (typeof options.transparentRGB === 'number' &&
                options.transparentRGB !== 0)
        {
            this._transparentRGBA = options.transparentRGB * 256;
        }
        this._testInitialBufferSize = 0; // assume no buffer scaling test
    }

    /**
     * Decodes a GIF from a Buffer to yield an instance of Gif. Transparent pixels of the GIF are given alpha values of 0x00, and opaque pixels are given alpha values of 0xFF. The RGB values of transparent pixels default to 0x000000 but can be overridden by the constructor's `transparentRGB` option.
     * 
     * @param {Buffer} buffer Bytes of an encoded GIF to decode.
     * @return {Promise} A Promise that resolves to an instance of the Gif class, representing the encoded GIF.
     * @throws {GifError} Error upon encountered an encoding-related problem with a GIF, so that the caller can distinguish between software errors and problems with GIFs.
     */

    decodeGif(buffer) {
        try {
            let reader;
            try {
                reader = new Omggif.GifReader(buffer);
            }
            catch (err) {
                throw new GifError(err);
            }
            const frameCount = reader.numFrames();
            const frames = [];
            const spec = {
                width: reader.width,
                height: reader.height,
                loops: reader.loopCount()
            };

            spec.usesTransparency = false;
            for (let i = 0; i < frameCount; ++i) {
                const frameInfo =
                        this._decodeFrame(reader, i, spec.usesTransparency);
                frames.push(frameInfo.frame);
                if (frameInfo.usesTransparency) {
                    spec.usesTransparency = true;
                }
            }
            return Promise.resolve(new Gif(buffer, frames, spec));
        }
        catch (err) {
            return Promise.reject(err);
        }
    }

    /**
     * Encodes a GIF from provided frames. Each pixel having an alpha value of 0x00 renders as transparent within the encoding, while all pixels of non-zero alpha value render as opaque.
     * 
     * @param {GifFrame[]} frames Array of frames to encode
     * @param {object} spec An optional object that may provide values for `loops` and `colorScope`, as defined for the Gif class. However, `colorSpace` may also take the value Gif.GlobalColorsPreferred (== 0) to indicate that the encoder should attempt to create only a global color table. `loop` defaults to 0, looping indefinitely. Set `loop` to null to disable looping, playing only once. `colorScope` defaults to Gif.GlobalColorsPreferred.
     * @return {Promise} A Promise that resolves to an instance of the Gif class, representing the encoded GIF.
     * @throws {GifError} Error upon encountered an encoding-related problem with a GIF, so that the caller can distinguish between software errors and problems with GIFs.
     */

    encodeGif(frames, spec = {}) {
        try {
            if (frames === null || frames.length === 0) {
                throw new GifError("there are no frames");
            }
            const dims = GifUtil().getMaxDimensions(frames);

            spec = Object.assign({}, spec); // don't munge caller's spec
            spec.width = dims.maxWidth;
            spec.height = dims.maxHeight;
            if (spec.loops === undefined) {
                spec.loops = 0;
            }
            spec.colorScope = spec.colorScope || Gif.GlobalColorsPreferred;

            return Promise.resolve(this._encodeGif(frames, spec));
        }
        catch (err) {
            return Promise.reject(err);
        }
    }

    _decodeFrame(reader, frameIndex, alreadyUsedTransparency) {
        let info, buffer;
        try {
            info = reader.frameInfo(frameIndex);
            buffer = new Buffer(reader.width * reader.height * 4);
            reader.decodeAndBlitFrameRGBA(frameIndex, buffer);
            if (info.width !== reader.width || info.height !== reader.height) {
                if (info.y) {
                    // skip unused rows
                    buffer = buffer.slice(info.y * reader.width * 4);
                }
                if (reader.width > info.width) {
                    // skip scanstride
                    for (let ii = 0; ii < info.height; ++ii) {
                        buffer.copy(buffer, ii * info.width * 4,
                            (info.x + ii * reader.width) * 4,
                            (info.x + ii * reader.width) * 4 + info.width * 4);
                    }
                }
                // trim buffer to size
                buffer = buffer.slice(0, info.width * info.height * 4);
            }
        }
        catch (err) {
            throw new GifError(err);
        }

        let usesTransparency = false;
        if (this._transparentRGBA === null) {
            if (!alreadyUsedTransparency) {
                for (let i = 3; i < buffer.length; i += 4) {
                    if (buffer[i] === 0) {
                        usesTransparency = true;
                        i = buffer.length;
                    }
                }
            }
        }
        else {
            for (let i = 3; i < buffer.length; i += 4) {
                if (buffer[i] === 0) {
                    buffer.writeUInt32BE(this._transparentRGBA, i - 3);
                    usesTransparency = true; // GIF might encode unused index
                }
            }
        }

        const frame = new GifFrame(info.width, info.height, buffer, {
            xOffset: info.x,
            yOffset: info.y,
            disposalMethod: info.disposal,
            interlaced: info.interlaced,
            delayCentisecs: info.delay
        });
        return { frame, usesTransparency };
    }

    _encodeGif(frames, spec) {
        let colorInfo;
        if (spec.colorScope === Gif.LocalColorsOnly) {
            colorInfo = GifUtil().getColorInfo(frames, 0);
        }
        else {
            colorInfo = GifUtil().getColorInfo(frames, 256);
            if (!colorInfo.colors) { // if global palette impossible
                if (spec.colorScope === Gif.GlobalColorsOnly) {
                    throw new GifError(
                            "Too many color indexes for global color table");
                }
                spec.colorScope = Gif.LocalColorsOnly
            }
        }
        spec.usesTransparency = colorInfo.usesTransparency;

        const localPalettes = colorInfo.palettes;
        if (spec.colorScope === Gif.LocalColorsOnly) {
            const localSizeEst = 2000; //this._getSizeEstimateLocal(localPalettes, frames);
            return _encodeLocal(frames, spec, localSizeEst, localPalettes);
        }

        const globalSizeEst = 2000; //this._getSizeEstimateGlobal(colorInfo, frames);
        return _encodeGlobal(frames, spec, globalSizeEst, colorInfo);
    }

    _getSizeEstimateGlobal(globalPalette, frames) {
        if (this._testInitialBufferSize > 0) {
            return this._testInitialBufferSize;
        }
        let sizeEst = PER_GIF_OVERHEAD + 3*256 /* max palette size*/;
        const pixelBitWidth = _getPixelBitWidth(globalPalette);
        frames.forEach(frame => {
            sizeEst += _getFrameSizeEst(frame, pixelBitWidth);
        });
        return sizeEst; // should be the upper limit
    }

    _getSizeEstimateLocal(palettes, frames) {
        if (this._testInitialBufferSize > 0) {
            return this._testInitialBufferSize;
        }
        let sizeEst = PER_GIF_OVERHEAD;
        for (let i = 0; i < frames.length; ++i ) {
            const palette = palettes[i];
            const pixelBitWidth = _getPixelBitWidth(palette);
            sizeEst += _getFrameSizeEst(frames[i], pixelBitWidth);
        }
        return sizeEst; // should be the upper limit
    }
}
exports.GifCodec = GifCodec;

function _colorLookupLinear(colors, color) {
    const index = colors.indexOf(color);
    return (index === -1 ? null : index);
}

function _colorLookupBinary(colors, color) {
    // adapted from https://stackoverflow.com/a/10264318/650894
    var lo = 0, hi = colors.length - 1, mid;
    while (lo <= hi) {
        mid = Math.floor((lo + hi)/2);
        if (colors[mid] > color)
            hi = mid - 1;
        else if (colors[mid] < color)
            lo = mid + 1;
        else
            return mid;
    }
    return null;
}

function _encodeGlobal(frames, spec, bufferSizeEst, globalPalette) {
    // would be inefficient for frames to lookup colors in extended palette 
    const extendedGlobalPalette = {
        colors: globalPalette.colors.slice(),
        usesTransparency: globalPalette.usesTransparency
    };
    _extendPaletteToPowerOf2(extendedGlobalPalette);
    const options = {
        palette: extendedGlobalPalette.colors,
        loop: spec.loops
    };
    let buffer = new Buffer(bufferSizeEst);
    let gifWriter;
    try {
        gifWriter = new Omggif.GifWriter(buffer, spec.width, spec.height,
                            options);
    }
    catch (err) {
        throw new GifError(err);
    }
    for (let i = 0; i < frames.length; ++i) {
        buffer = _writeFrame(gifWriter, i, frames[i], globalPalette, false);
    }
    return new Gif(buffer.slice(0, gifWriter.end()), frames, spec);
}

function _encodeLocal(frames, spec, bufferSizeEst, localPalettes) {
    const options = {
        loop: spec.loops
    };
    let buffer = new Buffer(bufferSizeEst);
    let gifWriter;
    try {
        gifWriter = new Omggif.GifWriter(buffer, spec.width, spec.height,
                            options);
    }                            
    catch (err) {
        throw new GifError(err);
    }
    for (let i = 0; i < frames.length; ++i) {
        buffer = _writeFrame(gifWriter, i, frames[i], localPalettes[i], true);
    }
    return new Gif(buffer.slice(0, gifWriter.end()), frames, spec);
}

function _extendPaletteToPowerOf2(palette) {
    const colors = palette.colors;
    if (palette.usesTransparency) {
        colors.push(0);
    }
    const colorCount = colors.length;
    let powerOf2 = 2;
    while (colorCount > powerOf2) {
        powerOf2 <<= 1;
    }
    colors.length = powerOf2;
    colors.fill(0, colorCount);
}

function _getFrameSizeEst(frame, pixelBitWidth) {
    let byteLength = frame.bitmap.width * frame.bitmap.height;
    byteLength = Math.ceil(byteLength * pixelBitWidth / 8);
    byteLength += Math.ceil(byteLength / 255); // add block size bytes
    // assume maximum palete size because it might get extended for power of 2
    return (PER_FRAME_OVERHEAD + byteLength + 3 * 256 /* largest palette */);
}

function _getIndexedImage(frameIndex, frame, palette) {
    const colors = palette.colors;
    const colorToIndexFunc = (colors.length <= 8 ? // guess at the break-even
            _colorLookupLinear : _colorLookupBinary);
    const colorBuffer = frame.bitmap.data;
    const indexBuffer = new Buffer(colorBuffer.length/4);
    let transparentIndex = colors.length;
    let i = 0, j = 0;

    while (i < colorBuffer.length) {
        if (colorBuffer[i + 3] !== 0) {
            const color = (colorBuffer.readUInt32BE(i, true) >> 8) & 0xFFFFFF;
            // caller guarantees that the color will be in the palette
            indexBuffer[j] = colorToIndexFunc(colors, color);
        }
        else {
            indexBuffer[j] = transparentIndex;
        }
        i += 4; // skip alpha
        ++j;
    }

    if (palette.usesTransparency) {
        if (transparentIndex === 256) {
            throw new GifError(`Frame ${frameIndex} already has 256 colors` +
                    `and so can't use transparency`);
        }
    }
    else {
        transparentIndex = null;
    }

    return { buffer: indexBuffer, transparentIndex };
}

function _getPixelBitWidth(palette) {
    let indexCount = palette.indexCount;
    let pixelBitWidth = 0;
    --indexCount; // start at maximum index
    while (indexCount) {
        ++pixelBitWidth;
        indexCount >>= 1;
    }
    return (pixelBitWidth > 0 ? pixelBitWidth : 1);
}

function _writeFrame(gifWriter, frameIndex, frame, palette, isLocalPalette) {
    if (frame.interlaced) {
        throw new GifError("writing interlaced GIFs is not supported");
    }
    const frameInfo = _getIndexedImage(frameIndex, frame, palette);
    const options = {
        delay: frame.delayCentisecs,
        disposal: frame.disposalMethod,
        transparent: frameInfo.transparentIndex
    };
    if (isLocalPalette) {
        _extendPaletteToPowerOf2(palette); // ok 'cause palette never used again
        options.palette = palette.colors;
    }
    try {
        let buffer = gifWriter.getOutputBuffer();
        let startOfFrame = gifWriter.getOutputBufferPosition();
        let endOfFrame;
        let tryAgain = true;

        while (tryAgain) {
            endOfFrame = gifWriter.addFrame(frame.xOffset, frame.yOffset,
                    frame.bitmap.width, frame.bitmap.height, frameInfo.buffer, options);
            tryAgain = false;
            if (endOfFrame >= buffer.length - 1) {
                const biggerBuffer = new Buffer(buffer.length * 1.5);
                buffer.copy(biggerBuffer);
                gifWriter.setOutputBuffer(biggerBuffer);
                gifWriter.setOutputBufferPosition(startOfFrame);
                buffer = biggerBuffer;
                tryAgain = true;
            }
        }
        return buffer;
    }
    catch (err) {
        throw new GifError(err);
    }
}
