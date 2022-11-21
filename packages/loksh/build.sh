TERMUX_PKG_HOMEPAGE=https://github.com/dimkr/loksh
TERMUX_PKG_DESCRIPTION="A Linux port of OpenBSD's ksh"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=7.2
TERMUX_PKG_SRCURL=https://github.com/dimkr/loksh.git
TERMUX_PKG_GIT_BRANCH=$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="ncurses"

termux_step_post_get_source() {
	pushd subprojects/lolibc
	mv include _include_lolibc
	mkdir include
	mv _include_lolibc include/lolibc
	pushd include/lolibc
	local _LOLIBC_HEADERS=$(find * -name '*.h')
	popd
	popd
	local f
	for f in $(find . -name '*.[ch]'); do
		local h
		for h in ${_LOLIBC_HEADERS}; do
			sed -i "s:#include <${h//./\\.}>:#include <lolibc/${h}>:g" ${f}
		done
	done
	cd subprojects/lolibc/include/lolibc
	for f in ${_LOLIBC_HEADERS}; do
		sed -i "s:#include_next :#include :g" ${f}
	done
}
