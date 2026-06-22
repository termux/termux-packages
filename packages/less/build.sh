TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
# less has both the GPLv3 and its own "less license" which is a variation of a BSD 2-Clause license
TERMUX_PKG_LICENSE="GPL-3.0, custom"
TERMUX_PKG_LICENSE_FILE='COPYING, LICENSE'
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="704"
TERMUX_PKG_SRCURL="https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=20a0b0a2bb2525fa53c7eee9beb854b4c9cf172eabb209af7020743547bfe9fb
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
