"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isWebWorker = void 0;
exports.loadBitmapFontData = loadBitmapFontData;
exports.processBitmapFont = processBitmapFont;
const parse_bmfont_ascii_1 = __importDefault(require("parse-bmfont-ascii"));
const parse_bmfont_xml_1 = __importDefault(require("parse-bmfont-xml"));
const parse_bmfont_binary_1 = __importDefault(require("parse-bmfont-binary"));
const js_png_1 = __importDefault(require("@jimp/js-png"));
const core_1 = require("@jimp/core");
const path_1 = __importDefault(require("path"));
const simple_xml_to_json_1 = __importDefault(require("simple-xml-to-json"));
const { convertXML } = simple_xml_to_json_1.default;
exports.isWebWorker = typeof self !== "undefined" && self.document === undefined;
const CharacterJimp = (0, core_1.createJimp)({ formats: [js_png_1.default] });
const HEADER = Buffer.from([66, 77, 70, 3]);
function isBinary(buf) {
    if (typeof buf === "string") {
        return buf.substring(0, 3) === "BMF";
    }
    const startOfHeader = buf.slice(0, 4);
    return (buf.length > 4 &&
        startOfHeader[0] === HEADER[0] &&
        startOfHeader[1] === HEADER[1] &&
        startOfHeader[2] === HEADER[2]);
}
function parseFont(file, data) {
    if (isBinary(data)) {
        if (typeof data === "string") {
            data = Buffer.from(data, "binary");
        }
        return (0, parse_bmfont_binary_1.default)(data);
    }
    data = data.toString().trim();
    if (/.json$/.test(file) || data.charAt(0) === "{") {
        return JSON.parse(data);
    }
    if (/.xml$/.test(file) || data.charAt(0) === "<") {
        return (0, parse_bmfont_xml_1.default)(data);
    }
    return (0, parse_bmfont_ascii_1.default)(data);
}
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function parseNumbersInObject(obj) {
    for (const key in obj) {
        try {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            obj[key] = parseInt(obj[key], 10);
        }
        catch {
            // do nothing
        }
        if (typeof obj[key] === "object") {
            parseNumbersInObject(obj[key]);
        }
    }
    return obj;
}
/**
 *
 * @param bufferOrUrl A URL to a file or a buffer
 * @returns
 */
async function loadBitmapFontData(bufferOrUrl) {
    if (exports.isWebWorker && typeof bufferOrUrl === "string") {
        const res = await fetch(bufferOrUrl);
        const text = await res.text();
        const json = convertXML(text);
        const font = json.font.children.reduce(
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (acc, i) => ({ ...acc, ...i }), {});
        const pages = [];
        const chars = [];
        const kernings = [];
        for (let i = 0; i < font.pages.children.length; i++) {
            const p = font.pages.children[i].page;
            const id = parseInt(p.id, 10);
            pages[id] = parseNumbersInObject(p.file);
        }
        for (let i = 0; i < font.chars.children.length; i++) {
            chars.push(parseNumbersInObject(font.chars.children[i].char));
        }
        for (let i = 0; i < font.kernings.children.length; i++) {
            kernings.push(parseNumbersInObject(font.kernings.children[i].kerning));
        }
        return {
            info: font.info,
            common: font.common,
            pages,
            chars,
            kernings,
        };
    }
    else if (typeof bufferOrUrl === "string") {
        const res = await fetch(bufferOrUrl);
        const text = await res.text();
        return parseFont(bufferOrUrl, text);
    }
    else {
        return parseFont("", bufferOrUrl);
    }
}
async function processBitmapFont(file, font) {
    const chars = {};
    const kernings = {};
    for (let i = 0; i < font.chars.length; i++) {
        const char = font.chars[i];
        chars[String.fromCharCode(char.id)] = char;
    }
    for (let i = 0; i < font.kernings.length; i++) {
        const firstString = String.fromCharCode(font.kernings[i].first);
        kernings[firstString] = kernings[firstString] || {};
        kernings[firstString][String.fromCharCode(font.kernings[i].second)] =
            font.kernings[i].amount;
    }
    return {
        ...font,
        chars,
        kernings,
        pages: await Promise.all(font.pages.map(async (page) => CharacterJimp.read(path_1.default.join(path_1.default.dirname(file), page)))),
    };
}
//# sourceMappingURL=load-bitmap-font.js.map