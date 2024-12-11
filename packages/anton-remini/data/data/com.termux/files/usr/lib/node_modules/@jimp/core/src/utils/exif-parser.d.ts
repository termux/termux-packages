declare module "exif-parser" {
  export interface ExifData {
    tags?: {
      Orientation?: number;
    };
  }

  function create(data: Buffer): {
    parse: () => ExifData;
  };

  export { create };
}
