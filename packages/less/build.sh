TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
# less has both the GPLv3 and its own "less license" which is a variation of a BSD 2-Clause license
TERMUX_PKG_LICENSE="GPL-3.0, custom"
TERMUX_PKG_LICENSE_FILE='COPYING, LICENSE'
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="685"
TERMUX_PKG_SRCURL=https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2701041e767e697ee420ce0825641cedc8f20b51576abe99d92c1666d332e9dc
TERMUX_PKG_DEPENDS="ncurses, pcre2"
TERMUX_PKG_REPLACES="lazyread"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-regex=pcre2
--with-editor=editor
"
TERMUX_PKG_AUTO_UPDATE=true
# Official `less` release tags are marked with a `-rel` suffix
TERMUX_PKG_UPDATE_VERSION_REGEXP='\d{3}(?=-rel)'

termux_pkg_auto_update() {
	local latest_tags
	latest_tags="$(
		TERMUX_PKG_SRCURL="https://github.com/gwsw/less" \
		termux_github_api_get_tag
	)"

	termux_pkg_upgrade_version "${latest_tags}"
}

termux_step_pre_configure() {
	autoreconf -fi
}
