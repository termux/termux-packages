TERMUX_PKG_HOMEPAGE=https://hewlettpackard.github.io/netperf/
TERMUX_PKG_DESCRIPTION="Benchmarking tool for many different types of networking"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_SRCURL=https://github.com/HewlettPackard/netperf/archive/netperf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-demo --enable-unixdomain --enable-dccp --enable-sctp ac_cv_func_setpgrp_void=yes"

termux_step_pre_configure() {
	# avoid duplicated symbol errors
	CFLAGS+=" -fcommon"

	# replace config.sub and config.guess with newer versions
	curl -L 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' -o config.sub
	curl -L 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' -o config.guess

	# apply 001-fix-inlining.patch from ArchLinux package
	curl -L 'https://gitlab.archlinux.org/archlinux/packaging/packages/netperf/-/raw/main/001-fix-inlining.patch' -o 001-fix-inlining.patch
	patch -Np1 -i 001-fix-inlining.patch
}
