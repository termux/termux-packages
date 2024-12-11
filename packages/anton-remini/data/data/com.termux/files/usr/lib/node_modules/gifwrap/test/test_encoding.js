'use strict';

const assert = require('chai').assert;
const Tools = require('./lib/tools');
const { Gif, GifFrame, GifCodec, GifUtil, GifError } = require('../src/index');

// compare decoded encodings with decodings intead of comparing buffers, because there are many ways to encode the same data

const defaultCodec = new GifCodec();

describe("single-frame encoding", () => {

    it("encodes an opaque monochrome GIF", () => {

        const name = 'singleFrameMonoOpaque';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a transparent GIF", () => {

        const name = 'singleFrameNoColorTrans';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a monochrome GIF with transparency", () => {

        const name = 'singleFrameMonoTrans';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a opaque two-color GIF", () => {

        const name = 'singleFrameBWOpaque';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a opaque multi-color GIF", () => {

        const name = 'singleFrameMultiOpaque';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a 4-color GIF w/ transparency", () => {

        const name = 'singleFrameMultiTrans';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly); // simple code 1st
        // .then(() => {
        //     return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        // });
    });
});

describe("multi-frame encoding", () => {

    it("encodes a 2-frame multi-color opaque GIF", () => {

        const name = 'twoFrameMultiOpaque';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a 3-frame monocolor GIF with transparency", () => {

        const name = 'threeFrameMonoTrans';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a large multiframe file w/out transparency", () => {

        const name = 'nburling-public';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes a large multiframe file w/ offsets, w/out transparency", () => {

        const name = 'rnaples-offsets-public';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly) // simple code 1st
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly);
        });
    });

    it("encodes large multiframe files w/ forced buffer-size scaling (1)", () => {

        const scalingCodec = new GifCodec();
        scalingCodec._testInitialBufferSize = 2048; // big enough for header
        const name = 'nburling-public';

        return _encodeDecodeFile(name, Gif.LocalColorsOnly, scalingCodec)
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly, scalingCodec);
        });
    });

    it("encodes large multiframe files w/ forced buffer-size scaling (2)", () => {

        const scalingCodec = new GifCodec();
        scalingCodec._testInitialBufferSize = 2048; // big enough for header

        const name = 'rnaples-offsets-public';
        return _encodeDecodeFile(name, Gif.LocalColorsOnly, scalingCodec)
        .then(() => {
            return _encodeDecodeFile(name, Gif.GlobalColorsOnly, scalingCodec);
        });
    });
});

describe("encoding GlobalColorsPreferred", () => {

    it("uses a global color table when 256 colors in 1 frame", () => {

        const frames = [];
        const options = { colorScope: Gif.GlobalColorsPreferred };
        
        frames.push(_get256ColorFrame());

        return defaultCodec.encodeGif(frames, options)
        .then(encodedGif => {

            options.colorScope = Gif.GlobalColorsOnly;
            return defaultCodec.encodeGif(frames, options);
        })
        .then(encodedGif => {

            assert(true);
        })
    });

    it("uses a global color table when 256 colors in each of 2 frames", () => {

        const frames = [];
        const options = { colorScope: Gif.GlobalColorsPreferred };
        
        frames.push(_get256ColorFrame());
        frames.push(_get256ColorFrame());

        return defaultCodec.encodeGif(frames, options)
        .then(encodedGif => {

            options.colorScope = Gif.GlobalColorsOnly;
            return defaultCodec.encodeGif(frames, options);
        })
        .then(encodedGif => {

            assert(true);
        })
    });

    it("uses a global color table when 255 colors + transparency in each of 2 frames", () => {

        const frames = [];
        const options = { colorScope: Gif.GlobalColorsPreferred };
        
        frames.push(_get256ColorFrame());
        frames[0].bitmap.data[3] = 0;
        frames.push(_get256ColorFrame());
        frames[1].bitmap.data[3] = 0;

        return defaultCodec.encodeGif(frames, options)
        .then(encodedGif => {

            options.colorScope = Gif.GlobalColorsOnly;
            return defaultCodec.encodeGif(frames, options);
        })
        .then(encodedGif => {

            assert(true);
        })
    });

    it("uses a local color table when there are 257 opaque colors", () => {

        const frames = [];
        const options = { colorScope: Gif.GlobalColorsPreferred };
        
        frames.push(_get256ColorFrame());
        // put a 257th opaque color in the second frame
        let buf = new Buffer(256 * 4); // defaults to zeroes
        buf[0] = 0; buf[1] = 2; buf[2] = 3; buf[3] = 255;
        frames.push(new GifFrame(16, 16, buf));

        return defaultCodec.encodeGif(frames, options)
        .then(encodedGif => {

            options.colorScope = Gif.GlobalColorsOnly;
            return defaultCodec.encodeGif(frames, options);
        })
        .then(encodedGif => {

            assert.fail("should not encode");
        })
        .catch(err => {

            if (!(err instanceof GifError)) {
                throw err;
            }
            assert.strictEqual(err.message,
                    "Too many color indexes for global color table");
        });
    });

    it("uses a local color table when there are 256 opaque colors + transparency", () => {

        const frames = [];
        const options = { colorScope: Gif.GlobalColorsPreferred };
        
        frames.push(_get256ColorFrame());
        frames.push(_get256ColorFrame());
        frames[1].bitmap.data[3] = 0;

        return defaultCodec.encodeGif(frames, options)
        .then(encodedGif => {

            options.colorScope = Gif.GlobalColorsOnly;
            return defaultCodec.encodeGif(frames, options);
        })
        .then(encodedGif => {

            assert.fail("should not encode");
        })
        .catch(err => {

            if (!(err instanceof GifError)) {
                throw err;
            }
            assert.strictEqual(err.message,
                    "Too many color indexes for global color table");
        });
    });

});

function _compareGifs(actual, expected, filename, note) {
    note = `file '${filename}' (${note})`;
    assert.strictEqual(actual.width, expected.width, note);
    assert.strictEqual(actual.height, expected.height, note);
    assert.strictEqual(actual.loops, expected.loops, note);
    assert.strictEqual(actual.usesTransparency, expected.usesTransparency,
            note);

    assert(Buffer.isBuffer(actual.buffer), note); 
    assert(Array.isArray(actual.frames));
    assert.strictEqual(actual.frames.length, expected.frames.length);
    note = ` in ${note}`;
    for (let i = 0; i < actual.frames.length; ++i) {
        const actualFrame = actual.frames[i];
        const expectedFrame = expected.frames[i];
        Tools.verifyFrameInfo(actualFrame, expectedFrame, i, note);
    }
}

function _encodeDecodeFile(filename, colorScope, codec) {
    let expectedGif;
    codec = codec || defaultCodec;

    return GifUtil.read(Tools.getGifPath(filename), codec)
    .then(readGif => {

        expectedGif = readGif;
        return codec.encodeGif(readGif.frames, 
                { loops: readGif.loops, colorScope: colorScope });
    })
    .then(encodedGif => {

        _compareGifs(encodedGif, expectedGif, filename,
                `encoded == read (colorScope ${colorScope})`);
        return codec.decodeGif(encodedGif.buffer);
    })
    .then(decodedGif => {
    
        _compareGifs(decodedGif, expectedGif, filename,
                `decoded == read (colorScope ${colorScope})`);
    })
}

function _get256ColorFrame() {
    let buf = new Buffer(256 * 4);
    for (let i = 0; i < 256; ++i) {
        const offset = i * 4;
        buf[offset + 2] = buf[offset + 1] = buf[offset] = i;
        buf[offset + 3] = 255;
    }
    return new GifFrame(16, 16, buf);
}
