#!/bin/bash
# https://github.com/termux/termux-packages/issues/25360
# Credits: @Spector-Studios
#
# Unexpected output:-
# processing crate: issue_25360, module: issue-25360/src/main.rs
# Error Ra("macro-error", Error) from LineCol { line: 7, col: 0 } to LineCol { line: 14, col: 1 }: proc macro server error: Cannot create expander for issue-25360/target/debug/deps/libserde_derive-5cb703e84601d172.so: mismatched ABI expected: `rustc 1.88.0 (6b00bc388 2025-06-23)`, got `rustc 1.88.0 (6b00bc388 2025-06-23) (built from a source tarball)`
# Error Ra("macro-error", Error) from LineCol { line: 7, col: 0 } to LineCol { line: 14, col: 1 }: proc macro server error: Cannot create expander for issue-25360/target/debug/deps/libserde_derive-5cb703e84601d172.so: mismatched ABI expected: `rustc 1.88.0 (6b00bc388 2025-06-23)`, got `rustc 1.88.0 (6b00bc388 2025-06-23) (built from a source tarball)`
# diagnostic scan complete
# Error: diagnostic error detected
#
# Expected output:-
# processing crate: issue_25360, module: issue-25360/src/main.rs
# diagnostic scan complete
set -e

pkg install -y rust-analyzer
#pkg install -y rust

tmpdir=$(mktemp -d)
pushd "$tmpdir"
cargo new issue-25360
pushd issue-25360
echo

cat <<-EOL >>./Cargo.toml
serde = { version = "1.0.219", features = ["derive"] }
EOL
echo "${PWD}/Cargo.toml"
cat "${PWD}/Cargo.toml"
echo

cat <<-EOL >./src/main.rs
use serde::Deserialize;
use serde::Serialize;

fn main() {
    println!("test");
}

#[derive(Serialize, Deserialize, Debug)]
struct Test {
    name: String,
    x: f32,
    y: f32,
    height: f32,
    width: f32,
}
EOL
echo "${PWD}/src/main.rs"
cat "${PWD}/src/main.rs"
echo

echo "rust-analyzer diagnostics ."
rust-analyzer diagnostics .

popd
popd
rm -fr "$tmpdir"
echo

command -v rust-analyzer
rust-analyzer -V
command -v cargo
cargo -V
command -v rustc
rustc -V
