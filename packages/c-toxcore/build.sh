TERMUX_PKG_HOMEPAGE=https://tox.chat
TERMUX_PKG_DESCRIPTION="Backend library for the Tox protocol"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Match commit SHA with toxic/blob/master/script/build-minimal-static-toxic.sh
_COMMIT=c08409390fe185c8b65e218d5c36c9347234f3e7
_COMMIT_DATE=20240129
TERMUX_PKG_VERSION=0.2.18-p${_COMMIT_DATE}
TERMUX_PKG_SRCURL=git+https://github.com/TokTok/c-toxcore
TERMUX_PKG_SHA256=f5ac9d1890e0442dd4963aec556fa49dca3aea58832e81d64439e7417561a11c
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libsodium, libopus, libvpx"
TERMUX_PKG_BREAKS="c-toxcore-dev"
TERMUX_PKG_REPLACES="c-toxcore-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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
