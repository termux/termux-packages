TERMUX_PKG_HOMEPAGE=https://ebassi.github.io/graphene/
TERMUX_PKG_DESCRIPTION="A thin layer of graphic data types"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.8
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/graphene/${_MAJOR_VERSION}/graphene-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a37bb0e78a419dcbeaa9c7027bcff52f5ec2367c25ec859da31dfde2928f279a
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_CONFLICTS="gst-plugins-base (<< 1.20.3-1)"
TERMUX_PKG_BREAKS="gst-plugins-base (<< 1.20.3-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
"
