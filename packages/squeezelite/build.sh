TERMUX_PKG_HOMEPAGE=https://ralph-irving.github.io/squeezelite.html
TERMUX_PKG_DESCRIPTION="A small headless Logitech Squeezebox emulator"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=663db8f64d73dceca6a2a18cdb705ad846daa272
TERMUX_PKG_VERSION=1.9.9.1430
TERMUX_PKG_SRCURL=git+https://github.com/ralph-irving/squeezelite
TERMUX_PKG_SHA256=f59c029c033854cc4d52d72061cdbfac25efc4f4423ae78ec0a40ff52f305a43
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libflac, libmad, libvorbis, mpg123, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi

	local ver=()
	local k
	for k in MAJOR MINOR MICRO; do
		ver+=($(sed -En 's/^#define '"${k}"'_VERSION "([^"]+)"/\1/p' squeezelite.h))
	done
	if [ "$(IFS=.; echo "${ver[*]}")" != "${TERMUX_PKG_VERSION#*:}" ]; then
		termux_error_exit "Version string '$TERMUX_PKG_VERSION' does not seem to be correct."
	fi
}

termux_step_pre_configure() {
	export OPTS="-DLINKALL -DNO_FAAD -DPULSEAUDIO"
	export LDADD="-lm"
}

termux_step_make_install() {
	install -Dm700 squeezelite $TERMUX_PREFIX/bin/
}
