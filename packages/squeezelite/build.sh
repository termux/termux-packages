TERMUX_PKG_HOMEPAGE=https://ralph-irving.github.io/squeezelite.html
TERMUX_PKG_DESCRIPTION="A small headless Logitech Squeezebox emulator"
TERMUX_PKG_LICENSE="GPL-3.0, BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=dbe69eb8aa88f644cfb46541d6cef72fa666570d
TERMUX_PKG_VERSION=1.9.9.1414
TERMUX_PKG_SRCURL=https://github.com/ralph-irving/squeezelite.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libflac, libmad, libvorbis, mpg123, pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

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
