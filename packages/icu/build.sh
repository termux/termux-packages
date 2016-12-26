TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/libidn/
TERMUX_PKG_DESCRIPTION="GNU Libidn library, implementation of IETF IDN specifications"
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
