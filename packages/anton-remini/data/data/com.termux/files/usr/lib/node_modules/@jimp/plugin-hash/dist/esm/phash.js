/*
Copyright (c) 2011 Elliot Shepherd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
import { methods as color } from "@jimp/plugin-color";
import { methods } from "@jimp/plugin-resize";
import { clone } from "@jimp/utils";
// https://code.google.com/p/ironchef-team21/source/browse/ironchef_team21/src/ImagePHash.java
/*
 * pHash-like image hash.
 * Author: Elliot Shepherd (elliot@jarofworms.com
 * Based On: http://www.hackerfactor.com/blog/index.php?/archives/432-Looks-Like-It.html
 */
class ImagePHash {
    size;
    smallerSize;
    constructor(size, smallerSize) {
        this.size = size || 32;
        this.smallerSize = smallerSize || 8;
        initCoefficients(this.size);
    }
    distance(s1, s2) {
        let counter = 0;
        for (let k = 0; k < s1.length; k++) {
            if (s1[k] !== s2[k]) {
                counter++;
            }
        }
        return counter / s1.length;
    }
    /**
     * Returns a 'binary string' (like. 001010111011100010) which is easy to do a hamming distance on.
     */
    getHash(img) {
        /* 1. Reduce size.
         * Like Average Hash, pHash starts with a small image.
         * However, the image is larger than 8x8; 32x32 is a good size.
         * This is really done to simplify the DCT computation and not
         * because it is needed to reduce the high frequencies.
         */
        img = methods.resize(clone(img), { w: this.size, h: this.size });
        /* 2. Reduce color.
         * The image is reduced to a grayscale just to further simplify
         * the number of computations.
         */
        img = color.greyscale(img);
        const vals = [];
        for (let x = 0; x < img.bitmap.width; x++) {
            const row = [];
            for (let y = 0; y < img.bitmap.height; y++) {
                row[y] = intToRGBA(img.getPixelColor(x, y)).b;
            }
            vals[x] = row;
        }
        /* 3. Compute the DCT.
         * The DCT separates the image into a collection of frequencies
         * and scalars. While JPEG uses an 8x8 DCT, this algorithm uses
         * a 32x32 DCT.
         */
        const dctVals = applyDCT(vals, this.size);
        /* 4. Reduce the DCT.
         * This is the magic step. While the DCT is 32x32, just keep the
         * top-left 8x8. Those represent the lowest frequencies in the
         * picture.
         */
        /* 5. Compute the average value.
         * Like the Average Hash, compute the mean DCT value (using only
         * the 8x8 DCT low-frequency values and excluding the first term
         * since the DC coefficient can be significantly different from
         * the other values and will throw off the average).
         */
        let total = 0;
        for (let x = 0; x < this.smallerSize; x++) {
            for (let y = 0; y < this.smallerSize; y++) {
                total += dctVals[x][y];
            }
        }
        const avg = total / (this.smallerSize * this.smallerSize);
        /* 6. Further reduce the DCT.
         * This is the magic step. Set the 64 hash bits to 0 or 1
         * depending on whether each of the 64 DCT values is above or
         * below the average value. The result doesn't tell us the
         * actual low frequencies; it just tells us the very-rough
         * relative scale of the frequencies to the mean. The result
         * will not vary as long as the overall structure of the image
         * remains the same; this can survive gamma and color histogram
         * adjustments without a problem.
         */
        let hash = "";
        for (let x = 0; x < this.smallerSize; x++) {
            for (let y = 0; y < this.smallerSize; y++) {
                hash += dctVals[x][y] > avg ? "1" : "0";
            }
        }
        return hash;
    }
}
// DCT function stolen from http://stackoverflow.com/questions/4240490/problems-with-dct-and-idct-algorithm-in-java
/**
 Convert a 32-bit integer color value to an RGBA object.
 */
function intToRGBA(i) {
    const a = i & 0xff;
    i >>>= 8;
    const b = i & 0xff;
    i >>>= 8;
    const g = i & 0xff;
    i >>>= 8;
    const r = i & 0xff;
    return { r, g, b, a };
}
const c = [];
function initCoefficients(size) {
    for (let i = 1; i < size; i++) {
        c[i] = 1;
    }
    c[0] = 1 / Math.sqrt(2.0);
}
function applyDCT(f, size) {
    const N = size;
    const F = [];
    for (let u = 0; u < N; u++) {
        const row = [];
        for (let v = 0; v < N; v++) {
            let sum = 0;
            for (let i = 0; i < N; i++) {
                for (let j = 0; j < N; j++) {
                    sum +=
                        Math.cos(((2 * i + 1) / (2.0 * N)) * u * Math.PI) *
                            Math.cos(((2 * j + 1) / (2.0 * N)) * v * Math.PI) *
                            f[i][j];
                }
            }
            sum *= (c[u] * c[v]) / 4;
            row[v] = sum;
            F[u] = row;
        }
    }
    return F;
}
export default ImagePHash;
//# sourceMappingURL=phash.js.map