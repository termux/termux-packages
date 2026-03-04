TERMUX_PKG_HOMEPAGE=https://turbo.build/
TERMUX_PKG_DESCRIPTION="Rust-based incremental compilation engine and bundler for Next.js"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=16.1.6
TERMUX_PKG_SRCURL=https://github.com/vercel/next.js/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=63e8f9f386022fa0b9bea1113e7649fe250ae4bb85782b1c4286a3fbf0efedea
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_RUST_VERSION="nightly"

termux_step_make() {
	local RUST_TARGET
	case "$TERMUX_ARCH" in
		aarch64) RUST_TARGET="aarch64-linux-android" ;;
		arm)     RUST_TARGET="armv7-linux-androideabi" ;;
		i686)    RUST_TARGET="i686-linux-android" ;;
		x86_64)  RUST_TARGET="x86_64-linux-android" ;;
	esac

	# 1. 环境准备
	termux_setup_rust
	termux_setup_nodejs
	export ANDROID_NDK_LATEST_HOME="${NDK}"

	# 2. 核心：开启 Tokio 不稳定特性，解决 disable_lifo_slot 报错
	export RUSTFLAGS="--cfg tokio_unstable"

	# 3. 核心：动态绑定 Linker，解决 x86_64 误用 aarch64 编译器的问题
	# $CC 是 Termux 提供的指向当前架构正确编译器的变量
	local ENV_PREFIX=$(echo "$RUST_TARGET" | tr '[:lower:]-' '[:upper:]_')
	export "CARGO_TARGET_${ENV_PREFIX}_LINKER"="$CC"
	export "CC_${RUST_TARGET//-/_}"="$CC"

	# 4. 安装依赖
	npx pnpm install

	# 5. 进入子包目录并运行你指定的脚本
	# 因为你已经 patch 了该目录下的 package.json，所以这里会识别新的 triples
	cd packages/next-swc
	npx pnpm run build-native-release --target "$RUST_TARGET"
}

termux_step_make_install() {
	local NAPI_ARCH
	case "$TERMUX_ARCH" in
		aarch64) NAPI_ARCH="arm64" ;;
		arm)     NAPI_ARCH="arm-eabi" ;;
		i686)    NAPI_ARCH="ia32" ;;
		x86_64)  NAPI_ARCH="x64" ;;
	esac

	local PACKAGE_NAME="@next/swc-android-${NAPI_ARCH}"
	local INSTALL_DIR="$TERMUX_PREFIX/lib/node_modules/${PACKAGE_NAME}"
	local BINARY_NAME="next-swc.android-${NAPI_ARCH}.node"

	mkdir -p "$INSTALL_DIR"

	# 拷贝产物 (napi build 默认会把产物放在目录根部或 native/ 下)
	# 如果你在 package.json 里指定了输出到 native，路径如下：
	install -Dm755 "native/${BINARY_NAME}" "$INSTALL_DIR/${BINARY_NAME}"

	# 瘦身：剥离调试符号
	${STRIP} --strip-unneeded "$INSTALL_DIR/${BINARY_NAME}"

	# 生成符合 Termux Linter 要求的 package.json
	cat > "$INSTALL_DIR/package.json" <<EOF
{
	"name": "${PACKAGE_NAME}",
	"version": "$TERMUX_PKG_VERSION",
	"os": ["android"],
	"cpu": ["${NAPI_ARCH}"],
	"main": "${BINARY_NAME}"
}
EOF
}
