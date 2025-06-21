TERMUX_PKG_HOMEPAGE=http://www.jedsoft.org/most/index.html
TERMUX_PKG_DESCRIPTION="A terminal pager similar to 'more' and 'less'"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jedsoft/most/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5e51a02e45660ce81336046f6ed4110c406dfd8f5972601016e046d393dcdadb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="slang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives \
			--install "$TERMUX_PREFIX/bin/pager" pager "$TERMUX_PREFIX/bin/most" 25 \
			--slave "$TERMUX_PREFIX/share/man/man1/pager.1.gz" pager.1.gz "$TERMUX_PREFIX/share/man/man1/most.1.gz"
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove pager "$TERMUX_PREFIX/bin/most"
		fi
	fi
	EOF
}
