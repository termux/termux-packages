TERMUX_PKG_HOMEPAGE=https://github.com/erkin/ponysay
TERMUX_PKG_DESCRIPTION="Cowsay reimplementation for ponies."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.3
TERMUX_PKG_SRCURL=https://github.com/erkin/ponysay/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c382d7f299fa63667d1a4469e1ffbf10b6813dcd29e861de6be55e56dc52b28a
TERMUX_PKG_DEPENDS="python, coreutils"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	python3 ./setup.py install \
		--everything \
		--freedom=partial \
		--with-pdf-manual="${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_BUILDER_DIR##*/}" \
		--without-pdf-manual-compression \
		--with-{ba,z,fi}sh \
		--prefix="${TERMUX_PREFIX}" \
		--sysconf-dir="${TERMUX_PREFIX}/etc" \
		--cache-dir="${TERMUX_PREFIX}/var/cache"
}
