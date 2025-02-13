TERMUX_PKG_HOMEPAGE=https://github.com/XmacsLabs/mogan
TERMUX_PKG_DESCRIPTION="A structure editor forked from GNU TeXmacs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.9.8"
TERMUX_PKG_SRCURL=https://github.com/XmacsLabs/mogan/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70af74dad16816a8097b877dc4cd94202f35517468ab54f6ae6f84ede32746fb
TERMUX_PKG_DEPENDS="freetype, ghostscript, libandroid-complex-math, libandroid-execinfo, libandroid-spawn, libandroid-wordexp, libc++, libcurl, libgit2, libiconv, libjpeg-turbo, libpng, qt6-qtbase, qt6-qtsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libcurl.so
"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/XmacsLabs/mogan/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*v\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | grep "^1.2.9." | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	sed \
		"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|" \
		"${TERMUX_PKG_BUILDER_DIR}/lolly.diff" \
		> "${TERMUX_PKG_SRCDIR}"/xmake/packages/l/lolly/lolly.diff
	cp -f "${TERMUX_PKG_BUILDER_DIR}"/s7.diff \
		"${TERMUX_PKG_SRCDIR}"/xmake/packages/s/s7/s7.diff
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", mogan-data"

	termux_setup_cmake
	termux_setup_xmake

	# xmake tests -ldl wrongly?
	LD="${CXX}"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		install -Dm755 "${TERMUX_PKG_BUILDER_DIR}/qmake.sh" "${TERMUX_PKG_TMPDIR}/qmake"
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" -i "${TERMUX_PKG_TMPDIR}/qmake"
		export PATH="${TERMUX_PKG_TMPDIR}:${TERMUX_PREFIX}/opt/qt6/cross/bin:${PATH}"
	fi

	command -v qmake
	qmake -query
}

termux_step_make() {
	local host_platform="${TERMUX_ARCH}-linux-android"
	case "${TERMUX_ARCH}" in
	arm) host_platform="armv7a-linux-androideabi" ;;
	esac

	echo "xrepo update-repo"
	xrepo update-repo

	echo "xmake config"
	xmake config \
		--yes \
		--verbose \
		--diagnosis \
		-m releasedbg \
		--sdk="${TERMUX_STANDALONE_TOOLCHAIN}" \
		--cross="${host_platform}-" \
		--cflags="${CPPFLAGS} ${CFLAGS}" \
		--cxxflags="${CPPFLAGS} ${CXXFLAGS}" \
		--ldflags="${LDFLAGS}"

	echo "xmake build"
	xmake build \
		--yes \
		--verbose \
		--diagnosis \
		--jobs="${TERMUX_PKG_MAKE_PROCESSES}"
}

termux_step_make_install() {
	echo "xmake install"
	xmake install \
		--yes \
		--verbose \
		--diagnosis \
		-o "${TERMUX_PREFIX}" \
		research
}
