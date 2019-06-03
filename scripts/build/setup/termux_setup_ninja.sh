termux_setup_ninja() {
	local NINJA_VERSION=1.9.0
	local NINJA_FOLDER=$TERMUX_COMMON_CACHEDIR/ninja-$NINJA_VERSION
	if [ ! -x "$NINJA_FOLDER/ninja" ]; then
		mkdir -p "$NINJA_FOLDER"
		local NINJA_ZIP_FILE=$TERMUX_PKG_TMPDIR/ninja-$NINJA_VERSION.zip
		termux_download https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip \
			"$NINJA_ZIP_FILE" \
			1b1235f2b0b4df55ac6d80bbe681ea3639c9d2c505c7ff2159a3daf63d196305
		unzip "$NINJA_ZIP_FILE" -d "$NINJA_FOLDER"
		chmod 755 $NINJA_FOLDER/ninja
	fi
	export PATH=$NINJA_FOLDER:$PATH
}
