termux_setup_protobuf() {
	local _PROTOBUF_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo \$TERMUX_PKG_VERSION")
	local _PROTOBUF_ZIP=protoc-$_PROTOBUF_VERSION-linux-x86_64.zip
	local _PROTOBUF_FOLDER=$TERMUX_COMMON_CACHEDIR/protobuf-$_PROTOBUF_VERSION

	if [ ! -d "$_PROTOBUF_FOLDER" ]; then
		termux_download \
				https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP \
				$TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP \
				24ea6924faaf94d4a0c5850fdb278290a326eff9a68f36ee5809654faccd0e10

		rm -Rf "$TERMUX_PKG_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
		unzip $TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP -d $TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION
		mv "$TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
			$_PROTOBUF_FOLDER
	fi

	export PATH=$_PROTOBUF_FOLDER/bin/:$PATH
}
