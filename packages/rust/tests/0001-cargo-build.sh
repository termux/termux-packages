#!/bin/bash
set -e

pkg install -y file ndk-multilib wasm-component-ld
#pkg install -y rust rust-std-*

export RUSTC_LOG="rustc_codegen_ssa::back::link=info"
echo "RUSTC_LOG=$RUSTC_LOG"

tmpdir=$(mktemp -d)
pushd "$tmpdir"
cargo new rusthello
pushd rusthello
mkdir -p .cargo
cat <<- EOL > .cargo/config.toml
[target.aarch64-linux-android]
rustflags = "-Clink-arg=--target=aarch64-linux-android"
[target.armv7-linux-androideabi]
rustflags = "-Clink-arg=--target=armv7a-linux-androideabi"
[target.i686-linux-android]
rustflags = "-Clink-arg=--target=i686-linux-android"
[target.x86_64-linux-android]
rustflags = "-Clink-arg=--target=x86_64-linux-android"
EOL
cargo build
cargo build --target aarch64-linux-android
cargo build --target armv7-linux-androideabi
cargo build --target i686-linux-android
cargo build --target x86_64-linux-android
cargo build --target wasm32-unknown-unknown
cargo build --target wasm32-wasip1
cargo build --target wasm32-wasip2
cargo build --release
cargo build --target aarch64-linux-android --release
cargo build --target armv7-linux-androideabi --release
cargo build --target i686-linux-android --release
cargo build --target x86_64-linux-android --release
cargo build --target wasm32-unknown-unknown --release
cargo build --target wasm32-wasip1 --release
cargo build --target wasm32-wasip2 --release
popd
file rusthello/target/*/rusthello
file rusthello/target/*/*/rusthello
file rusthello/target/*/*/rusthello.wasm
popd
rm -fr "$tmpdir"

command -v cargo
cargo -V
command -v rustc
rustc -V
