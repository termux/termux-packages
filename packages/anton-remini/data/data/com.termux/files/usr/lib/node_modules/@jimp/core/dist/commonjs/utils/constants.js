"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BlendMode = exports.VerticalAlign = exports.HorizontalAlign = void 0;
/* Horizontal align modes for cover, contain, bit masks */
var HorizontalAlign;
(function (HorizontalAlign) {
    HorizontalAlign[HorizontalAlign["LEFT"] = 1] = "LEFT";
    HorizontalAlign[HorizontalAlign["CENTER"] = 2] = "CENTER";
    HorizontalAlign[HorizontalAlign["RIGHT"] = 4] = "RIGHT";
})(HorizontalAlign || (exports.HorizontalAlign = HorizontalAlign = {}));
/* Vertical align modes for cover, contain, bit masks */
var VerticalAlign;
(function (VerticalAlign) {
    VerticalAlign[VerticalAlign["TOP"] = 8] = "TOP";
    VerticalAlign[VerticalAlign["MIDDLE"] = 16] = "MIDDLE";
    VerticalAlign[VerticalAlign["BOTTOM"] = 32] = "BOTTOM";
})(VerticalAlign || (exports.VerticalAlign = VerticalAlign = {}));
/**
 * How to blend two images together
 */
var BlendMode;
(function (BlendMode) {
    /**
     * Composite the source image over the destination image.
     * This is the default value. It represents the most intuitive case, where shapes are painted on top of what is below, with transparent areas showing the destination layer.
     */
    BlendMode["SRC_OVER"] = "srcOver";
    /** Composite the source image under the destination image. */
    BlendMode["DST_OVER"] = "dstOver";
    /**
     * Multiply the color components of the source and destination images.
     * This can only result in the same or darker colors (multiplying by white, 1.0, results in no change; multiplying by black, 0.0, results in black).
     * When compositing two opaque images, this has similar effect to overlapping two transparencies on a projector.
     *
     * This mode is useful for coloring shadows.
     */
    BlendMode["MULTIPLY"] = "multiply";
    /**
     * The Add mode adds the color information of the base layers and the blending layer.
     * In digital terms, adding color increases the brightness.
     */
    BlendMode["ADD"] = "add";
    /**
     * Multiply the inverse of the components of the source and destination images, and inverse the result.
     * Inverting the components means that a fully saturated channel (opaque white) is treated as the value 0.0, and values normally treated as 0.0 (black, transparent) are treated as 1.0.
     * This is essentially the same as modulate blend mode, but with the values of the colors inverted before the multiplication and the result being inverted back before rendering.
     * This can only result in the same or lighter colors (multiplying by black, 1.0, results in no change; multiplying by white, 0.0, results in white). Similarly, in the alpha channel, it can only result in more opaque colors.
     * This has similar effect to two projectors displaying their images on the same screen simultaneously.
     */
    BlendMode["SCREEN"] = "screen";
    /**
     * Multiply the components of the source and destination images after adjusting them to favor the destination.
     * Specifically, if the destination value is smaller, this multiplies it with the source value, whereas is the source value is smaller, it multiplies the inverse of the source value with the inverse of the destination value, then inverts the result.
     * Inverting the components means that a fully saturated channel (opaque white) is treated as the value 0.0, and values normally treated as 0.0 (black, transparent) are treated as 1.0.
     *
     * The Overlay mode behaves like Screen mode in bright areas, and like Multiply mode in darker areas.
     * With this mode, the bright areas will look brighter and the dark areas will look darker.
     */
    BlendMode["OVERLAY"] = "overlay";
    /**
     * Composite the source and destination image by choosing the lowest value from each color channel.
     * The opacity of the output image is computed in the same way as for srcOver.
     */
    BlendMode["DARKEN"] = "darken";
    /**
     * Composite the source and destination image by choosing the highest value from each color channel.
     * The opacity of the output image is computed in the same way as for srcOver.
     */
    BlendMode["LIGHTEN"] = "lighten";
    /**
     * Multiply the components of the source and destination images after adjusting them to favor the source.
     * Specifically, if the source value is smaller, this multiplies it with the destination value, whereas is the destination value is smaller, it multiplies the inverse of the destination value with the inverse of the source value, then inverts the result.
     * Inverting the components means that a fully saturated channel (opaque white) is treated as the value 0.0, and values normally treated as 0.0 (black, transparent) are treated as 1.0.
     *
     * The effect of the Hard light mode depends on the density of the superimposed color. Using bright colors on the blending layer will create a brighter effect like the Screen modes, while dark colors will create darker colors like the Multiply mode.
     */
    BlendMode["HARD_LIGHT"] = "hardLight";
    /**
     * Subtract the smaller value from the bigger value for each channel.
     * Compositing black has no effect; compositing white inverts the colors of the other image.
     * The opacity of the output image is computed in the same way as for srcOver.
     * The effect is similar to exclusion but harsher.
     */
    BlendMode["DIFFERENCE"] = "difference";
    /**
     * Subtract double the product of the two images from the sum of the two images.
     * Compositing black has no effect; compositing white inverts the colors of the other image.
     * The opacity of the output image is computed in the same way as for srcOver.
     * The effect is similar to difference but softer.
     */
    BlendMode["EXCLUSION"] = "exclusion";
})(BlendMode || (exports.BlendMode = BlendMode = {}));
//# sourceMappingURL=constants.js.map