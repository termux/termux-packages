TERMUX_PKG_HOMEPAGE=https://mp3wrap.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A command-line utility that wraps quickly two or more mp3 files in one single large playable mp3"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mp3wrap/mp3wrap-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=1b4644f6b7099dcab88b08521d59d6f730fa211b5faf1f88bd03bf61fedc04e7

termux_step_pre_configure() {
	rm -f config.status
	autoreconf -fi
}
