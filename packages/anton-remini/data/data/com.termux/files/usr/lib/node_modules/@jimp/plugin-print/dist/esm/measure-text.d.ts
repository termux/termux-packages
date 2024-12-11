import { BmFont } from "./types.js";
export declare function measureText(font: BmFont, text: string): number;
export declare function splitLines(font: BmFont, text: string, maxWidth: number): {
    lines: string[][];
    longestLine: number;
};
export declare function measureTextHeight(font: BmFont, text: string, maxWidth: number): number;
//# sourceMappingURL=measure-text.d.ts.map