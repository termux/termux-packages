TERMUX_PKG_HOMEPAGE=https://github.com/libhangul/libhangul
TERMUX_PKG_DESCRIPTION="A library to support hangul input method logic"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=154a5e0f13aebc80a465336642a406d6ddfc06cf
_COMMIT_DATE=20230415
TERMUX_PKG_VERSION=0.1.0-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/libhangul/libhangul.git
TERMUX_PKG_SHA256=e1dd5bf2553f2676ac05e99069c6fd0eaa1b24c283b12678b780ea70a19a664d
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="libandroid-glob, libexpat, libiconv"

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
		termux_error_exit "Checksum mismatch for source files $s."
	fi
}

termux_step_pre_configure() {
	# prefer autotools
	rm CMakeLists.txt
	./autogen.sh

	LDFLAGS+=" -landroid-glob"
}
