TERMUX_PKG_HOMEPAGE=https://git.osgeo.org/gitea/rttopo/librttopo
TERMUX_PKG_DESCRIPTION="The RT Topology Library exposes an API to create and manage standard topologies"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=git+https://git.osgeo.org/gitea/rttopo/librttopo
TERMUX_PKG_GIT_BRANCH="librttopo-$TERMUX_PKG_VERSION"
TERMUX_PKG_SHA256=98c8a5acbc4db5fbe5ccb03c9577221bda1135c50301f45d67d6f8d2405feb3f
TERMUX_PKG_DEPENDS="libgeos, proj"
TERMUX_PKG_GROUPS="science"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		echo "$s"
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	./autogen.sh
}
