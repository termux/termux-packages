TERMUX_PKG_HOMEPAGE=https://luvit.io
TERMUX_PKG_DESCRIPTION="A project in-between luv and luvit."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Komo @cattokomo"
TERMUX_PKG_VERSION=20240216
TERMUX_PKG_REVISION=2
_commit=b85da58f2549a519486a7296f5b836a8f6a64880
_version=2.14.0
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SRCURL=git+https://github.com/luvit/luvi.git
TERMUX_PKG_DEPENDS="pcre, openssl, luv, lua51-lpeg, libluajit"
TERMUX_PKG_SUGGESTS="lit, luvit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	-DWithSharedLibluv=On
	-DWithOpenSSL=On
	-DWithSharedOpenSSL=On
	-DWithPCRE=On
	-DWithSharedPCRE=On
	-DWithLPEG=On
"

termux_step_post_get_source() {
	git checkout "${_commit}"
}

termux_step_pre_configure() {
	declare include=${TERMUX_PREFIX}/include lib=${TERMUX_PREFIX}/lib
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
		-DLIBLUV_INCLUDE_DIR=${TERMUX_PKG_SRCDIR}/deps/luv/src
		-DLIBLUV_LIBRARIES=$lib/libluv.so
		-DLUAJIT_INCLUDE_DIR=$include/luajit-2.1
		-DLUAJIT_LIBRARIES=$lib/libluajit.so
		-DLIBUV_INCLUDE_DIR=$include
		-DLIBUV_LIBRARIES=$lib/libuv.so
		-DOPENSSL_INCLUDE_DIR=$include
		-DOPENSSL_LIBRARIES=$lib
		-DPCRE_INCLUDE_DIR=$include
		-DPCRE_LIBRARIES=$lib
		-DLPEG_LIBRARY=$lib/liblpeg-5.1.so
	"

	case "${TERMUX_ARCH}" in
	x86_64) TARGET_ARCH=x64 ;;
	i686) TARGET_ARCH=x86 ;;
	aarch64) TARGET_ARCH=arm64 ;;
	arm) TARGET_ARCH=arm ;;
	esac
	export TARGET_ARCH

	export LPEGLIB_DIR=deps/lpeg

	echo "$_version" >"${TERMUX_PKG_SRCDIR}/VERSION"
}
