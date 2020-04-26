TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=67.1
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/icu4c-${TERMUX_PKG_VERSION//./_}-src.tar.xz
TERMUX_PKG_SHA256=37d32ff0c8e851d9d6e6a1635ec036837a4c1391d03dc1adecfab897e8bf3c8a
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libicu-dev"
TERMUX_PKG_REPLACES="libicu-dev"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/source"
}
