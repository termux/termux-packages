import { JimpClass } from "@jimp/types";
import { BlendMode } from "./constants.js";
export declare function composite<I extends JimpClass>(baseImage: I, src: I, x?: number, y?: number, options?: {
    mode?: BlendMode;
    opacitySource?: number;
    opacityDest?: number;
}): I;
//# sourceMappingURL=composite.d.ts.map