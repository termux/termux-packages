TERMUX_PKG_HOMEPAGE=https://prismlauncher.org/
TERMUX_PKG_DESCRIPTION="A custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="TheMightyArie <156929971+TheMightyArie@users.noreply.github.com>"
TERMUX_PKG_VERSION="11.1.1"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
# Has submodules. Must be cloned from Git.
TERMUX_PKG_SRCURL="git+https://github.com/PrismLauncher/PrismLauncher"
TERMUX_PKG_AUTO_UPDATE=false
# i686 has no JDK 25, so we have to install JDK 21 maximum.
TERMUX_PKG_DEPENDS="cmark, glfw, libarchive, libqrencode, openal-soft, openjdk-21, openjdk-21-x, qt6-qtbase-gtk-platformtheme, qt6-qtimageformats, qt6-qtnetworkauth, qt6-qtsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, mesa-dev, qt6-qtimageformats-cross-tools, qt6-qtnetworkauth-cross-tools, qt6-qtsvg-cross-tools, tomlplusplus, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DLauncher_ENABLE_GAMEMODE=OFF
-DLauncher_QT_VERSION_MAJOR=6
-DENABLE_LTO=OFF
"

termux_step_pre_configure() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]] && ! command -v scdoc &> /dev/null; then
		termux_error_exit <<- EOF
			Could not find scdoc.
			It is required to generate man pages for ${TERMUX_PKG_NAME}.
			Use "pkg i scdoc" to ensure it is installed
		EOF
	fi
}
