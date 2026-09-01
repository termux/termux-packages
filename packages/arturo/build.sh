TERMUX_PKG_HOMEPAGE=https://arturo-lang.io
TERMUX_PKG_DESCRIPTION="Simple, expressive & portable programming language for efficient scripting"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SRCURL=https://github.com/arturo-lang/arturo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351
TERMUX_PKG_DEPENDS="libgmp, libmpfr, libandroid-glob, libsqlite, openssl, pcre"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	declare arch=${TERMUX_ARCH}
	case "${arch}" in
	aarch64) arch=arm64 ;;
	x86_64)  arch=amd64 ;;
	esac
	cat <<-EOF >nim.cfg
		--os:android
		--cpu:${arch}
		--cc:clang
		--clang.path:"$TERMUX_STANDALONE_TOOLCHAIN/bin"
		--clang.exe:"${TERMUX_HOST_PLATFORM}-clang"
		--clang.linkerexe:"${TERMUX_HOST_PLATFORM}-clang"
		--passC:"$CPPFLAGS $CFLAGS  -Wno-incompatible-function-pointer-types"
		--passL:"$LDFLAGS -landroid-glob"
		-d:NOWEBVIEW
		-d:NODIALOGS
		-d:NOCLIPBOARD
		-d:httpxSendServerDate=false
		-d:useFork
	EOF
}

termux_step_configure() {
	curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
	export PATH="$HOME/.nimble/bin:$PATH"
}

termux_step_make() {
	nim build.nims build --mode full --log --release
}

termux_step_make_install() {
	install -Dm700 bin/arturo "${TERMUX_PREFIX}/bin/arturo"
}
