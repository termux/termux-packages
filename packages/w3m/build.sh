TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~rkta/w3m
TERMUX_PKG_DESCRIPTION="Text based Web browser and pager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.6"
TERMUX_PKG_REVISION=1
# The upstream w3m project is dead, this is the fork shipped by e.g. Arch Linux.
TERMUX_PKG_SRCURL="https://git.sr.ht/~rkta/w3m/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8dd652cd3f31817d68c7263c34eeffb50118c80be19e1159bf8cbf763037095e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libgc, ncurses, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="imlib2, libsixel"
TERMUX_PKG_SUGGESTS="imlib2, libsixel, perl"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true

# ac_cv_func_bcopy=yes to avoid w3m defining it's own bcopy function, which
# breaks 64-bit builds where NDK headers define bcopy as a macro:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_setpgrp_void=yes ac_cv_func_bcopy=yes"

#Overwrite the default /usr/bin/firefox with termux-open-url as default external browser. That way, pressing "M" on a URL will open a link in Androids default Browser.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-browser=termux-open-url"
#Overwrite the default editor to just vi, as the default was /usr/bin/vi.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-editor=editor"
# Build w3mimg with X11/imlib2.
# w3mimgdisplay is in w3m-img subpackage.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-image=x11 --with-imagelib=imlib2"

termux_step_pre_configure() {
	# Remove this marker all the time, as this package is architecture-specific
	rm -rf "$TERMUX_HOSTBUILD_MARKER"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	{ # mute the build for debugging.
	"$TERMUX_PKG_SRCDIR/configure"
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	} &>/dev/null

	# stop make from recompiling mktable
	sed -i -e 's|mktable.*:.*|mktable:|' "$TERMUX_PKG_SRCDIR/Makefile.in"
	# use the host-built `mktable`
	ln -v -sft "$TERMUX_PKG_SRCDIR" "$PWD/mktable"
}
