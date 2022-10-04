TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gcr
TERMUX_PKG_DESCRIPTION="A library for displaying certificates and crypto UI, accessing key stores"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=3.41
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gcr/${_MAJOR_VERSION}/gcr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bb7128a3c2febbfee9c03b90d77d498d0ceb237b0789802d60185c71c4bea24f
TERMUX_PKG_DEPENDS="glib, gtk3, libcairo, libgcrypt, p11-kit, pango"
TERMUX_PKG_BUILD_DEPENDS="gnupg"
TERMUX_PKG_RECOMMENDS="gnupg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=false
-Dgtk=true
-Dgtk_doc=false
-Dgpg_path=$TERMUX_PREFIX/bin/gpg
-Dssh_agent=false
-Dsystemd=disabled
"

termux_step_pre_configure() {
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
}
