
export type ByteArray = Uint8Array | Buffer;

export interface OmggifModule {
    GifWriter: GifWriter;
    GifReader: GifReader;
}

export interface GlobalOptions {
    loop?: number; // 0 = unending loop; n > 0 = (n+1) iterations; null = once
    palette?: number[]; // global palette RGB by color index
    background?: number; // background index; most browsers may ignore this
}

export interface FrameOptions {
    palette?: number[]; // RGB by color index
    delay?: number; // duation in 100s of a second
    disposal?: number; // what to do with background color (0-3)
    transparent?: number; // transparency index
}

export interface GifWriter {
    new (buffer: ByteArray, width: number, height: number, gopts?: GlobalOptions): GifWriter;
    addFrame(x: number, y: number, width: number, height: number, indexedPixels: number[], opts?: FrameOptions): number; // returns size of buffer at end of frame
    getOutputBuffer(): ByteArray;
    setOutputBuffer(buffer: ByteArray): void;
    getOutputBufferPosition(): number;
    setOutputBufferPosition(position: number): void;
    end(): number; // ends GIF and returns size of buffer
}

export interface GifReader {
    width: number;
    height: number;
    new (buffer: ByteArray): GifReader;
    numFrames(): number;
    loopCount(): number;
    frameInfo(frameNumber: number): FrameInfo;
    decodeAndBlitFrameBGRA(frameNumber: number, pixels: number[]): void;
    decodeAndBlitFrameRGBA(frameNumber: number, pixels: number[]): void;
}

export interface FrameInfo {
    x: number;
    y: number;
    width: number;
    height: number;
    has_local_palette: boolean;
    palette_offset: number;
    data_offset: number;
    data_length: number;
    transparent_index: number;
    interlaced: boolean;
    delay: number; // 100ths of a second
    disposal: number;
}
