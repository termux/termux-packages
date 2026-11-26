TERMUX_PKG_HOMEPAGE=https://www.cl.cam.ac.uk/~mr10/BCPL.html
TERMUX_PKG_DESCRIPTION="BCPL is a simple typeless language."
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20220718
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.cl.cam.ac.uk/users/mr10/BCPL/bcpl.tgz
TERMUX_PKG_SHA256=77a76474a93d7a772bbe3ce19484f3bd0d45092ed9527d6e160320ee747027f5
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_make() {
	if [ "$MACHTYPE" = "aarch64" -o "$MACHTYPE" = "x86_64" ]; then
		export BCPL64ROOT=$TERMUX_PKG_BUILDDIR/cintcode
		export BCPL64PATH=$BCPL64ROOT/cin64
		export BCPL64HDRS=$BCPL64ROOT/g
		export PATH=$PATH:$BCPL64ROOT/bin
	else
		export BCPLROOT=$TERMUX_PKG_BUILDDIR/cintcode
		export BCPLPATH=$BCPLROOT/cin
		export BCPLHDRS=$BCPLROOT/g
		export PATH=$PATH:$BCPLROOT/bin
	fi
	make -C cintcode clean clean64
	make -C cintcode
}

termux_step_make_install() {
	install -Dm755 -T cintcode/bin/cintsys @TERMUX_PREFIX@/opt/BCPL/bin/cintsys
	cp -r cintcode/cin cintcode/g @TERMUX_PREFIX@/opt/BCPL/
	echo '#!/bin/sh

if [ "$MACHTYPE" = "aarch64" -o "$MACHTYPE" = "x86_64" ]; then
	export BCPL64ROOT=@TERMUX_PREFIX@/opt/BCPL
	export BCPL64PATH=$BCPL64ROOT/cin64
	export BCPL64HDRS=$BCPL64ROOT/g
	export PATH=$PATH:$BCPL64ROOT/bin
else
	export BCPLROOT=@TERMUX_PREFIX@/opt/BCPL
	export BCPLPATH=$BCPLROOT/cin
	export BCPLHDRS=$BCPLROOT/g
	export PATH=$PATH:$BCPLROOT/bin
fi

cintsys $*' > @TERMUX_PREFIX@/bin/bcpl
	chmod +x @TERMUX_PREFIX@/bin/bcpl
}
