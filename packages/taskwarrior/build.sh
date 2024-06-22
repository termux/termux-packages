TERMUX_PKG_HOMEPAGE=https://taskwarrior.org
TERMUX_PKG_DESCRIPTION="Utility for managing your TODO list"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TERMUX_PKG_VERSION}/task-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=633b76637b0c74e4845ffa28249f01a16ed2c84000ece58d4358e72bf88d5f10
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-glob, libc++, libgnutls, libuuid"
TERMUX_CMAKE_BUILD="Unix Makefiles"

termux_step_pre_configure() {
	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/linkme-*
	cargo fetch --target $CARGO_TARGET_NAME

	local d p
	p="linkme-android.diff"
	for d in $CARGO_HOME/registry/src/*/linkme-0.3.8; do
		patch --silent -p1 -d ${d} \
			< "$TERMUX_PKG_BUILDER_DIR/${p}"
	done

	p="linkme-impl-android.diff"
	for d in $CARGO_HOME/registry/src/*/linkme-impl-0.3.8; do
		patch --silent -p1 -d ${d} \
			< "$TERMUX_PKG_BUILDER_DIR/${p}"
	done

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

termux_step_post_massage() {
	rm -rf $CARGO_HOME/registry/src/*/linkme-*
}
