
export interface GifSpec {

    loops?: number;
    colorScope?: 0|1|2;
}

export interface GifEncoder {
    encodeGif(frames: GifFrame[], spec: GifSpec): Promise<Gif>;
}

export interface GifDecoder {
    decodeGif(buffer: Buffer): Promise<Gif>;
}

export class Gif implements GifSpec {

    static readonly GlobalColorsPreferred: 0;
    static readonly GlobalColorsOnly: 1;
    static readonly LocalColorsOnly: 2;

    width: number;
    height: number;
    loops: number;
    usesTransparency: boolean;
    colorScope: 0|1|2;
    
    frames: GifFrame[];
    buffer: Buffer;

    constructor(frames: GifFrame[], buffer: Buffer, spec?: GifSpec);
}

export interface GifFrameOptions {
    xOffset?: number;
    yOffset?: number;
    disposalMethod?: 0|1|2|3;
    delayCentisecs?: number;
    isInterlaced?: boolean;
}

export interface JimpBitmap {
    width: number;
    height: number;
    data: Buffer;
}

export interface GifPalette {
    colors: number[];
    indexCount: number;
    usesTransparency: boolean;
}

export class BitmapImage {
    bitmap: JimpBitmap;

    constructor(bitmap: JimpBitmap);
    constructor(bitmapImage: BitmapImage);
    constructor(width: number, height: number, buffer: Buffer);
    constructor(width: number, height: number, backgroundRGBA?: number);
    
    blit(toImage: BitmapImage, toX: number, toY: number, fromX: number, fromY: number,
            fromWidth: number, fromHeight: number): this;
    fillRGBA(color: number): this;
    getRGBA(x: number, y: number): number;
    getRGBASet(): Set<number>;
    greyscale(): this;
    reframe(xOffset: number, yOffset: number, width: number, height: number, fillRGBA?: number)
        : this;
    scale(factor: number): this;
    scanAllCoords(handler: (x: number, y: number, bufferIndex: number) => void): void;
    scanAllIndexes(handler: (bufferIndex: number) => void): void;
}

export class GifFrame extends BitmapImage implements GifFrameOptions {

    static readonly DisposeToAnything: 0;
    static readonly DisposeNothing: 1;
    static readonly DisposeToBackgroundColor: 2;
    static readonly DisposeToPrevious: 3;

    xOffset: number;
    yOffset: number;
    disposalMethod: 0|1|2|3;
    delayCentisecs: number;
    interlaced: boolean;

    constructor(bitmap: JimpBitmap, options?: GifFrameOptions);
    constructor(bitmapImage: BitmapImage, options?: GifFrameOptions);
    constructor(width: number, height: number, buffer: Buffer, options?: GifFrameOptions);
    constructor(width: number, height: number, backgroundRGBA?: number, options?: GifFrameOptions);
    constructor(frame: GifFrame);

    getPalette(): GifPalette;
}

export interface GifCodecOptions {
    transparentRGB?: number;
}

export class GifCodec implements GifEncoder, GifDecoder {

    constructor(options?: GifCodecOptions);

    encodeGif(frames: GifFrame[], spec: GifSpec): Promise<Gif>;
    decodeGif(buffer: Buffer): Promise<Gif>;
}

export class GifError extends Error {

    constructor(message: string);
}

export namespace GifUtil {

    function cloneFrames(frames: GifFrame[]): GifFrame[];
    function copyAsJimp(jimp: any, bitmapImageToCopy: BitmapImage): any;
    function getColorInfo(frames: GifFrame[], maxGlobalIndex?: number): {
        colors?: number[],
        indexCount?: number,
        usesTransparency: boolean,
        palettes: GifPalette[]
    }
    function getMaxDimensions(frames: GifFrame[]): { maxWidth: number, maxHeight: number };
    function quantizeDekker(imageOrImages: BitmapImage|BitmapImage[], maxColorIndexes: number,
            dither?: Dither): void;
    function quantizeSorokin(imageOrImages: BitmapImage|BitmapImage[], maxColorIndexes: number,
            histogram?: string, dither?: Dither): void;
    function quantizeWu(imageOrImages: BitmapImage|BitmapImage[], maxColorIndexes: number,
            significantBits?: number, dither?: Dither): void;
    function read(source: string|Buffer, decoder?: GifDecoder): Promise<Gif>;
    function shareAsJimp(jimp: any, bitmapImageToCopy: BitmapImage): any;
    function write(path: string, frames: GifFrame[], spec?: GifSpec, encoder?: GifEncoder):
            Promise<Gif>;
}

export type DitherAlgorithm = 
    'FloydSteinberg' |
    'FalseFloydSteinberg' |
    'Stucki' |
    'Atkinson' |
    'Jarvis' |
    'Burkes' |
    'Sierra' |
    'TwoSierra' |
    'SierraLite';

export type Dither = {
    ditherAlgorithm: DitherAlgorithm,
    minimumColorDistanceToDither?: number, // default = 0
    serpentine?: boolean, // default = true
    calculateErrorLikeGIMP?: boolean // default = false
};
