# Not making sense on Termux which is essentially a single-user environment.
TERMUX_PKG_HOMEPAGE=https://savannah.gnu.org/projects/acct/
TERMUX_PKG_DESCRIPTION="GNU Accounting Utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.4
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/acct/acct-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c15bf2b58b16378bcc83f70e77d4d40ab0b194acf2ebeefdb507f151faa663f

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_massage() {
	mkdir -p ./var/account
}
