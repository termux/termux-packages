import { z } from "zod";
export var Edge;
(function (Edge) {
    Edge[Edge["EXTEND"] = 1] = "EXTEND";
    Edge[Edge["WRAP"] = 2] = "WRAP";
    Edge[Edge["CROP"] = 3] = "CROP";
})(Edge || (Edge = {}));
export const JimpClassSchema = z.object({
    bitmap: z.object({
        data: z.union([z.instanceof(Buffer), z.instanceof(Uint8Array)]),
        width: z.number(),
        height: z.number(),
    }),
});
//# sourceMappingURL=index.js.map