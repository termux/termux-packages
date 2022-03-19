TERMUX_PKG_HOMEPAGE=http://docopt.org
TERMUX_PKG_DESCRIPTION="Command line arguments parser for C++11 and later"
TERMUX_PKG_LICENSE="BSL-1.0, MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-Boost-1.0, LICENSE-MIT"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=0.6.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/docopt/docopt.cpp/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=28af5a0c482c6d508d22b14d588a3b0bd9ff97135f99c2814a5aa3cbff1d6632
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
