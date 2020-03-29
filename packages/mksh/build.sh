TERMUX_PKG_HOMEPAGE=https://www.mirbsd.org/mksh.htm
TERMUX_PKG_DESCRIPTION="The MirBSD Korn Shell - an enhanced version of the public domain ksh"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=58
TERMUX_PKG_SRCURL=https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R${TERMUX_PKG_VERSION/./}.tgz
TERMUX_PKG_SHA256=608beb7b71870b23309ba1da8ca828da0e4540f2b9bd981eb39e04f8b7fc678c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	sh Build.sh -r
}

termux_step_make_install() {
	install -Dm700 mksh "$TERMUX_PREFIX"/bin/mksh
	install -Dm600 mksh.1 "$TERMUX_PREFIX"/share/man/man1/mksh.1
}
