TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/bionic/+/refs/heads/master/libc/bionic/sys_sem.cpp
TERMUX_PKG_DESCRIPTION="A shared library providing System V semaphores"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	local f
	for f in LICENSE sys_sem.{c,h}; do
		cp $TERMUX_PKG_BUILDER_DIR/${f} ./
	done
}

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
	CFLAGS+=" -fPIC"
}

termux_step_make() {
	$CC $CFLAGS $CPPFLAGS sys_sem.c -c
	$CC $CFLAGS sys_sem.o -shared $LDFLAGS -o libandroid-sysv-semaphore.so
	$AR cru libandroid-sysv-semaphore.a sys_sem.o
}

termux_step_make_install() {
	install -Dm600 -t $TERMUX_PREFIX/lib libandroid-sysv-semaphore.{a,so}
	install -Dm600 -T sys_sem.h $TERMUX_PREFIX/include/sys/sem.h
}
