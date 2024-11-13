TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="A project in-between luv and luvit."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=20241009
_commit=32b274bed2a291068eda6cf7a296328b86d682a9
_version=2.14.0+g${_commit::7}
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=git+https://github.com/luvit/luvi.git
TERMUX_PKG_DEPENDS="pcre2, openssl, luv, libluajit"
TERMUX_PKG_SUGGESTS="lit, luvit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DWithSharedLibluv=On
	-DWithOpenSSL=On
	-DWithSharedOpenSSL=On
	-DWithPCRE2=On
	-DWithSharedPCRE2=On
	-DWithLPEG=On
	-DLIBLUV_INCLUDE_DIR=${TERMUX_PREFIX}/include/luv
	-DLIBLUV_LIBRARIES=${TERMUX_PREFIX}/lib/libluv.so
	-DLUAJIT_INCLUDE_DIR=${TERMUX_PREFIX}/include/luajit-2.1
	-DLUAJIT_LIBRARIES=${TERMUX_PREFIX}/lib/libluajit.so
	-DLIBUV_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DLIBUV_LIBRARIES=${TERMUX_PREFIX}/lib/libuv.so
	-DOPENSSL_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DOPENSSL_LIBRARIES=${TERMUX_PREFIX}/lib
	-DPCRE2_INCLUDE_DIR=${TERMUX_PREFIX}/include
	-DPCRE2_LIBRARIES=${TERMUX_PREFIX}/lib
"

termux_step_post_get_source() {
	git checkout "${_commit}"
}

termux_step_pre_configure() {
	local dlp_commit="7adf5b3" script_checksum="4b4412c4e93c3cebfc830c643a04b31108a12f10abf7489ab0a80077a1a1ccdb"

	termux_download "https://github.com/ReFreezed/DumbLuaParser/raw/${dlp_commit}/dumbParser.lua" \
		"${TERMUX_PKG_CACHEDIR}/dumbParser.lua" \
		"${script_checksum}"
	export LUA_PATH=";;${TERMUX_PKG_CACHEDIR}/?.lua"
	
	echo "$_version" >"${TERMUX_PKG_SRCDIR}/VERSION"
}
