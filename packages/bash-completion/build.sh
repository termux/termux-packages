TERMUX_PKG_HOMEPAGE=https://github.com/scop/bash-completion
TERMUX_PKG_DESCRIPTION="Programmable completion for the bash shell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.18.0"
TERMUX_PKG_SRCURL="https://github.com/scop/bash-completion/releases/download/${TERMUX_PKG_VERSION}/bash-completion-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=88bcf85124f77f74f2f2f8bcd16ac4382d807a827ede742a64940c7116aea33f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# This package provides completions for many others, and there are a few conflicts.
# In general, prefer a package's own completions if it ships them.
# Conflicts (Package)
#
# interdiff (patchutils)
# makepkg   (pacman)
# tmux      (tmux)
TERMUX_PKG_RM_AFTER_INSTALL="
share/bash-completion/completions/interdiff
share/bash-completion/completions/makepkg
share/bash-completion/completions/tmux
"
