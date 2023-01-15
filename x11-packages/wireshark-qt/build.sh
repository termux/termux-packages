TERMUX_PKG_HOMEPAGE=https://www.wireshark.org/
TERMUX_PKG_DESCRIPTION="Network protocol analyzer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.wireshark.org/download/src/all-versions/wireshark-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f35915699f2f9b28ddb211202d40ec8984e5834d3c911483144a4984ba44411d
TERMUX_PKG_DEPENDS="brotli, c-ares, glib, krb5, libc++, libgcrypt, libgnutls, liblua52, liblz4, libmaxminddb, libminizip, libnghttp2, libnl, libopus, libpcap, libsnappy, libssh, libxml2, pcre2, qt5-qtbase, qt5-qtmultimedia, speexdsp, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_CONFLICTS="tshark, wireshark, wireshark-cli, wireshark-gtk"
TERMUX_PKG_PROVIDES="tshark, wireshark, wireshark-cli, wireshark-gtk"
TERMUX_PKG_REPLACES="tshark, wireshark, wireshark-cli, wireshark-gtk"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLEMON_C_COMPILER=gcc-wrapper
-DM_INCLUDE_DIR=$TERMUX_PREFIX/include
-DHAVE_C99_VSNPRINTF_EXITCODE=0
-DHAVE_C99_VSNPRINTF_EXITCODE__TRYRUN_OUTPUT=
-DENABLE_SMI=OFF
-DENABLE_SBC=OFF
-DENABLE_SPANDSP=OFF
-DENABLE_BCG729=OFF
-DENABLE_ILBC=OFF
-DENABLE_CAP=OFF
-DCMAKE_DISABLE_FIND_PACKAGE_DOXYGEN=ON
-DCMAKE_DISABLE_FIND_PACKAGE_Asciidoctor=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"

	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	rm -rf "${bin}"
	mkdir -p "${bin}"
	cat > "${bin}/gcc-wrapper" <<-EOF
		#!$(command -v bash)
		args=()
		for a in "\$@"; do
			case "\${a}" in
				--target=*|--gcc-toolchain=*|--sysroot=* ) ;;
				-fopenmp|-static-openmp ) ;;
				-Wl,--fix-cortex-a8|-Wl,-z,nocopyreloc ) ;;
				* ) args+=("\${a}") ;;
			esac
		done
		exec $(command -v gcc) "\${args[@]}"
	EOF
	chmod 0700 "${bin}/gcc-wrapper"
	export PATH="${bin}:$PATH"
}
