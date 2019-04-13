termux_setup_ninja() {
	local NINJA_VERSION=1.9.0
	local NINJA_FOLDER=$TERMUX_COMMON_CACHEDIR/ninja-$NINJA_VERSION
	if [ ! -x "$NINJA_FOLDER/ninja" ]; then
		mkdir -p "$NINJA_FOLDER"
		local NINJA_ZIP_FILE=$TERMUX_PKG_TMPDIR/ninja-$NINJA_VERSION.zip
		termux_download https://github.com/ninja-build/ninja/releases/download/v$NINJA_VERSION/ninja-linux.zip \
			"$NINJA_ZIP_FILE" \
			609cc10d0f226a4d9050e4d4a57be9ea706858cce64b9132102c3789c868da92
		unzip "$NINJA_ZIP_FILE" -d "$NINJA_FOLDER"
		chmod 755 $NINJA_FOLDER/ninja
	fi
	export PATH=$NINJA_FOLDER:$PATH
}
