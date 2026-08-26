TERMUX_PKG_HOMEPAGE=https://www.pgadmin.org/
TERMUX_PKG_DESCRIPTION="Feature-rich web-based administration and development platform for PostgreSQL"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=9.17
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="python, python-cryptography, python-psutil, python-pip"
TERMUX_PKG_BUILD_DEPENDS="python-pip"
_WHL_URL="https://files.pythonhosted.org/packages/46/87/1412ac64d462f985756d2832187aaff0b0e4dcb601a7be9ec5d0bc129975/pgadmin4-${TERMUX_PKG_VERSION}-py3-none-any.whl"
_WHL_SHA256="f11d217e6fcfea8573c297d8228082a921c6a553020cc130d0fcda3ae87e4684"

termux_step_make_install() {
	local whl="$TERMUX_PKG_TMPDIR/pgadmin4-${TERMUX_PKG_VERSION}-py3-none-any.whl"
	curl -Lo "$whl" "$_WHL_URL"
	echo "$_WHL_SHA256  $whl" | sha256sum -c -

	# IMPORTANT: use Termux's own pip ($TERMUX_PREFIX/bin/pip), not the
	# build-container's host system pip. The host system's Debian-patched
	# Python inserts a "local/" + "dist-packages" layout and uses its own
	# (host) Python version, which breaks both the install path and the
	# generated "pgadmin4" console-script entry point at runtime.
	"$TERMUX_PREFIX/bin/pip" install --no-deps --prefix="$TERMUX_PREFIX" "$whl"

	mkdir -p "$TERMUX_PKG_SRCDIR"
	# The pgadmin4 wheel does NOT ship a LICENSE file inside its dist-info
	# Fetch the official license text straight from upstream instead.
	curl -Lo "$TERMUX_PKG_SRCDIR/LICENSE" \
		"https://raw.githubusercontent.com/pgadmin-org/pgadmin4/master/LICENSE"
	if [ ! -s "$TERMUX_PKG_SRCDIR/LICENSE" ]; then
		termux_error_exit "pgadmin4: failed to download LICENSE from upstream"
	fi
}
