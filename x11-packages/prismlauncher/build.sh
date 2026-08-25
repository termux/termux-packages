TERMUX_PKG_HOMEPAGE=https://prismlauncher.org/
TERMUX_PKG_DESCRIPTION="A custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="11.1.1"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
# Has submodules. Must be cloned from Git.
TERMUX_PKG_SRCURL="git+https://github.com/PrismLauncher/PrismLauncher"
TERMUX_PKG_AUTO_UPDATE=true
# i686 has no JDK 25, so we have to install JDK 21 maximum.
TERMUX_PKG_DEPENDS="cmark, glfw, libarchive, libqrencode, openal-soft, openjdk-21, openjdk-21-x, qt6-qtbase-gtk-platformtheme, qt6-qtimageformats, qt6-qtnetworkauth, qt6-qtsvg, zlib"
TERMUX_PKG_RECOMMENDS="lwjgl3-3.4.3"
TERMUX_PKG_SUGGESTS="lwjgl2, lwjgl3-3.2.1, lwjgl3-3.2.2, lwjgl3-3.3.1, lwjgl3-3.3.2, lwjgl3-3.3.3, lwjgl3-3.3.6, lwjgl3-3.4.1, lwjgl3-3.4.2"
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

termux_step_create_debscripts() {
	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/postinst.sh" > postinst
	chmod u+x postinst
}
