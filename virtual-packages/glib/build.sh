TERMUX_VIRTUAL_PKG_SRC="packages/glib"
TERMUX_VIRTUAL_PKG_ANTI_DEPENDS="gobject-introspection"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/"-Dintrospection=enabled"/"-Dintrospection=disabled"}"
TERMUX_PKG_HOSTBUILD=false

termux_step_pre_configure() {
	CFLAGS+=" -D__BIONIC__=1"
	termux_setup_gir
}

termux_step_post_make_install() {
	return
}

termux_step_post_massage() {
	return
}
