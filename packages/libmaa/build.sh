TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dict/
TERMUX_PKG_DESCRIPTION="Provides many low-level data structures which are helpful for writing compilers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dict/libmaa/libmaa-${TERMUX_PKG_VERSION}/libmaa-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4e01a9ebc5d96bc9284b6706aa82bddc2a11047fa9bd02e94cf8753ec7dcb98e
TERMUX_PKG_AUTO_UPDATE=false # This package requires mkcmake which is not accessible while building packages
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd ${TERMUX_PKG_SRCDIR}/maa
	awk -f arggram2c < arggram.txt > arggram.c
	$CC -shared -o libmaa.so \
		xmalloc.c hash.c set.c stack.c list.c error.c memory.c string.c \
		debug.c flags.c maa.c prime.c bit.c timer.c arg.c pr.c sl.c \
		base64.c base26.c source.c parse-concrete.c text.c log.c \
		-DMAA_MAJOR=4 -DMAA_MINOR=0 -DMAA_TEENY=0 \
		-DHAVE_HEADER_SYS_RESOURCE_H=1 -DSIZEOF_LONG=__SIZEOF_LONG__ \
		$CFLAGS $LDFLAGS -fPIC
	cd -
}

termux_step_make_install() {
	install -Dm0755 -t "$TERMUX_PREFIX"/lib "${TERMUX_PKG_SRCDIR}"/maa/libmaa.so
	install -Dm0644 -t "$TERMUX_PREFIX"/include "${TERMUX_PKG_SRCDIR}"/maa/maa.h
}
