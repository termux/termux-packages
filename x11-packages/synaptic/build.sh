TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/synaptic/
TERMUX_PKG_DESCRIPTION="Synaptic is a graphical package management tool based on GTK+ and APT."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION=0.91.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mvo5/synaptic/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b943c32c56aca8a133059bae3df01b64b6bb4687b33250d92efb5d6098a606b
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
