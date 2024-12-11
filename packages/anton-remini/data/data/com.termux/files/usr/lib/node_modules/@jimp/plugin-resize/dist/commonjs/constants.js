"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResizeStrategy = void 0;
/**
 * What resizing algorithm to use.
 */
var ResizeStrategy;
(function (ResizeStrategy) {
    /**
     * Nearest Neighbor resizing is a method used in image processing that assigns the value of the nearest pixel to the output pixel when resizing an image.
     * While fast, it can lead to lower quality outputs with noticeable pixelation, especially at larger scaling factors.
     */
    ResizeStrategy["NEAREST_NEIGHBOR"] = "nearestNeighbor";
    /**
     * Bilinear resizing is an image scaling method that uses the weighted average of the four nearest pixel values, providing smoother gradients than nearest neighbor resizing.
     * It's computationally more intense than nearest neighbor but results in images of higher quality and fewer artifacts.
     */
    ResizeStrategy["BILINEAR"] = "bilinearInterpolation";
    /**
     * Bicubic resizing is an image interpolation method that uses the values of the nearest 16 pixels in the input image to calculate the output pixel value, providing even more smoothness and sharpness than bilinear resizing.
     * Although it's computationally more expensive than bilinear and nearest neighbor, it produces higher quality images, making it ideal for photographic image scaling.
     */
    ResizeStrategy["BICUBIC"] = "bicubicInterpolation";
    /**
     * Hermite resizing is an image resizing method that uses Hermite interpolation, a mathematical formula, to determine the values of output pixels based on a weighted average of the surrounding pixels.
     * Although slower than some simpler techniques like bilinear or nearest neighbor, Hermite resizing can produce higher quality visuals and detailed renderings with less blurring.
     */
    ResizeStrategy["HERMITE"] = "hermiteInterpolation";
    ResizeStrategy["BEZIER"] = "bezierInterpolation";
})(ResizeStrategy || (exports.ResizeStrategy = ResizeStrategy = {}));
//# sourceMappingURL=constants.js.map