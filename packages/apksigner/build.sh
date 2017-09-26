TERMUX_PKG_HOMEPAGE=https://github.com/fornwall/apksigner
TERMUX_PKG_DESCRIPTION="APK signing tool"
TERMUX_PKG_VERSION=0.4
TERMUX_PKG_SRCURL=https://github.com/fornwall/apksigner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1da8fecccf5fadef94a5ba05c19fe4e95a695407550d9fe1ed34e48efd9d1b68
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make () {
	mkdir -p $TERMUX_PREFIX/share/{dex,man/man1}

	ant
	$TERMUX_DX --dex --output $TERMUX_PREFIX/share/dex/apksigner.dex apksigner.jar
	echo '#!/bin/sh' > $TERMUX_PREFIX/bin/apksigner
	echo "dalvikvm -cp $TERMUX_PREFIX/share/dex/apksigner.dex net.fornwall.apksigner.Main \$@" >> $TERMUX_PREFIX/bin/apksigner
	chmod +x $TERMUX_PREFIX/bin/apksigner

	cp apksigner.1 $TERMUX_PREFIX/share/man/man1/
}
