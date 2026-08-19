TERMUX_PKG_HOMEPAGE=https://man7.org/linux/man-pages/man3/fexecve.3.html
TERMUX_PKG_DESCRIPTION="Shared library for the fexecve(3) system function"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make() {
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/fexecve.c"
	"${CC}" ${CFLAGS} ${LDFLAGS} -shared fexecve.o -o libandroid-fexecve.so
	"${AR}" rcu libandroid-fexecve.a fexecve.o
	cp -f "${TERMUX_PKG_BUILDER_DIR}/COPYRIGHT" "${TERMUX_PKG_SRCDIR}/"
}

termux_step_make_install() {
	install -Dm644 -t "${TERMUX_PREFIX}/lib" libandroid-fexecve.{a,so}
}
