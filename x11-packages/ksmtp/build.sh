TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/ksmtp"
TERMUX_PKG_DESCRIPTION="Job-based library to send email through an SMTP server"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ksmtp-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=227c0578def79612a4cae9745445e5dff023458ffffabf305e06d953248f72a0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kio, libc++, libsasl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
