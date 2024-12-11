'use strict';

const BitmapImage = require('./bitmapimage');
const { Gif, GifError } = require('./gif');
const { GifCodec } = require('./gifcodec');
const { GifFrame } = require('./gifframe');
const GifUtil = require('./gifutil');

module.exports = {
    BitmapImage,
    Gif,
    GifCodec,
    GifFrame,
    GifUtil,
    GifError
};
