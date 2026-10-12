TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/mtpaint/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=8304376e8861a8a603371b0f188db30f9cafdc17
TERMUX_PKG_VERSION="1:3.50.14"
TERMUX_PKG_SRCURL=https://github.com/wjaguar/mtPaint/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=73979c7b92dfd2f7da116fcb8a6beba091f5fe1f03ee15c35ba37b6d029e0ff3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libcairo, libiconv, libjpeg-turbo, libpng, libtiff, libwebp, libx11, littlecms, openjpeg, pango, zlib"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=$TERMUX_PREFIX
cflags
gtk3
jpeg
lcms2
man
tiff
"

termux_pkg_auto_update() {
	local latest latest_commit latest_version
	latest="$(curl -s "https://api.github.com/repos/wjaguar/mtPaint/commits?per_page=20" | jq -r '
		[.[] | {sha, title: (.commit.message | split("\n")[0])} | select(.title | test("^Version [0-9]+(\\.[0-9]+)+$"))][0] |
		"\(.sha) \(.title | ltrimstr("Version "))"')"
	read -r latest_commit latest_version <<< "${latest}"
	if [[ -z "${latest_commit}" || "${latest_commit}" == "null" ]]; then
		echo "WARN: Unable to get latest release commit from upstream" >&2
		return
	fi

	if ! termux_pkg_is_update_needed "${TERMUX_PKG_VERSION#*:}" "${latest_version}"; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	sed -i "s|^_COMMIT=.*|_COMMIT=${latest_commit}|" "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	local v=$(sed -En 's/^MT_V="([^"]+)".*/\1/p' configure)
	if [ "${v}" != "${TERMUX_PKG_VERSION#*:}" ]; then
		termux_error_exit "Version string '$TERMUX_PKG_VERSION' does not seem to be correct."
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_configure() {
	sh $TERMUX_PKG_SRCDIR/configure ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
