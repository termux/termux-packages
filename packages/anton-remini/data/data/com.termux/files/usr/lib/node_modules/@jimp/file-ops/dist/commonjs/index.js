"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.writeFile = exports.readFile = exports.existsSync = void 0;
const fs_1 = require("fs");
var fs_2 = require("fs");
Object.defineProperty(exports, "existsSync", { enumerable: true, get: function () { return fs_2.existsSync; } });
exports.readFile = fs_1.promises.readFile;
exports.writeFile = fs_1.promises.writeFile;
//# sourceMappingURL=index.js.map