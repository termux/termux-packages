"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.composite = composite;
const types_1 = require("@jimp/types");
const constants_js_1 = require("./constants.js");
const compositeModes = __importStar(require("./composite-modes.js"));
const utils_1 = require("@jimp/utils");
function composite(baseImage, src, x = 0, y = 0, options = {}) {
    if (!(src instanceof baseImage.constructor)) {
        throw new Error("The source must be a Jimp image");
    }
    if (typeof x !== "number" || typeof y !== "number") {
        throw new Error("x and y must be numbers");
    }
    const { mode = constants_js_1.BlendMode.SRC_OVER } = options;
    let { opacitySource = 1.0, opacityDest = 1.0 } = options;
    if (typeof opacitySource !== "number" ||
        opacitySource < 0 ||
        opacitySource > 1) {
        opacitySource = 1.0;
    }
    if (typeof opacityDest !== "number" || opacityDest < 0 || opacityDest > 1) {
        opacityDest = 1.0;
    }
    const blendmode = compositeModes[mode];
    // round input
    x = Math.round(x);
    y = Math.round(y);
    if (opacityDest !== 1.0) {
        baseImage.scan((_, __, idx) => {
            const v = baseImage.bitmap.data[idx + 3] * opacityDest;
            baseImage.bitmap.data[idx + 3] = v;
        });
    }
    src.scan((sx, sy, idx) => {
        const dstIdx = baseImage.getPixelIndex(x + sx, y + sy, types_1.Edge.CROP);
        if (dstIdx === -1) {
            // Skip target pixels outside of dst
            return;
        }
        const blended = blendmode({
            r: src.bitmap.data[idx + 0] / 255,
            g: src.bitmap.data[idx + 1] / 255,
            b: src.bitmap.data[idx + 2] / 255,
            a: src.bitmap.data[idx + 3] / 255,
        }, {
            r: baseImage.bitmap.data[dstIdx + 0] / 255,
            g: baseImage.bitmap.data[dstIdx + 1] / 255,
            b: baseImage.bitmap.data[dstIdx + 2] / 255,
            a: baseImage.bitmap.data[dstIdx + 3] / 255,
        }, opacitySource);
        baseImage.bitmap.data[dstIdx + 0] = (0, utils_1.limit255)(blended.r * 255);
        baseImage.bitmap.data[dstIdx + 1] = (0, utils_1.limit255)(blended.g * 255);
        baseImage.bitmap.data[dstIdx + 2] = (0, utils_1.limit255)(blended.b * 255);
        baseImage.bitmap.data[dstIdx + 3] = (0, utils_1.limit255)(blended.a * 255);
    });
    return baseImage;
}
//# sourceMappingURL=composite.js.map