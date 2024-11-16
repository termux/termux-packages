TERMUX_PKG_HOMEPAGE=https://polybar.github.io
TERMUX_PKG_DESCRIPTION="A fast and easy-to-use status bar"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.2"
TERMUX_PKG_SRCURL="https://github.com/polybar/polybar/releases/download/${TERMUX_PKG_VERSION}/polybar-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e2feacbd02e7c94baed7f50b13bcbf307d95df0325c3ecae443289ba5b56af29
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, jsoncpp, libandroid-glob, libc++, libcairo, libcurl, libnl, libuv, libxcb, pulseaudio, xcb-util-cursor, xcb-util-image, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_DEPENDS="i3"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_I3=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_extra() {
  local PREFIX_LOCAL="/data/data/com.termux/files/usr/"
  local HOME_LOCAL="$(find /data/data/com.termux/files -type d -iname 'home*')"
  local HOME_CACHE="${HOME_LOCAL}/.cache"
  local POLYBAR_BACKUP_DIR="${HOME_LOCAL}/.backup/polybar"

  if [[ ! -f ${HOME_CACHE}/termux ]]; then
       $(printf "${SHELL}\n" | sed -E "s|${PREFIX_LOCAL}/bin/||") -c "mkdir --parent --verbose --mode=755 $HOME/.cache/termux"
  fi

  if [[ ! -f ${POLYBAR_BACKUP_DIR} ]]; then
       $(printf "${SHELL}\n" | sed -E "s|${PREFIX_LOCAL}/bin/||") -c "mkdir --parent --verbose --mode=755 $HOME/.backup/polybar" | tee -a ${HOME_CACHE}/termux/polyCreate.log
  fi

  if [[ -f ${PREFIX_LOCAL}/etc/polybar/config.ini ]]; then
       if [[ -f ${POLYBAR_BACKUP_DIR} ]]; then
            rm --recursive --force --preserve-root --verbose ${POLYBAR_BACKUP_DIR} | tee -a ${HOME_CACHE}/termux/polybar-config-remove.log
       fi

       mv --verbose ${PREFIX_LOCAL}/etc/polybar/config.ini ${POLYBAR_BACKUP_DIR} | sed -E "s|renamed|moved and renamed|g"
       rm --recursive --force --preserve-root --verbose ${PREFIX_LOCAL}/etc/config.ini
       cp --recursive --force --verbose ${POLYBAR_BACKUP_DIR} ${PREFIX_LOCAL}/etc/polybar/config.ini
  fi
}
