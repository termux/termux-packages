TERMUX_PKG_HOMEPAGE=https://tox.chat
TERMUX_PKG_DESCRIPTION="Backend library for the Tox protocol"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Match commit SHA with toxic/blob/master/script/build-minimal-static-toxic.sh
_COMMIT=0f12f384c8cf62310b9cff6c31e94af7126b7478
_COMMIT_DATE=20250105
TERMUX_PKG_VERSION=0.2.20-p${_COMMIT_DATE}
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=git+https://github.com/TokTok/c-toxcore
TERMUX_PKG_SHA256=26fb56c1818f9aed9e507ed2ed8f2e6e6e5d05f7a264eb8856be5b6b887c656f
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libsodium, libopus, libvpx"
TERMUX_PKG_BREAKS="c-toxcore-dev"
TERMUX_PKG_REPLACES="c-toxcore-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-DBOOTSTRAP_DAEMON=off
-DDHT_BOOTSTRAP=off
"

termux_step_get_source() {
	rm -rf $TERMUX_PKG_SRCDIR
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	git clone --depth 1 --branch ${TERMUX_PKG_GIT_BRANCH} \
		${TERMUX_PKG_SRCURL#git+} .
	git fetch --unshallow
	git checkout $_COMMIT
	git submodule update --init --recursive --depth=1
}

termux_step_post_get_source() {
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
	local _SOVERSION=2

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				so.version)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
