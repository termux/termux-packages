TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/enscript/
TERMUX_PKG_DESCRIPTION="Enscript converts ASCII text files to PostScript, HTML, RTF, ANSI and overstrikes"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.6.6
TERMUX_PKG_REVISION=11
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/enscript/enscript-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb
TERMUX_PKG_DEPENDS="cups, perl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --sysconfdir=$TERMUX_PREFIX/etc/enscript"

termux_step_post_make_install() {
	cd "$TERMUX_PREFIX"/bin && patch -i "$TERMUX_PKG_BUILDER_DIR"/diffpp.patch.txt
	cd "$TERMUX_PREFIX"/etc/enscript && patch -i "$TERMUX_PKG_BUILDER_DIR"/enscript.cfg.patch.txt
}
