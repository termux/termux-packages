/**
 * Filter method is a single-byte integer that indicates the preprocessing method applied to the image data before compression.
 */
export enum PNGFilterType {
  AUTO = -1,
  /** scanline is transmitted unmodified */
  NONE = 0,
  /** filter transmits the difference between each byte and the value of the corresponding byte of the prior pixel */
  SUB = 1,
  /** The Up() filter is just like the Sub() filter except that the pixel immediately above the current pixel, rather than just to its left, is used as the predictor. */
  UP = 2,
  /** uses the average of the two neighboring pixels (left and above) to predict the value of a pixel */
  AVERAGE = 3,
  /** computes a simple linear function of the three neighboring pixels (left, above, upper left), then chooses as predictor the neighboring pixel closest to the computed value. */
  PATH = 4,
}

/**
 * Color type is a single-byte integer that describes the interpretation of the image data.
 * Color type codes represent sums of the following values:
 *
 * 1 (palette used), 2 (color used), and 4 (alpha channel used).
 */
export enum PNGColorType {
  GRAYSCALE = 0,
  COLOR = 2,
  GRAYSCALE_ALPHA = 4,
  COLOR_ALPHA = 6,
}
