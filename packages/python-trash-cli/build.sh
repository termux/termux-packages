TERMUX_PKG_HOMEPAGE=https://github.com/andreafrancia/trash-cli
TERMUX_PKG_DESCRIPTION="Command line trashcan (recycle bin) interface"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.26.9.29"
TERMUX_PKG_SRCURL="https://github.com/andreafrancia/trash-cli/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=33ec648238d291f1fd247bea9a260ab158528e184b3f83c9da10ea792bd4cdd2
TERMUX_PKG_DEPENDS="python, python-psutil, python-pip"
TERMUX_PKG_PYTHON_TARGET_DEPS="six"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="six, shtab, build, installer"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

termux_step_post_make_install() {
	local cmd
	for cmd in trash-empty trash-list trash-restore trash-put trash; do
		./$cmd --print-completion bash > ./"$cmd"-completion
		./$cmd --print-completion zsh > ./_"$cmd"-completion
		install -vDm 644 ./"$cmd"-completion "$TERMUX_PREFIX/share/bash-completion/completions/$cmd"
		install -vDm 644 ./_"$cmd"-completion "$TERMUX_PREFIX/share/zsh/site-functions/_$cmd"
	done
}
