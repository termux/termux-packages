TERMUX_PKG_HOMEPAGE=https://www.tarsnap.com/spiped.html
TERMUX_PKG_DESCRIPTION="a utility for creating symmetrically encrypted and authenticated pipes between socket addresses"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.4"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Tarsnap/spiped/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e094d8a3408e0689936be00743d1a9818b5d7a9faf6a34fcb44388a40c92bf05
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		# armv8 specific features check also enables them for armv7. But why?
		patch -p1 --silent <"${TERMUX_PKG_BUILDER_DIR}"/disable_armv8_specific_features.diff
	fi
}

termux_step_make() {
	CFLAGS+=" $CPPFLAGS"
	env LDADD_EXTRA="$LDFLAGS" \
		make -j "$TERMUX_PKG_MAKE_PROCESSES" BINDIR="$TERMUX_PREFIX/bin" \
		MAN1DIR="$TERMUX_PREFIX/share/man/man1"
}

termux_step_make_install() {
	make install BINDIR="$TERMUX_PREFIX/bin" \
		MAN1DIR="$TERMUX_PREFIX/share/man/man1"
}
