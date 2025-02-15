TERMUX_PKG_HOMEPAGE=https://weechat.org/
TERMUX_PKG_DESCRIPTION="Fast, light and extensible IRC chat client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# `weechat-python-plugin` depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="4.5.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.weechat.org/files/src/weechat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=67c143c7bc70e689b9ea86df674c9a9ff3cf44ccc9cdff21be6a561d5eafc528
TERMUX_PKG_DEPENDS="libandroid-support, libcurl, libgcrypt, libgnutls, libiconv, ncurses, zlib, zstd"
TERMUX_PKG_BREAKS="weechat-dev"
TERMUX_PKG_REPLACES="weechat-dev"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/weechat-curses
share/icons
share/man/man1/weechat-headless.1
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGETTEXT_FOUND=ON
-DENABLE_CJSON=OFF
-DENABLE_GUILE=OFF
-DENABLE_HEADLESS=OFF
-DENABLE_JAVASCRIPT=OFF
-DENABLE_LUA=ON
-DENABLE_MAN=ON
-DENABLE_PERL=ON
-DENABLE_PYTHON=ON
-DENABLE_PHP=OFF
-DENABLE_RUBY=ON
-DENABLE_SPELL=OFF
-DENABLE_TCL=OFF
-DENABLE_TESTS=OFF
-DMSGFMT_EXECUTABLE=$(command -v msgfmt)
-DMSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DXGETTEXT_EXECUTABLE=$(command -v xgettext)
-DDL_LIBRARY=0
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPKG_CONFIG_EXECUTABLE=${PKG_CONFIG}"

	local _Ruby_API_VERSION=$(
		. $TERMUX_SCRIPTDIR/packages/ruby/build.sh
		echo "$(echo $TERMUX_PKG_VERSION | cut -d . -f 1-2).0"
	)
	local _Ruby_INCLUDE_DIR="$TERMUX_PREFIX/include/ruby-$_Ruby_API_VERSION"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRuby_INCLUDE_DIR=$_Ruby_INCLUDE_DIR"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DRuby_CONFIG_INCLUDE_DIR=$_Ruby_INCLUDE_DIR"
	if [ "$TERMUX_ARCH" == "arm" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="/$TERMUX_ARCH-linux-androideabi"
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="/$TERMUX_ARCH-linux-android"
	fi

	LDFLAGS+=" -ldl"
}
