TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/kglobalaccel'
TERMUX_PKG_DESCRIPTION='Add support for global workspace shortcuts'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kglobalaccel-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=332e3be3d0ac2aec8e786419c1e875a1b33ae84b8aada3283639deccc6ffd4d8
TERMUX_PKG_DEPENDS="qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_post_make_install() {
	mkdir -p "$PREFIX/share/dbus-1/services"

	cat > "$PREFIX/share/dbus-1/services/org.kde.kglobalaccel.service" <<EOF
[D-BUS Service]
Name=org.kde.kglobalaccel
Exec=$PREFIX/lib/libexec/kglobalacceld
EOF
}
