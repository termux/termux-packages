TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_VERSION=60.2
TERMUX_PKG_SHA256=f073ea8f35b926d70bb33e6577508aa642a8b316a803f11be20af384811db418
TERMUX_PKG_SRCURL=http://download.icu-project.org/files/icu4c/${TERMUX_PKG_VERSION/_/}/icu4c-${TERMUX_PKG_VERSION//./_}-src.tgz
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/icu-config share/man/man1/icu-config.1 lib/icu share/icu"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'

termux_step_post_extract_package() {
	TERMUX_PKG_SRCDIR+="/source"
}
