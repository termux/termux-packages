TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/synaptic/
TERMUX_PKG_DESCRIPTION="Synaptic is a graphical package management tool based on GTK+ and APT."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=0.90.1
_COMMIT=a85c743e10e39a43737d5f8a0f0cc4ea755eb545
TERMUX_PKG_SRCURL=https://github.com/mvo5/synaptic/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=a500cfeea6c4ec4463b42495cba224b9548acbd557e9da695730acf7e49e0798
TERMUX_PKG_DEPENDS="apt, dpkg, gtk3, atk, libvte, hicolor-icon-theme"
TERMUX_PKG_RECOMMENDS="netsurf"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure(){
	NOCONFIGURE=1 ./autogen.sh
}


termux_step_post_make_install(){
	install -Dm700 -t ${TERMUX_PREFIX}/bin ./gtk/synaptic
}
