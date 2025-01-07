TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/soxr/
TERMUX_PKG_DESCRIPTION="High quality, one-dimensional sample-rate conversion library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.3"
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/soxr/files/soxr-$TERMUX_PKG_VERSION-Source.tar.xz
TERMUX_PKG_SHA256=b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889
TERMUX_PKG_BREAKS="libsoxr-dev"
TERMUX_PKG_REPLACES="libsoxr-dev"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
