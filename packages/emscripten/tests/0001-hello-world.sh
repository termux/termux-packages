#!/bin/bash
set -e

#pkg install -y nodejs-lts
pkg install -y wasmtime

tmpdir=$(mktemp -d)
pushd "$tmpdir"
echo "int main() { return 0; }" > hello1.c
cat <<- EOL > hello2.c
#include <stdio.h>

int main() {
	puts("Hello, World!");
	return 0;
}
EOL
cat <<- EOL > hello3.cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!\n";
    return 0;
}
EOL

emcc -v hello1.c -o hello1.html
emcc -v hello2.c -o hello2.html
em++ -v hello3.cpp -o hello3.html

emcc -v hello1.c -o hello1wasip1.wasm
emcc -v hello2.c -o hello2wasip1.wasm
em++ -v hello3.cpp -o hello3wasip1.wasm

node hello1.js
node hello2.js
node hello3.js
wasmtime hello1wasip1.wasm
wasmtime hello2wasip1.wasm
wasmtime hello3wasip1.wasm

ls -l
popd
rm -fr "$tmpdir"
echo

emcc -v
em++ -v
node -v
wasmtime -V
