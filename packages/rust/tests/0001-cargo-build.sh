#!/bin/bash
set -e -u

echo_and_run() {
	echo "> $*"
	bash -c "$*"
}

echo_and_run pkg install -y file llvm ndk-multilib wasm-component-ld
#echo_and_run pkg install -y rust rust-std-*

command -v cargo || (echo "cargo is not installed" && exit 1)
cargo -V
command -v rustc || (echo "rustc is not installed" && exit 1)
rustc -V

export RUSTC_LOG="rustc_codegen_ssa::back::link=info"
echo "RUSTC_LOG=$RUSTC_LOG"

tmpdir=$(mktemp -d)
pushd "$tmpdir"

echo_and_run cargo new rusthello
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
echo_and_run cargo build
echo_and_run cargo build --target aarch64-linux-android
echo_and_run cargo build --target armv7-linux-androideabi
echo_and_run cargo build --target i686-linux-android
echo_and_run cargo build --target x86_64-linux-android
echo_and_run cargo build --target wasm32-unknown-unknown
echo_and_run cargo build --target wasm32-wasip1
echo_and_run cargo build --target wasm32-wasip2
echo_and_run cargo build --target wasm32-wasip3
echo_and_run cargo build --release
echo_and_run cargo build --target aarch64-linux-android --release
echo_and_run cargo build --target armv7-linux-androideabi --release
echo_and_run cargo build --target i686-linux-android --release
echo_and_run cargo build --target x86_64-linux-android --release
echo_and_run cargo build --target wasm32-unknown-unknown --release
echo_and_run cargo build --target wasm32-wasip1 --release
echo_and_run cargo build --target wasm32-wasip2 --release
echo_and_run cargo build --target wasm32-wasip3 --release
echo_and_run cargo run
echo_and_run file target/*/rusthello
echo_and_run file target/*/*/rusthello
echo_and_run file target/*/*/rusthello.wasm
echo_and_run llvm-readelf -d target/*/rusthello
if ! echo_and_run "llvm-readelf -s target/*/rusthello | grep __emutls_get_address | grep WEAK"; then
	llvm-readelf -s target/*/rusthello | grep __emutls_get_address
	echo "ERROR: this should be WEAK" 1>&2
	exit 1
fi
popd

echo_and_run cargo new rusthello-lib --lib
pushd rusthello-lib
echo >> Cargo.toml
echo '[lib]' >> Cargo.toml
echo 'crate-type = ["cdylib"]' >> Cargo.toml
echo_and_run cargo build
echo_and_run llvm-readelf -d target/*/deps/librusthello_lib.so
if ! echo_and_run "llvm-readelf -s target/*/deps/librusthello_lib.so | grep __emutls_get_address | grep WEAK"; then
	llvm-readelf -s target/*/deps/librusthello_lib.so | grep __emutls_get_address
	echo "ERROR: this should be WEAK" 1>&2
	exit 1
fi
popd

popd
rm -fr "$tmpdir"
