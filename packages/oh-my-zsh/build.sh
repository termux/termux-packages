TERMUX_PKG_HOMEPAGE=https://github.com/sumithemmadi/ohmyzsh
TERMUX_PKG_NAME="oh-my-zsh"
TERMUX_PKG_DESCRIPTION="A community-driven framework for managing your zsh configuration. Includes 180+ optional plugins and over 120 themes to spice up your morning, and an auto-update tool so that makes it easy to keep up with the latest updates from the community"
TERMUX_PKG_LICENSE="MIT License"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Sumith Emmadi <sumithemmadi244@gmail.com>"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/sumithemmadi/ohmyzsh.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="zsh,git,python"

termux_step_make_install() {
  cd "${TERMUX_PKG_SRCDIR}"

  mkdir -p "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  mkdir -p "${TERMUX_PREFIX}/usr/share/LICENSES/${TERMUX_PKG_NAME}"
  echo $PWD
  install -m644 "${TERMUX_PKG_SRCDIR}/zshrc.zsh-termux-template" "${HOME}/.zshrc"
  install -m644 "${TERMUX_PKG_SRCDIR}/LICENSE.txt" "${TERMUX_PREFIX}/usr/share/LICENSES/${TERMUX_PKG_NAME}/LICENSE"
  install -m644 "${TERMUX_PKG_SRCDIR}/CODE_OF_CONDUCT.md" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  install -m644 "${TERMUX_PKG_SRCDIR}/LICENSE.txt" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  install -m644 "${TERMUX_PKG_SRCDIR}/CONTRIBUTING.md" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  install -m644 "${TERMUX_PKG_SRCDIR}/README.md" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  install -m644 "${TERMUX_PKG_SRCDIR}/SECURITY.md" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  install -m644 "${TERMUX_PKG_SRCDIR}/oh-my-zsh.sh" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/cache" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/custom" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/lib" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/log" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/plugins" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/templates" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/themes" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  cp -rf "${TERMUX_PKG_SRCDIR}/tools" "${TERMUX_PREFIX}/usr/share/oh-my-zsh"
  echo "To change shell run 'chsh -s /bin/zsh'"
}
