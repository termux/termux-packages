📄 README.md

# jsonviewer

`jsonviewer` is an interactive JSON tree viewer for Termux. It displays JSON files as expandable and collapsible trees directly in your terminal.

## Features
- Expand and collapse JSON objects and arrays with arrow keys
- Supports both file input and stdin
- Clean tree structure with ◂ (collapsed), ▾ (expanded), and • (leaf values)
- Lightweight, powered by Python and [Textual](https://github.com/Textualize/textual)

## Installation
First install dependencies:
```bash
pip install rich textual

Clone the repository and install:

git clone https://github.com/X-sella/jsonviewer.git
cd jsonviewer
chmod +x src/jsonviewer
cp src/jsonviewer $PREFIX/bin/jsonviewer

Usage

From a file:

jsonviewer data.json

From stdin:

cat data.json | jsonviewer

Controls

→ expand a node

← collapse a node

↑ / ↓ navigate

Enter or Space toggle expand/collapse


Example

Input (data.json):

{
  "user": {
    "name": "Etse",
    "skills": ["coding", "drawing"]
  }
}

Output in terminal:

▾ JSON
    ◂ user
        • name: Etse
        ◂ skills
            • coding
            • drawing

License

MIT

---