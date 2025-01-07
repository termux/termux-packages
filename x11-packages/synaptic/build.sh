TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/synaptic/
TERMUX_PKG_DESCRIPTION="Synaptic is a graphical package management tool based on GTK+ and APT."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.91.4"
TERMUX_PKG_SRCURL=https://github.com/mvo5/synaptic/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=274e6e2cd051f5e0c79e961c5516eb91f689369f33a0ad3d949c3b4530f1fa5d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="apt, dpkg, gdk-pixbuf, glib, gtk3, libc++, libvte, pango"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme, netsurf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	NOCONFIGURE=1 ./autogen.sh
	# Fix "error: no template named binary_function" (binary_function was removed in c++17):
	CXXFLAGS+=" -std=c++14"
}


termux_step_post_make_install(){
	install -Dm700 -t ${TERMUX_PREFIX}/bin ./gtk/synaptic
}
