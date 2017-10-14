TERMUX_PKG_HOMEPAGE=https://vifm.info/
TERMUX_PKG_DESCRIPTION="Vifm is an ncurses based file manager with vi like keybindings/modes/options/commands/configuration"
TERMUX_PKG_VERSION=0.9
TERMUX_PKG_SRCURL=https://github.com/vifm/vifm/archive/v0.9.tar.gz
TERMUX_PKG_SHA256=837337935627dafaff90da300dea0e35dd9ad1eb932294274ababee814f91649
TERMUX_PKG_DEPENDS="ncurses, file"

termux_step_pre_configure() {
	autoreconf -if
}
