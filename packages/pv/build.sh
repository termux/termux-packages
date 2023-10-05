TERMUX_PKG_HOMEPAGE=http://www.ivarch.com/programs/pv.shtml
TERMUX_PKG_DESCRIPTION="Terminal-based tool for monitoring the progress of data through a pipeline"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.24
TERMUX_PKG_SRCURL=http://www.ivarch.com/programs/sources/pv-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bf43c5809c8d50066eaeaea5a115f6503c57a38c151975b710aa2bee857b65e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-ipc"
