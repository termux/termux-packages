termux_set_package_file_variables() {
	local package_name="$1"
	local is_subpackage="$2"

	TERMUX_PKG_FILE=""
	TERMUX_PKG_ARCH="$TERMUX_ARCH"

	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
		if [ "$is_subpackage" != "true" ]; then
			[ "$TERMUX_PKG_PLATFORM_INDEPENDENT" = "true" ] && TERMUX_PKG_ARCH=all
		else
			[ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = "true" ] && TERMUX_PKG_ARCH=all
		fi

		TERMUX_PKG_FILE="$TERMUX_OUTPUT_DIR/${package_name}${DEBUG}_${TERMUX_PKG_FULLVERSION}_${TERMUX_PKG_ARCH}.deb"

	elif [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		if [ "$is_subpackage" != "true" ]; then
			[ "$TERMUX_PKG_PLATFORM_INDEPENDENT" = "true" ] && TERMUX_PKG_ARCH=any
		else
			[ "$TERMUX_SUBPKG_PLATFORM_INDEPENDENT" = "true" ] && TERMUX_PKG_ARCH=any
		fi

		local COMPRESS
		local PKG_FORMAT
		case $TERMUX_PACMAN_PACKAGE_COMPRESSION in
			"gzip")
				COMPRESS=(gzip -c -f -n)
				PKG_FORMAT="gz";;
			"bzip2")
				COMPRESS=(bzip2 -c -f)
				PKG_FORMAT="bz2";;
			"zstd")
				COMPRESS=(zstd -c -z -q -)
				PKG_FORMAT="zst";;
			"lrzip")
				COMPRESS=(lrzip -q)
				PKG_FORMAT="lrz";;
			"lzop")
				COMPRESS=(lzop -q)
				PKG_FORMAT="lzop";;
			"lz4")
				COMPRESS=(lz4 -q)
				PKG_FORMAT="lz4";;
			"lzip")
				COMPRESS=(lzip -c -f)
				PKG_FORMAT="lz";;
			"xz" | *)
				COMPRESS=(xz -c -z -)
				PKG_FORMAT="xz";;
		esac

		TERMUX_PKG_FILE="$TERMUX_OUTPUT_DIR/${package_name}${DEBUG}-${TERMUX_PKG_FULLVERSION_FOR_PACMAN}-${TERMUX_PKG_ARCH}.pkg.tar.${PKG_FORMAT}"
		TERMUX_PACMAN_PACKAGE_COMPRESS_CMD=("${COMPRESS[@]}")
	fi
}
