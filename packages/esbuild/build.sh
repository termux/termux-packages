TERMUX_PKG_HOMEPAGE=https://esbuild.github.io/
TERMUX_PKG_DESCRIPTION="An extremely fast JavaScript and CSS bundler and minifier"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.12"
TERMUX_PKG_SRCURL=https://github.com/evanw/esbuild/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3b00894d38b077e0a92928b4ac9018d44249b94d515b73f7da009aa87dab7d63
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang
        termux_setup_nodejs
}

termux_step_make() {
	if [ $TERMUX_ARCH = "arm" ]; then
		export GOOS="android"
		export GOARCH=arm
		make platform-android-arm
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		export GOOS="android"
		export GOARCH=arm64
		make platform-android-arm64
	elif [ $TERMUX_ARCH = "i686" ]; then
		export GOARCH=386
		make
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		export GOARCH=amd64
		make
	fi
}

termux_step_make_install() {
	if [ $TERMUX_ARCH = "arm" ]; then
		install -Dm755 -t "${TERMUX_PREFIX}"/bin npm/esbuild-android-arm/bin/esbuild
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		install -Dm755 -t "${TERMUX_PREFIX}"/bin npm/esbuild-android-arm64/bin/esbuild
	elif [ $TERMUX_ARCH = "i686" ]; then
		install -Dm755 -t "${TERMUX_PREFIX}"/bin esbuild
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		install -Dm755 -t "${TERMUX_PREFIX}"/bin esbuild
	fi
}
