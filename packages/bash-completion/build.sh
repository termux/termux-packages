TERMUX_PKG_HOMEPAGE=https://github.com/scop/bash-completion
TERMUX_PKG_DESCRIPTION="Programmable completion for the bash shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.17.0"
TERMUX_PKG_REVISION="1"
TERMUX_PKG_SRCURL=https://github.com/scop/bash-completion/releases/download/${TERMUX_PKG_VERSION}/bash-completion-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dd9d825e496435fb3beba3ae7bea9f77e821e894667d07431d1d4c8c570b9e58
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# This package provides completions for many others, and there are a few conflicts.
TERMUX_PKG_RM_AFTER_INSTALL="
share/bash-completion/completions/makepkg
share/bash-completion/completions/tmux
"
