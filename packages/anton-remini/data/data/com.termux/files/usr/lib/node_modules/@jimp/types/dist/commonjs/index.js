"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.JimpClassSchema = exports.Edge = void 0;
const zod_1 = require("zod");
var Edge;
(function (Edge) {
    Edge[Edge["EXTEND"] = 1] = "EXTEND";
    Edge[Edge["WRAP"] = 2] = "WRAP";
    Edge[Edge["CROP"] = 3] = "CROP";
})(Edge || (exports.Edge = Edge = {}));
exports.JimpClassSchema = zod_1.z.object({
    bitmap: zod_1.z.object({
        data: zod_1.z.union([zod_1.z.instanceof(Buffer), zod_1.z.instanceof(Uint8Array)]),
        width: zod_1.z.number(),
        height: zod_1.z.number(),
    }),
});
//# sourceMappingURL=index.js.map