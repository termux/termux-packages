TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="Simple DirectMedia Layer 3"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.2"
TERMUX_PKG_SRCURL="https://github.com/libsdl-org/SDL/releases/download/release-${TERMUX_PKG_VERSION}/SDL3-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ef39a2e3f9a8a78296c40da701967dd1b0d0d6e267e483863ce70f8a03b4050c
TERMUX_PKG_DEPENDS="libandroid-shmem, libdecor, libiconv, libwayland, libx11, libxcursor, libxext, libxfixes, libxi, libxkbcommon, libxrandr, libxss, pulseaudio"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DSDL_INSTALL_TESTS=OFF
-DSDL_TESTS=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -En 's/.*SDL_SO_VERSION_MAJOR "([0-9]+)".*/\1/p' CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed: ${v} != ${_SOVERSION}"
	fi
}

termux_step_pre_configure() {
	cp -fr "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_TMPDIR}/a"
	find "${TERMUX_PKG_SRCDIR}" -type f -print0 | xargs -0r -n1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'
	cp -fr "${TERMUX_PKG_SRCDIR}" "${TERMUX_PKG_TMPDIR}/b"
	echo "INFO: Modified files:"
	diff -uNr "${TERMUX_PKG_TMPDIR}"/{a,b} --color || :

	LDFLAGS+=" -landroid-shmem"
}
