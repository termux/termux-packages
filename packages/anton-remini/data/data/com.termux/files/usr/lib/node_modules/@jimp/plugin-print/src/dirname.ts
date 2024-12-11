import { fileURLToPath } from "url";
import path from "path";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore Dual package
export const dirname = path.dirname(fileURLToPath(import.meta.url));
