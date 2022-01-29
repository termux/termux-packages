TERMUX_PKG_HOMEPAGE=http://mp3gain.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Analyzes and adjusts mp3 files so that they have the same volume"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mp3gain/mp3gain-${TERMUX_PKG_VERSION//./_}-src.zip
TERMUX_PKG_SHA256=5cc04732ef32850d5878b28fbd8b85798d979a025990654aceeaa379bcc9596d
TERMUX_PKG_DEPENDS="mpg123"
TERMUX_PKG_BUILD_IN_SRC=true

termux_extract_src_archive() {
	rm -Rf mp3gain
	mkdir mp3gain
	pushd mp3gain
	unzip -q "$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL}")"
	popd
	mv mp3gain "$TERMUX_PKG_SRCDIR"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin mp3gain
}
