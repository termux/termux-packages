import { RGBAColor } from "@jimp/types";
export declare function srcOver(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function dstOver(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function multiply(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function add(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function screen(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function overlay(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function darken(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function lighten(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function hardLight(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function difference(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare function exclusion(src: RGBAColor, dst: RGBAColor, ops?: number): {
    r: number;
    g: number;
    b: number;
    a: number;
};
export declare const names: readonly [typeof srcOver, typeof dstOver, typeof multiply, typeof add, typeof screen, typeof overlay, typeof darken, typeof lighten, typeof hardLight, typeof difference, typeof exclusion];
export type CompositeMode = (typeof names)[number];
//# sourceMappingURL=composite-modes.d.ts.map