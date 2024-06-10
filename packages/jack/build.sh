TERMUX_PKG_HOMEPAGE=https://jackaudio.org/
TERMUX_PKG_DESCRIPTION="jack1 (non-funcitoning)"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_DEPENDS="libdb, libandroid-sysv-semaphore, libandroid-shmem"
TERMUX_PKG_VERSION=0.126.0
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL=git+https://github.com/jackaudio/jack1
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	cd ${TERMUX_PKG_SRCDIR}
	git submodule update --init --recursive
	${TERMUX_PKG_SRCDIR}/autogen.sh &&
		cd ${TERMUX_PKG_SRCDIR} &&
		autoupdate
	LDFLAGS+=" -landroid-shmem -landroid-sysv-semaphore"
}
