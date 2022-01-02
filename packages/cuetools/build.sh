TERMUX_PKG_HOMEPAGE=https://github.com/svend/cuetools
TERMUX_PKG_DESCRIPTION="A set of utilities for working with Cue Sheet (cue) and Table of Contents (toc) files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.1
TERMUX_PKG_SRCURL=https://github.com/svend/cuetools/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=24a2420f100c69a6539a9feeb4130d19532f9f8a0428a8b9b289c6da761eb107

termux_step_pre_configure() {
	autoreconf -fi
}
