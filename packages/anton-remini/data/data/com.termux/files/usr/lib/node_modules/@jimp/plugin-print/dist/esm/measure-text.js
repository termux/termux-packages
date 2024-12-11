export function measureText(font, text) {
    let x = 0;
    for (let i = 0; i < text.length; i++) {
        const char = text[i];
        const fontChar = font.chars[char];
        if (fontChar) {
            const fontKerning = font.kernings[char];
            const nextChar = text[i + 1];
            const kerning = fontKerning && nextChar && fontKerning[nextChar]
                ? fontKerning[nextChar] || 0
                : 0;
            x += (fontChar.xadvance || 0) + kerning;
        }
    }
    return x;
}
export function splitLines(font, text, maxWidth) {
    const words = text.replace(/[\r\n]+/g, " \n").split(" ");
    const lines = [];
    let currentLine = [];
    let longestLine = 0;
    words.forEach((word) => {
        const wordWidth = measureText(font, word + (words.length > 1 ? " " : ""));
        // If a word is longer than the allowable width we need to split it across lines.
        if (wordWidth > maxWidth) {
            const characterIterator = word[Symbol.iterator]();
            let current = "";
            for (const char of characterIterator) {
                const nextLine = [...currentLine, current + char].join(" ");
                const length = measureText(font, nextLine);
                if (length < maxWidth) {
                    current += char;
                }
                else if (length > maxWidth) {
                    lines.push([...currentLine, current]);
                    currentLine = [];
                    current = char;
                }
                else {
                    lines.push([...currentLine, current + char]);
                    currentLine = [];
                    current = "";
                }
            }
            return;
        }
        const line = [...currentLine, word].join(" ");
        const length = measureText(font, line);
        if (length <= maxWidth && !word.includes("\n")) {
            if (length > longestLine) {
                longestLine = length;
            }
            currentLine.push(word);
        }
        else {
            lines.push(currentLine);
            currentLine = [word.replace("\n", "")];
        }
    });
    lines.push(currentLine);
    return {
        lines,
        longestLine,
    };
}
export function measureTextHeight(font, text, maxWidth) {
    const { lines } = splitLines(font, text, maxWidth);
    return lines.length * font.common.lineHeight;
}
//# sourceMappingURL=measure-text.js.map