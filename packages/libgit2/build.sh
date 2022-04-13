TERMUX_PKG_HOMEPAGE=https://libgit2.github.com/
TERMUX_PKG_DESCRIPTION="C library implementing Git core methods"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.3"
TERMUX_PKG_SRCURL=https://github.com/libgit2/libgit2/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f48b961e463a9e4e7e7e58b21a0fb5a9b2a1d24d9ba4d15870a0c9b8ad965163
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libssh2, openssl, pcre, zlib"
TERMUX_PKG_BUILD_DEPENDS="libiconv, libpcreposix"
TERMUX_PKG_BREAKS="libgit2-dev"
TERMUX_PKG_REPLACES="libgit2-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DUSE_SSH=ON
-DREGEX_BACKEND=pcre
"

termux_step_pre_configure() {
	find "$TERMUX_PKG_SRCDIR" -name CMakeLists.txt | xargs -n 1 \
		sed -i 's/\( PROPERTIES C_STANDARD\) 90/\1 99/g'

	cp "$TERMUX_PKG_BUILDER_DIR"/getloadavg.c "$TERMUX_PKG_SRCDIR"/src/
}
