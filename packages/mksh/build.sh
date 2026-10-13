TERMUX_PKG_HOMEPAGE=http://www.mirbsd.org/mksh.htm
TERMUX_PKG_DESCRIPTION="The MirBSD Korn Shell - an enhanced version of the public domain ksh"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=59c
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://mbsd.evolvis.org/MirOS/dist/mir/mksh/mksh-R${TERMUX_PKG_VERSION}.tgz"
TERMUX_PKG_SHA256=77ae1665a337f1c48c61d6b961db3e52119b38e58884d1c89684af31f87bc506
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Extract license from FAQ2HTML and save it to a new LICENSE file
	sed -n \
		-e '/^# Copyright$/,/when using the work as intended.$/p' \
		-e 's/^# //p' FAQ2HTML.sh > "$TERMUX_PKG_SRCDIR/LICENSE"
}

termux_step_make() {
	export CFLAGS="$CFLAGS -DMKSH_ASSUME_UTF8 -DHAVE_PERSISTENT_HISTORY"
	sh Build.sh -r
}

termux_step_make_install() {
	install -Dm700 mksh "$TERMUX_PREFIX/bin/mksh"
	install -Dm600 mksh.1 "$TERMUX_PREFIX/share/man/man1/mksh.1"
}
