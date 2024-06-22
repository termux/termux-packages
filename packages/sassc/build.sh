TERMUX_PKG_HOMEPAGE=https://github.com/sass/sassc
TERMUX_PKG_DESCRIPTION="libsass command line driver"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION=3.6.2
TERMUX_PKG_SRCURL=https://github.com/sass/sassc/archive/refs/tags/${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=d9f8ae15894546fe973417ab85909fb70310de3a01a8a2d4c7a3182b03d5c6d7
TERMUX_PKG_DEPENDS="libsass"

termux_step_pre_configure() {
	autoreconf -fi
}
