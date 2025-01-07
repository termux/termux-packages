TERMUX_PKG_HOMEPAGE=https://elkowar.github.io/eww/
TERMUX_PKG_DESCRIPTION="ElKowars wacky widgets"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/elkowar/eww
TERMUX_PKG_DEPENDS="glib, gtk3, gtk-layer-shell, pango, gdk-pixbuf, libcairo, libdbusmenu-gtk3"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/x11rb-protocol-*
	rm -rf $CARGO_HOME/registry/src/*/zbus-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local d p
	p="x11rb-protocol-path.diff"
	for d in $CARGO_HOME/registry/src/*/x11rb-protocol-*; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/${p}" \
			| patch --silent -p1 -d ${d}
	done

	p="zbus-path.diff"
	for d in $CARGO_HOME/registry/src/*/zbus-*; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/${p}" \
			| patch --silent -p1 -d ${d}
	done
}

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/eww
}

termux_step_post_massage() {
	rm -rf $CARGO_HOME/registry/src/*/x11rb-protocol-*
	rm -rf $CARGO_HOME/registry/src/*/zbus-*
}
