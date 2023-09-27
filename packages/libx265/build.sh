TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=38cf1c379b5af08856bb2fdd65f65a1f99384886
_COMMIT_DATE=20230222
TERMUX_PKG_VERSION=3.5-p${_COMMIT_DATE}
#TERMUX_PKG_SRCURL=https://bitbucket.org/multicoreware/x265_git/downloads/x265_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SRCURL=git+https://bitbucket.org/multicoreware/x265_git
TERMUX_PKG_SHA256=5a8c54fb41b449538c160d3b48f439fa1c079b77f1c165c7b6967f5cb480ffd7
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libc++"
TERMUX_PKG_BREAKS="libx265-dev"
TERMUX_PKG_REPLACES="libx265-dev"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=207

	local v=$(sed -En 's/^.*set\(X265_BUILD ([0-9]+).*$/\1/p' \
			source/CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	if [ -d .git ]; then
		local _libx265_base_version="3.5"
		local _libx265_base_commit="f0c1022b6be121a753ff02853fbe33da71988656"
		if [ "${TERMUX_PKG_VERSION%-*}" != "${_libx265_base_version}" ]; then
			termux_error_exit "Base version mismatch; expected to be ${_libx265_base_version}."
		fi
		cat > x265Version.txt <<-EOF
			repositorychangeset: $(git log --pretty=format:%h -n 1)
			releasetagdistance: $(git rev-list ${_libx265_base_commit}.. --count --first-parent)
			releasetag: ${_libx265_base_version}
		EOF

		# To install shared lib
		rm -rf .git
	fi
}

termux_step_pre_configure() {
	local _TERMUX_CLANG_TARGET=

	# Not sure if this is necessary for on-device build
	# Follow termux_step_configure_cmake.sh for now
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		_TERMUX_CLANG_TARGET="--target=${CCTERMUX_HOST_PLATFORM}"
	fi

	if [ "$TERMUX_ARCH" = arm ] || [ "$TERMUX_ARCH" = i686 ]; then
		# Avoid text relocations and/or build failure.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	fi

	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"

	sed -i "s/@TERMUX_CLANG_TARGET_${TERMUX_ARCH^^}@/${_TERMUX_CLANG_TARGET}/" \
		${TERMUX_PKG_SRCDIR}/CMakeLists.txt

	LDFLAGS+=" -landroid-posix-semaphore"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
