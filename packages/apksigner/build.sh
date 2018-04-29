TERMUX_PKG_HOMEPAGE=https://github.com/fornwall/apksigner
TERMUX_PKG_DESCRIPTION="APK signing tool"
TERMUX_PKG_VERSION=0.7
TERMUX_PKG_SHA256=340560c4f75af3501f037452bcf184fa48fd18bc877a4cce9a51a3fa047b4b38
TERMUX_PKG_SRCURL=https://github.com/fornwall/apksigner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make () {
	mkdir -p $TERMUX_PREFIX/share/{dex,man/man1}

	./gradlew
	$TERMUX_DX --dex --output $TERMUX_PREFIX/share/dex/apksigner.dex ./build/libs/src-all.jar
	echo '#!/bin/sh' > $TERMUX_PREFIX/bin/apksigner
	echo "dalvikvm -cp $TERMUX_PREFIX/share/dex/apksigner.dex net.fornwall.apksigner.Main \$@" >> $TERMUX_PREFIX/bin/apksigner
	chmod +x $TERMUX_PREFIX/bin/apksigner

	cp apksigner.1 $TERMUX_PREFIX/share/man/man1/
}
