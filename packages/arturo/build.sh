TERMUX_PKG_HOMEPAGE=https://arturo-lang.io
TERMUX_PKG_DESCRIPTION="Simple, expressive & portable programming language for efficient scripting"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=0.9.83
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/arturo-lang/arturo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0bb3632f21a1556167fdcb82170c29665350beb44f15b4666b4e22a23c2063cf
TERMUX_PKG_DEPENDS="libgmp, libmpfr, libandroid-glob, libsqlite"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -Wno-incompatible-function-pointer-types"
	LDFLAGS+=" -landroid-glob"
	sed -i \
		-e "s|@TERMUX_STANDALONE_TOOLCHAIN@|${TERMUX_STANDALONE_TOOLCHAIN}|g" \
		-e "s|@TERMUX_HOST_PLATFORM@|${TERMUX_HOST_PLATFORM}-|g" \
		-e "s|@CFLAGS@|${CPPFLAGS} ${CFLAGS}|g" \
		-e "s|@LDFLAGS@|${LDFLAGS}|g" \
		"${TERMUX_PKG_SRCDIR}/build.nims"
}

termux_step_configure() {
	# Arturo 0.9.83 can only build with Nim 1.6.20
	export CHOOSENIM_CHOOSE_VERSION=1.6.20
	curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
	export PATH="$HOME/.nimble/bin:$PATH"
}

termux_step_make() {
	declare arch=${TERMUX_ARCH}
	case "${arch}" in
	aarch64) arch=arm64 ;;
	i686) arch=x86 ;;
	esac

	nimble install -y smtp

	NIMFLAGS=""
	sed -i "s|@NIMFLAGS@|${NIMFLAGS}|g" build.nims

	nim build.nims install full "${arch}" noinstall release log \
		nowebview \
		noclipboard
}

termux_step_make_install() {
	install -Dm700 bin/arturo "${TERMUX_PREFIX}/bin/arturo"
}
