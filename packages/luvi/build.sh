TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="A project in-between luv and luvit"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=1:2.15.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/luvit/luvi
TERMUX_PKG_DEPENDS="lua51-lpeg, luajit, luv, openssl, pcre2, zlib"
TERMUX_PKG_SUGGESTS="lit, luvit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DWithSharedLibluv=On
	-DWithOpenSSL=On
	-DWithSharedOpenSSL=On
	-DWithPCRE2=On
	-DWithSharedPCRE2=On
	-DWithLPEG=On
	-DWithSharedLPEG=On
	-DWithZLIB=On
	-DWithSharedZLIB=ON
	-DLIBLUV_INCLUDE_DIR=${TERMUX_PREFIX}/include/luv
	-DLUAJIT_INCLUDE_DIR=${TERMUX_PREFIX}/include/luajit-2.1
	-DLIBUV_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DOPENSSL_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DPCRE2_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DZLIB_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DLIBLUV_LIBRARIES=${TERMUX_PREFIX}/lib/libluv.so
	-DLUAJIT_LIBRARIES=${TERMUX_PREFIX}/lib/libluajit.so
	-DLIBUV_LIBRARIES=${TERMUX_PREFIX}/lib/libuv.so
	-DOPENSSL_LIBRARIES=${TERMUX_PREFIX}/lib/libssl.so;${TERMUX_PREFIX}/lib/libcrypto.so
	-DPCRE2_LIBRARIES=${TERMUX_PREFIX}/lib/libpcre2-8.so
	-DZLIB_LIBRARIES=${TERMUX_PREFIX}/lib/libz.so
	-DLPEG_LIBRARIES=${TERMUX_PREFIX}/lib/liblpeg-5.1.so
"

termux_step_pre_configure() {
	local dlp_commit="7adf5b3" script_checksum="4b4412c4e93c3cebfc830c643a04b31108a12f10abf7489ab0a80077a1a1ccdb"

	termux_download "https://github.com/ReFreezed/DumbLuaParser/raw/${dlp_commit}/dumbParser.lua" \
		"${TERMUX_PKG_CACHEDIR}/dumbParser.lua" \
		"${script_checksum}"
	export LUA_PATH=";;${TERMUX_PKG_CACHEDIR}/?.lua"

	echo "${TERMUX_PKG_VERSION:2}" > "${TERMUX_PKG_SRCDIR}/VERSION"
}
