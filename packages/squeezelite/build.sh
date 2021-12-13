TERMUX_PKG_HOMEPAGE=https://ralph-irving.github.io/squeezelite.html
TERMUX_PKG_DESCRIPTION="A small headless Logitech Squeezebox emulator"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.9
_COMMIT=370020f2dd572f0ab5464d8ef4e47ebf21b19468
TERMUX_PKG_SRCURL=https://github.com/ralph-irving/squeezelite.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libmad, mpg123, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_pre_configure() {
	export OPTS="-DLINKALL -DNO_FAAD -DPULSEAUDIO"
	export LDADD="-lm"
}

termux_step_make_install() {
	install -Dm700 squeezelite $TERMUX_PREFIX/bin/
}
