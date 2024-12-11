import { JimpClass } from "@jimp/types";

export interface BmCharacter {
  id: number;
  xadvance: number;
  width: number;
  height: number;
  xoffset: number;
  yoffset: number;
  page: number;
  x: number;
  y: number;
}

export interface BmKerning {
  [secondString: string]: number;
  first: number;
  second: number;
  amount: number;
}

export interface BmCommonProps {
  lineHeight: number;
}

export interface BmFont<T extends JimpClass = JimpClass> {
  chars: Record<string, BmCharacter>;
  kernings: Record<string, BmKerning>;
  common: BmCommonProps;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  info: Record<string, any>;
  pages: T[];
}
