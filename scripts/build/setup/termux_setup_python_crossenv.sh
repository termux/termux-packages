termux_setup_python_crossenv() {
	local _CROSSENV_VERSION=1.1.4
	local _CROSSENV_TAR=crossenv-$_CROSSENV_VERSION.tar.gz
	local _CROSSENV_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		_CROSSENV_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/crossenv-${_CROSSENV_VERSION}
	else
		_CROSSENV_FOLDER=${TERMUX_COMMON_CACHEDIR}/crossenv-${_CROSSENV_VERSION}
	fi
	export TERMUX_PYTHON_CROSSENV_SRCDIR=$_CROSSENV_FOLDER

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$_CROSSENV_FOLDER" ]; then
			termux_download \
				https://github.com/benfogle/crossenv/archive/refs/tags/v$_CROSSENV_VERSION.tar.gz \
				$TERMUX_PKG_TMPDIR/$_CROSSENV_TAR \
				c1b0bb088ebd924e0cddbf1e601a172dc65d1f1c5f400d10a2743e3bfb703b9f

			rm -Rf "$TERMUX_PKG_TMPDIR/crossenv-$_CROSSENV_VERSION"
			tar xf $TERMUX_PKG_TMPDIR/$_CROSSENV_TAR -C $TERMUX_PKG_TMPDIR
			mv "$TERMUX_PKG_TMPDIR/crossenv-$_CROSSENV_VERSION" \
				$_CROSSENV_FOLDER
		fi
	fi
}
