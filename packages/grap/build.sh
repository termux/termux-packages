TERMUX_PKG_HOMEPAGE=https://www.lunabase.org/~faber/Vault/software/grap/
TERMUX_PKG_DESCRIPTION="Grap allow to display graphs in a Groff workflow."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@xingguangcuican6666"
TERMUX_PKG_VERSION="1.49"
TERMUX_PKG_SRCURL="https://github.com/snorerot13/grap/archive/refs/heads/master.zip"
TERMUX_PKG_SHA256=0134e7d8ca6464185e1a786f820dd0a78821defe377a8fce489a48879445ef0c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/LICENSE ./
}

termux_step_pre_configure() {
	autoreconf -fi
}