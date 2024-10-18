TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gcr
TERMUX_PKG_DESCRIPTION="A library for displaying certificates and crypto UI, accessing key stores"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# This specific package is for libgcr-3.
TERMUX_PKG_VERSION="3.41.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gcr/${TERMUX_PKG_VERSION%.*}/gcr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bad10f3c553a0e1854649ab59c5b2434da22ca1a54ae6138f1f53961567e1ab7
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libgcrypt, p11-kit, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, gnupg, valac"
TERMUX_PKG_RECOMMENDS="gnupg"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=true
-Dgtk=true
-Dgtk_doc=false
-Dgpg_path=$TERMUX_PREFIX/bin/gpg
-Dssh_agent=false
-Dsystemd=disabled
"

termux_step_pre_configure() {
	termux_setup_gir

	local bin_dir=$TERMUX_PKG_BUILDDIR/_dummy/bin
	mkdir -p $bin_dir
	pushd $bin_dir
	local p
	for p in ssh-add ssh-agent; do
		cat <<-EOF > $p
			#!$(command -v sh)
			exit 0
			EOF
		chmod 0700 $p
	done
	popd
	export PATH+=":$bin_dir"
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	local _GUARD_FILES="lib/libgcr-3.so lib/libgck-1.so"
	local f
	for f in ${_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "Error: file ${f} not found."
		fi
	done
}
