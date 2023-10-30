TERMUX_PKG_HOMEPAGE=https://vicerveza.homeunix.net/~viric/soft/ts/
TERMUX_PKG_DESCRIPTION="Task spooler is a Unix batch system where the tasks spooled run one after the other"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL=https://github.com/justanhduc/task-spooler/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ffffa86f95071e837af619e23fb4a037432b0b079d872d58dc530883d1d33557
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_CONFLICTS="moreutils"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTASK_SPOOLER_COMPILE_CUDA=OFF
"

termux_step_pre_configure() {
	# if $TERMUX_ON_DEVICE_BUILD; then
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
	    sed -i '/add_executable(makeman man.c)/d' ${TERMUX_PKG_SRCDIR}/CMakeLists.txt
	    gcc -o ${TERMUX_PKG_BUILDDIR}/makeman ${TERMUX_PKG_SRCDIR}/man.c
	fi
}
