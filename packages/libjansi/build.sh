TERMUX_PKG_HOMEPAGE=https://fusesource.github.io/jansi/
TERMUX_PKG_DESCRIPTION="A small java library that allows you to use ANSI escape codes to format your console output"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.4.1"
TERMUX_PKG_SRCURL=git+https://github.com/fusesource/jansi
TERMUX_PKG_GIT_BRANCH=jansi-${TERMUX_PKG_VERSION}
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_download https://raw.githubusercontent.com/openjdk/jdk/jdk-11%2B28/src/java.base/unix/native/include/jni_md.h \
		${TERMUX_PKG_CACHEDIR}/jni_md.h 48888b52ef525a8c92985b501162b2e4ca7bb2a742456e4c053c1417e8ccfff2
}

termux_step_make() {
	local s=$TERMUX_PKG_SRCDIR/src/main/native/jansi
	${CC} -o ${TERMUX_PKG_SRCDIR}/libjansi.so \
		${s}.c ${s}_isatty.c ${s}_structs.c ${s}_ttyname.c \
		${CFLAGS} -fPIC -I${TERMUX_PKG_CACHEDIR} ${LDFLAGS} -shared
}

termux_step_make_install() {
	install -Dm700 -t ${TERMUX_PREFIX}/lib/jansi ${TERMUX_PKG_SRCDIR}/libjansi.so
}
