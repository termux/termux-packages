TERMUX_PKG_HOMEPAGE=https://www.cryptopp.com/
TERMUX_PKG_DESCRIPTION="A free C++ class library of cryptographic schemes"
TERMUX_PKG_LICENSE="BSL-1.0, BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.7.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=8d6a4064b8e9f34cd3e838f5a12c40067ee7b95ee37d9173ec273cb0913e7ca2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="libcpufeatures"
TERMUX_PKG_BREAKS="cryptopp-dev"
TERMUX_PKG_REPLACES="cryptopp-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install-lib"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
share/cryptopp/
"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libcryptopp.so.8"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}

termux_step_pre_configure() {
	export CXXFLAGS+=" -fPIC -I$TERMUX_PREFIX/include/ndk_compat -fPIC"
	export TERMUX_PKG_EXTRA_MAKE_ARGS+=" all static dynamic libcryptopp.pc CC=$CC CXX=$CXX"
	export CFLAGS+=" -I$TERMUX_PREFIX/include/ndk_compat"
	export LDFLAGS+=" -l:libndk_compat.a"
}
