TERMUX_PKG_DESCRIPTION="H.266/VVC video stream encoder library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0"
TERMUX_PKG_SRCURL=git+https://github.com/fraunhoferhhi/vvenc
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libc++"
# TERMUX_PKG_BUILD_DEPENDS="llvmgold"
TERMUX_PKG_MAKE_PROCESSES=4
# this was because the build kept resetting I didn't realise there was a -c flag to avoid that
TERMUX_PKG_EXTRA_MAKE_ARGS="-d explain"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_post_configure() {
	# exit
	sed -i s,fuse-ld=gold,fuse-ld=lld,g $TERMUX_PKG_BUILDDIR/build.ninja
	! grep -r -l fuse-ld=gold $TERMUX_PKG_BUILDDIR
	# test $? -ne 0 && echo error! try again &
}

