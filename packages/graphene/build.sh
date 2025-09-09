TERMUX_PKG_HOMEPAGE=https://ebassi.github.io/graphene/
TERMUX_PKG_DESCRIPTION="A thin layer of graphic data types"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.8
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/graphene/${_MAJOR_VERSION}/graphene-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a37bb0e78a419dcbeaa9c7027bcff52f5ec2367c25ec859da31dfde2928f279a
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_CONFLICTS="gst-plugins-base (<< 1.20.3-1)"
TERMUX_PKG_BREAKS="gst-plugins-base (<< 1.20.3-1)"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local pywrap="$TERMUX_PKG_BUILDDIR/_bin/python-wrapper"
		mkdir -p "$(dirname "$pywrap")"
		cat > "$pywrap" <<-EOF
			#!/bin/bash-static
			unset LD_LIBRARY_PATH
			exec /usr/bin/python3 "\$@"
		EOF
		chmod 0700 "$pywrap"
		echo "Applying wrap-python.diff"
		sed -e "s|@PYTHON_WRAPPER@|${pywrap}|g" \
			"$TERMUX_PKG_BUILDER_DIR/wrap-python.diff" \
			| patch --silent -p1 -d "$TERMUX_PKG_SRCDIR"
	fi
}
