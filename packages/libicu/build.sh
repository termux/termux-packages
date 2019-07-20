TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_VERSION=64.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/icu4c-${TERMUX_PKG_VERSION//./_}-src.tar.xz
TERMUX_PKG_SHA256=09762184afa33c3b1042715192da1777f9fda31688cab5b03b8b71fad1dcd0c7
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libicu-dev"
TERMUX_PKG_REPLACES="libicu-dev"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/source"
}
