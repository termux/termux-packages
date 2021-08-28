TERMUX_PKG_HOMEPAGE=http://www.newlisp.org/
TERMUX_PKG_DESCRIPTION="newLISP is a general-purpose scripting language."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.7.5
TERMUX_PKG_SRCURL=http://www.newlisp.org/downloads/newlisp-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=dc2d0ff651c2b275bc4af3af8ba59851a6fb6e1eaddc20ae75fb60b1e90126ec
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true


termux_step_post_configure() {
	cp makefile_linux_openwrt makefile_linux_termux
	sed -e "s%mips-openwrt-linux-gcc%$TERMUX_ARCH-linux-android-clang%g" \
	    -e "s%mips-openwrt-linux-ld%$TERMUX_ARCH-linux-android-ld%g"  \
	    -e "/upx/d" -e "/mv/d" -e "s/rm/strip/g" \
	    -e "s%-DLINUX%-DLINUX\ -DREADLINE\ -lreadline\ -lncurses%g" \
	    -e 's/makefile_linux_openwrt/makefile_linux_termux/g' \
	    -e "s/\s\$(OBJS)/\$(OBJS)/g" \
	    -e "s/\s\s\s\s\$(CC)\ /\t\$(CC)\ /g" \
	    -e "s%\$(TARGET_DIR)/usr%$TERMUX_PREFIX%g" -i makefile_linux_termux
	sed -i "s%/usr/bin%$TERMUX_PREFIX/bin%g" newlisp.c
	sed -i "s%sys/sem.h%linux/sem.h%g" nl-filesys.c
}

termux_step_make() {
	make -f makefile_linux_termux
}
termux_step_make_install() {
	sed -i -e "s%/usr/local/$TERMUX_PREFIX%g" makefile_install
	make -f makefile_install
}
