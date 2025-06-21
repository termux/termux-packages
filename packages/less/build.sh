TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
# less has both the GPLv3 and its own "less license" which is a variation of a BSD 2-Clause license
TERMUX_PKG_LICENSE="GPL-3.0, custom"
TERMUX_PKG_LICENSE_FILE='COPYING, LICENSE'
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="668"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2819f55564d86d542abbecafd82ff61e819a3eec967faa36cd3e68f1596a44b8
TERMUX_PKG_DEPENDS="ncurses, pcre2"
TERMUX_PKG_REPLACES="lazyread"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-regex=pcre2
--with-editor=editor
"
# Official `less` release tags are marked with a `-rel` suffix
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d{3}-rel'

termux_pkg_auto_update() {
	local latest_release
	latest_release="$(git ls-remote --tags https://github.com/gwsw/less.git \
	| grep -oP "refs/tags/v\K${TERMUX_PKG_UPDATE_VERSION_REGEXP}$" \
	| sort -V \
	| tail -n1)"

	# remove `-rel` suffix from version number
	latest_release="${latest_release%-rel}"
	if [[ "${latest_release}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# Avoid refiltering the version number
	# See: https://github.com/termux/termux-packages/issues/20836
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP
	termux_pkg_upgrade_version "${latest_release}"
}



termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives \
			--install "$TERMUX_PREFIX/bin/pager" pager "$TERMUX_PREFIX/bin/less" 50 \
			--slave "$TERMUX_PREFIX/share/man/man1/pager.1.gz" pager.1.gz "$TERMUX_PREFIX/share/man/man1/less.1.gz"
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove pager "$TERMUX_PREFIX/bin/less"
		fi
	fi
	EOF
}
