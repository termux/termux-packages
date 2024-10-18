TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org
TERMUX_PKG_DESCRIPTION="A socket daemon to multiplex connections from and to iOS devices"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=049877e1f7a54f63fef12dd384c9a22fb38b3514
_COMMIT_DATE=20230421
TERMUX_PKG_VERSION=1.1.1-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/libimobiledevice/usbmuxd
TERMUX_PKG_SHA256=4bf82bd3b7451139114ea0545e0d10f8d45fb813be008d91dad814d93f96b40c
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libimobiledevice-glue, libplist, libusb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-preflight
--without-systemd
"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
