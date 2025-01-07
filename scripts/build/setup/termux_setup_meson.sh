termux_setup_meson() {
	termux_setup_ninja
	local MESON_VERSION=1.5.2
	local MESON_FOLDER

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		MESON_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/meson-${MESON_VERSION}
	else
		MESON_FOLDER=${TERMUX_COMMON_CACHEDIR}/meson-${MESON_VERSION}
	fi

	if [ ! -d "$MESON_FOLDER" ]; then
		local MESON_TAR_NAME=meson-$MESON_VERSION.tar.gz
		local MESON_TAR_FILE=$TERMUX_PKG_TMPDIR/$MESON_TAR_NAME
		local MESON_TMP_FOLDER=$TERMUX_PKG_TMPDIR/meson-$MESON_VERSION
		termux_download \
			"https://github.com/mesonbuild/meson/releases/download/$MESON_VERSION/meson-$MESON_VERSION.tar.gz" \
			"$MESON_TAR_FILE" \
			f955e09ab0d71ef180ae85df65991d58ed8430323de7d77a37e11c9ea630910b
		tar xf "$MESON_TAR_FILE" -C "$TERMUX_PKG_TMPDIR"
		shopt -s nullglob
		local f
		for f in "$TERMUX_SCRIPTDIR"/scripts/build/setup/meson-*.patch; do
			echo "[${FUNCNAME[0]}]: Applying $(basename "$f")"
			patch --silent -p1 -d "$MESON_TMP_FOLDER" < "$f"
		done
		shopt -u nullglob
		mv "$MESON_TMP_FOLDER" "$MESON_FOLDER"
	fi
	TERMUX_MESON="$MESON_FOLDER/meson.py"
	TERMUX_MESON_CROSSFILE=$TERMUX_PKG_TMPDIR/meson-crossfile-$TERMUX_ARCH.txt
	local MESON_CPU MESON_CPU_FAMILY
	if [ "$TERMUX_ARCH" = "arm" ]; then
		MESON_CPU_FAMILY="arm"
		MESON_CPU="armv7"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		MESON_CPU_FAMILY="x86"
		MESON_CPU="i686"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		MESON_CPU_FAMILY="x86_64"
		MESON_CPU="x86_64"
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		MESON_CPU_FAMILY="aarch64"
		MESON_CPU="aarch64"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	local CONTENT=""
	echo "[binaries]" > $TERMUX_MESON_CROSSFILE
	echo "ar = '$AR'" >> $TERMUX_MESON_CROSSFILE
	echo "c = '$CC'" >> $TERMUX_MESON_CROSSFILE
	echo "cmake = 'cmake'" >> $TERMUX_MESON_CROSSFILE
	echo "cpp = '$CXX'" >> $TERMUX_MESON_CROSSFILE
	echo "ld = '$LD'" >> $TERMUX_MESON_CROSSFILE
	echo "pkg-config = '$PKG_CONFIG'" >> $TERMUX_MESON_CROSSFILE
	echo "strip = '$STRIP'" >> $TERMUX_MESON_CROSSFILE

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		echo '' >> $TERMUX_MESON_CROSSFILE
		echo "[properties]" >> $TERMUX_MESON_CROSSFILE
		echo "needs_exe_wrapper = true" >> $TERMUX_MESON_CROSSFILE
  	fi

	echo '' >> $TERMUX_MESON_CROSSFILE
	echo "[built-in options]" >> $TERMUX_MESON_CROSSFILE

	echo -n "c_args = [" >> $TERMUX_MESON_CROSSFILE
	local word first=true
	for word in $CFLAGS $CPPFLAGS; do
		if [ "$first" = "true" ]; then
			first=false
		else
			echo -n ", " >> $TERMUX_MESON_CROSSFILE
		fi
		echo -n "'$word'" >> $TERMUX_MESON_CROSSFILE
	done
	echo ']' >> $TERMUX_MESON_CROSSFILE

	echo -n "cpp_args = [" >> $TERMUX_MESON_CROSSFILE
	local word first=true
	for word in $CXXFLAGS $CPPFLAGS; do
		if [ "$first" = "true" ]; then
			first=false
		else
			echo -n ", " >> $TERMUX_MESON_CROSSFILE
		fi
		echo -n "'$word'" >> $TERMUX_MESON_CROSSFILE
	done
	echo ']' >> $TERMUX_MESON_CROSSFILE

	local property
	for property in c_link_args cpp_link_args fortran_link_args; do
		echo -n "$property = [" >> $TERMUX_MESON_CROSSFILE
		first=true
		for word in $LDFLAGS; do
			if [ "$first" = "true" ]; then
				first=false
			else
				echo -n ", " >> $TERMUX_MESON_CROSSFILE
			fi
			echo -n "'$word'" >> $TERMUX_MESON_CROSSFILE
		done
		echo ']' >> $TERMUX_MESON_CROSSFILE
	done

	echo '' >> $TERMUX_MESON_CROSSFILE
	echo "[host_machine]" >> $TERMUX_MESON_CROSSFILE
	echo "cpu_family = '$MESON_CPU_FAMILY'" >> $TERMUX_MESON_CROSSFILE
	echo "cpu = '$MESON_CPU'" >> $TERMUX_MESON_CROSSFILE
	echo "endian = 'little'" >> $TERMUX_MESON_CROSSFILE
 	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		echo "system = 'android'" >> $TERMUX_MESON_CROSSFILE
  	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		echo "system = 'linux'" >> $TERMUX_MESON_CROSSFILE
     	fi
}
