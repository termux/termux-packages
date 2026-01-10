TERMUX_PKG_HOMEPAGE=https://github.com/lgi-devs/lgi
TERMUX_PKG_DESCRIPTION="Dynamic Lua binding to GObject libraries using GObject-Introspection"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT_DATE=20251219
_COMMIT_HASH=a1308b23b07a787d21fad86157b0b60eb3079f64
TERMUX_PKG_VERSION=0.9.2-p$_COMMIT_DATE
TERMUX_PKG_SRCURL=git+https://github.com/lgi-devs/lgi
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=23fd016fecd027b456f8fb38b2b79fb45f85bf580895caf2b4aa4f651502f080
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libffi, liblua54"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT_HASH"

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	pwd
	echo $s
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	# Use makefile instead of meson.
	rm -f "$TERMUX_PKG_SRCDIR"/meson*
}
