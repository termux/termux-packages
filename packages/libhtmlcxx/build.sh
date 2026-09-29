TERMUX_PKG_HOMEPAGE=https://htmlcxx.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A simple non-validating css1 and html parser for C++"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.87
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/sourceforge/htmlcxx/htmlcxx-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d38f938cf4df9a298a5346af27195fffabfef9f460fc2a02233cbcfa8fc75c8
TERMUX_PKG_DEPENDS="libc++, libiconv"

termux_step_pre_configure() {
	autoreconf -fi

	# error: ISO C++17 does not allow dynamic exception specifications [-Wdynamic-exception-spec]
	CXXFLAGS+=" -std=c++11"

	# static library libclang_rt.builtins-x86_64-android.a is not portable
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
