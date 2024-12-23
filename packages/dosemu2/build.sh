TERMUX_PKG_HOMEPAGE=https://github.com/dosemu2/dosemu2
TERMUX_PKG_DESCRIPTION="Run DOS programs under linux."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@stsp"
TERMUX_PKG_VERSION="2.0pre9-git"
TERMUX_PKG_SRCURL=git+https://github.com/dosemu2/dosemu2.git
TERMUX_PKG_GIT_BRANCH=devel
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="libandroid-posix-semaphore, libandroid-glob, slang, libao, fluidsynth, ladspa-sdk, libslirp, libbsd, readline, json-c, libseccomp, libsearpc, fdpp, dj64dev"
TERMUX_PKG_DEPENDS="fdpp, dj64dev, comcom64"
# LTO breaks on i386 build
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-lto"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	./autogen.sh
}
