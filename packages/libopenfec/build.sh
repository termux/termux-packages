TERMUX_PKG_HOMEPAGE=http://openfec.org
TERMUX_PKG_DESCRIPTION="Application-Level Forward Erasure Correction implementation library"
TERMUX_PKG_LICENSE="CeCILL-C"
TERMUX_PKG_LICENSE_FILE="LICENCE_CeCILL-C_V1-en.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2.4
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://github.com/roc-project/openfec/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=691e3ec41b948e93dd34c690139624e2e20ed390e6a5f000f238491574343a16
TERMUX_PKG_BREAKS="libopenfec-dev"
TERMUX_PKG_REPLACES="libopenfec-dev"

termux_step_make_install() {
	install -Dm600 "$TERMUX_PKG_SRCDIR/bin/Release/libopenfec.so" "$TERMUX_PREFIX/lib/libopenfec.so"

	cd $TERMUX_PKG_SRCDIR/src
	local include; for include in $(find . -type f -iname \*.h | sed 's@^\./@@'); do
		install -Dm600 "$include" "$TERMUX_PREFIX"/include/openfec/"$include"
	done
}
