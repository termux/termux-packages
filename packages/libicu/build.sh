TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_VERSION=61.1
TERMUX_PKG_SHA256=d007f89ae8a2543a53525c74359b65b36412fa84b3349f1400be6dcf409fafef
TERMUX_PKG_SRCURL=http://download.icu-project.org/files/icu4c/${TERMUX_PKG_VERSION/_/}/icu4c-${TERMUX_PKG_VERSION//./_}-src.tgz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/icu-config share/man/man1/icu-config.1 lib/icu share/icu"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/source"
}
