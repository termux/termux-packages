TERMUX_PKG_HOMEPAGE=https://www.si6networks.com/research/tools/ipv6toolkit/
TERMUX_PKG_DESCRIPTION="SI6 Networks IPv6 Toolkit"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=367bbe60489a6ae68898b9c81e672b48ad81df43
TERMUX_PKG_VERSION=2022.09.30
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/fgont/ipv6toolkit
TERMUX_PKG_SHA256=56afd0b9a4c749b502b86ac640f21121aabc734afbfd49db8eb1feea90d4edbb
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libpcap, resolv-conf"
TERMUX_PKG_RECOMMENDS="curl, perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	rm -f Makefile
}
