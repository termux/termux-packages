#!/usr/bin/env node
const { remini } = require('../lib/remini');
const fs = require('fs');
const path = require('path');

function showUsage() {
  console.log(`
Usage:
  anton-remini <input_file> <output_file>    - Enhance a local image file

Arguments:
  <input_file>     - Path to the local image file to be enhanced (e.g., input.jpg).
  <output_file>    - Path where the enhanced image will be saved (e.g., output.jpg).

Examples:
  anton-remini input.jpg output.jpg          - Enhance a local image 'input.jpg' and save as 'output.jpg'
`);
  process.exit(1);
}

async function processImage() {
  try {
    let image;

    if (inputFile) {
      if (!fs.existsSync(inputFile)) {
        console.error(`Error: Input file "${inputFile}" does not exist.`);
        showUsage();
      }
      image = fs.readFileSync(inputFile);
    } else {
      showUsage();
    }

    if (!outputFile) {
      const extname = path.extname(inputFile);
      const basename = path.basename(inputFile, extname);
      outputFile = `anton_output${extname}`;
    }

    let enhancedImage = await remini(image, 'enhance');
    fs.writeFileSync(outputFile, enhancedImage);
    console.log(`Image enhanced successfully! Saved as: ${outputFile}`);
  } catch (error) {
    console.error('Error processing image:', error);
  }
}

const inputFile = process.argv[2];
let outputFile = process.argv[3];

if (inputFile) {
  processImage();
} else {
  showUsage();
}