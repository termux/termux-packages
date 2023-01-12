termux_setup_python_pip() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' python-pip 2>/dev/null)" != "installed" ]] ||
		[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q python-pip 2>/dev/null)" ]]; then
			echo "Package 'python-pip' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install python-pip"
			echo
			echo "  pacman -S python-pip"
			echo
			echo "Note that package 'python-pip' is known to be problematic for building on device."
			exit 1
		fi
		return
	else
		local _CROSSENV_VERSION=1.3.0
		local _CROSSENV_TAR=crossenv-$_CROSSENV_VERSION.tar.gz
		local _CROSSENV_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			_CROSSENV_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/crossenv-${_CROSSENV_VERSION}
		else
			_CROSSENV_FOLDER=${TERMUX_COMMON_CACHEDIR}/crossenv-${_CROSSENV_VERSION}
		fi
		export TERMUX_PYTHON_CROSSENV_SRCDIR=$_CROSSENV_FOLDER

		if [ ! -d "$_CROSSENV_FOLDER" ]; then
			termux_download \
				https://github.com/benfogle/crossenv/archive/refs/tags/v$_CROSSENV_VERSION.tar.gz \
				$TERMUX_PKG_TMPDIR/$_CROSSENV_TAR \
				a217a67f9201801c087b582b28c0318e014a17ffa89d355854d646e1b1094b80

			rm -Rf "$TERMUX_PKG_TMPDIR/crossenv-$_CROSSENV_VERSION"
			tar xf $TERMUX_PKG_TMPDIR/$_CROSSENV_TAR -C $TERMUX_PKG_TMPDIR
			mv "$TERMUX_PKG_TMPDIR/crossenv-$_CROSSENV_VERSION" \
				$_CROSSENV_FOLDER
			shopt -s nullglob
			local f
			for f in "$TERMUX_SCRIPTDIR"/scripts/build/setup/python-crossenv-*.patch; do
				echo "[${FUNCNAME[0]}]: Applying $(basename "$f")"
				patch --silent -p1 -d "$_CROSSENV_FOLDER" < "$f"
			done
			shopt -u nullglob
		fi

		if [ ! -d "$TERMUX_PYTHON_CROSSENV_PREFIX" ]; then
			pushd "$TERMUX_PYTHON_CROSSENV_SRCDIR"
			python${TERMUX_PYTHON_VERSION} -m crossenv \
                		"$TERMUX_PREFIX/bin/python${TERMUX_PYTHON_VERSION}" \
				"${TERMUX_PYTHON_CROSSENV_PREFIX}"
			popd
		fi
		. "${TERMUX_PYTHON_CROSSENV_PREFIX}/bin/activate"
	fi
}
