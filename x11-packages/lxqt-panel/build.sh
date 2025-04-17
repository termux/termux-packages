TERMUX_PKG_HOMEPAGE=https://lxqt.github.io
TERMUX_PKG_DESCRIPTION="The LXQt desktop panel"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.0"
TERMUX_PKG_SRCURL="https://github.com/lxqt/lxqt-panel/releases/download/${TERMUX_PKG_VERSION}/lxqt-panel-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e5011840140fe1c06cfe4deadbb1a88c0395b33d274c2a68d7e657b6622f1adb
TERMUX_PKG_DEPENDS="kf6-kwindowsystem, layer-shell-qt, libc++, libdbusmenu-lxqt, liblxqt, libqtxdg, libsysstat, libxcb, libxkbcommon, libxtst, libx11, lxqt-globalkeys, lxqt-menu-data, pulseaudio, qt6-qtbase, xcb-util, xcb-util-image"
TERMUX_PKG_BUILD_DEPENDS="lxqt-build-tools, qt6-qttools"
# TODO
# CPULOAD and NETWORKMONITOR require libstatgrab
# MOUNT plugin requires KF5Solid
# SENSORS plugin requires lm_sensors
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCPULOAD_PLUGIN=OFF
-DNETWORKMONITOR_PLUGIN=OFF
-DMOUNT_PLUGIN=OFF
-DSENSORS_PLUGIN=OFF
-DVOLUME_USE_ALSA=OFF
-DQt6LinguistTools_DIR=${TERMUX_PREFIX}/opt/qt6/cross/lib/cmake/Qt6LinguistTools
"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# Add RUNPATH to the private libraries used by lxqt-panel's plugins
	LDFLAGS+=" -Wl,-rpath=${TERMUX_PREFIX}/lib/lxqt-panel"
	export LDFLAGS
}
