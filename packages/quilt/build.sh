TERMUX_PKG_HOMEPAGE=https://savannah.nongnu.org/projects/quilt
TERMUX_PKG_DESCRIPTION="Allows you to easily manage large numbers of patches"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.66
TERMUX_PKG_SRCURL=https://savannah.nongnu.org/download/quilt/quilt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=314b319a6feb13bf9d0f9ffa7ce6683b06919e734a41275087ea457cc9dc6e07
TERMUX_PKG_DEPENDS="coreutils, diffstat, gawk, graphviz, perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-diffstat=$TERMUX_PREFIX/bin/diffstat
--without-7z
--without-rpmbuild
--without-sendmail
"

termux_step_post_make_install() {
	ln -sf $TERMUX_PREFIX/bin/gawk $TERMUX_PREFIX/share/quilt/compat/awk
}
