TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/
TERMUX_PKG_DESCRIPTION="ICU is a library providing unicode and globalization support."
TERMUX_PKG_VERSION=58.2
TERMUX_PKG_SRCURL="http://download.icu-project.org/files/icu4c/${TERMUX_PKG_VERSION/_/}/icu4c-${TERMUX_PKG_VERSION//./_}-src.tgz"
TERMUX_PKG_FOLDERNAME="icu/source"
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-samples 
--disable-tests
--with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR
"
