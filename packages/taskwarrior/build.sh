TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TERMUX_PKG_VERSION}/task-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ae67c74b84067573a53095cf3cb6718245dd7dd808f19f9b3d85da445838b4f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libgnutls, libuuid"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	termux_setup_rust

	LDFLAGS+=" -landroid-glob"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# See https://cmake.org/cmake/help/latest/variable/CMAKE_ANDROID_ARM_MODE.html
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_ANDROID_ARM_MODE=ON"
	fi
}

termux_step_post_make_install() {
	install -Dm600 -T "$TERMUX_PKG_SRCDIR"/scripts/bash/task.sh \
		$TERMUX_PREFIX/share/bash-completion/completions/task
	install -Dm600 -t $TERMUX_PREFIX/share/fish/vendor_completions.d \
		"$TERMUX_PKG_SRCDIR"/scripts/fish/task.fish
}
