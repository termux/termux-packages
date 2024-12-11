import shared from "@jimp/config-eslint/base.js";
export default [
  ...shared,
  {
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
    },
  },
];
