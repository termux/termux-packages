import { promises as fs } from "fs";

export { existsSync } from "fs";
export const readFile = fs.readFile;
export const writeFile = fs.writeFile;
