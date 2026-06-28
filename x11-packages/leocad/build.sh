TERMUX_PKG_HOMEPAGE=https://www.leocad.org/
TERMUX_PKG_DESCRIPTION="CAD application for creating virtual LEGO models "
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.09"
TERMUX_PKG_SRCURL="https://github.com/leozide/leocad/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=db9e129ac35fde3c184510a23fd57c61d1bc5d19d3eac2a4a23f6b73b9f87bd5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libc++, opengl, qt6-qtbase, zlib"
TERMUX_PKG_RECOMMENDS="povray"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools, qt6-qttools"

termux_step_host_build() {
	# get a needed component in a similar way to Arch Linux
	# https://gitlab.archlinux.org/archlinux/packaging/packages/leocad/-/blob/05be871130139255863e1c1426c0dafa6f4b2659/PKGBUILD#L28
	LIB_VER="25.08"
	LIB_URL="https://github.com/leozide/leocad/releases/download/v$TERMUX_PKG_VERSION/Library-$LIB_VER.zip"
	LIB_ARCHIVE="${TERMUX_PKG_CACHEDIR}/Library-$LIB_VER.zip"
	LIB_SHA256=848404645811b00128eb20203b3706a6f2fb8ee68a214debc820f4384dab76ed
	termux_download "$LIB_URL" "$LIB_ARCHIVE" "$LIB_SHA256"
	unzip -q "$LIB_ARCHIVE" -d "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_configure() {
	# note: 'host-qmake6' appears to correctly set some necessary build settings,
	# such as '-Wl,-rpath,/data/data/com.termux/files/usr/lib'
	# and '-I/data/data/com.termux/files/usr/include/qt6/QtCore',
	# but fails to correctly set some other necessary build settings,
	# like 'aarch64-linux-android-clang++' and '-L/data/data/com.termux/files/usr/lib',
	# so this overrides only the settings that are absolutely necessary to correct,
	# while leaving other settings as they are.
	# also, it's unclear how to successfully pass more than one argument at a time
	# to variables like QMAKE_CXXFLAGS.
	"${TERMUX_PREFIX}/lib/qt6/bin/host-qmake6" \
		QMAKE_CXX="$CXX" \
		QMAKE_LINK="$CXX" \
		QMAKE_CXXFLAGS="-isystem$TERMUX__PREFIX__INCLUDE_DIR" \
		QMAKE_LFLAGS="-L$TERMUX__PREFIX__LIB_DIR" \
		QMAKE_LRELEASE="$TERMUX_PREFIX/opt/qt6/cross/lib/qt6/bin/lrelease" \
		INSTALL_PREFIX="$TERMUX_PREFIX" \
		DISABLE_UPDATE_CHECK=1 \
		LDRAW_LIBRARY_PATH="$TERMUX_PREFIX/share/leocad" \
		leocad.pro
}

termux_step_post_make_install() {
	install -Dm644 "$TERMUX_PKG_HOSTBUILD_DIR/library.bin" -t "$TERMUX_PREFIX/share/leocad"
}
