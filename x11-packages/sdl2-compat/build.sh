TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="Simple DirectMedia Layer (SDL) sdl2-compat"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.32.50"
TERMUX_PKG_SRCURL=https://github.com/libsdl-org/sdl2-compat/releases/download/release-${TERMUX_PKG_VERSION}/sdl2-compat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b559c734f2cdc4ea34266a1ef7724cbf3a729deaab23a774aa60a980368f5a88
TERMUX_PKG_DEPENDS="sdl3"
TERMUX_PKG_BREAKS="sdl2"
TERMUX_PKG_REPLACES="sdl2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DSDL2COMPAT_TESTS=OFF
"

termux_step_pre_configure() {
	cp -fr "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_TMPDIR}/a"
	find "${TERMUX_PKG_SRCDIR}" -type f -print0 | xargs -0r -n1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'
	cp -fr "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_TMPDIR}/b"
	echo "INFO: Modified files:"
	diff -uNr "${TERMUX_PKG_TMPDIR}"/{a,b} --color || :
}

termux_step_post_massage() {
	# ld(1)ing with `-lSDL2` won't work without this:
	# https://github.com/termux/x11-packages/issues/633
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libSDL2.so" ]; then
		ln -sf libSDL2-2.0.so libSDL2.so
	fi
}
