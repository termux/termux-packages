termux_setup_protobuf() {
	local _PROTOBUF_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo \$TERMUX_PKG_VERSION")
	local _PROTOBUF_ZIP=protoc-$_PROTOBUF_VERSION-linux-x86_64.zip
	local _PROTOBUF_FOLDER=$TERMUX_COMMON_CACHEDIR/protobuf-$_PROTOBUF_VERSION

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$_PROTOBUF_FOLDER" ]; then
			termux_download \
				https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP \
				$TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP \
				1102323cdaacd589e50b8b7770595f220f54d18a1d76ee3c445198f80ab865b8

			rm -Rf "$TERMUX_PKG_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
			unzip $TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP -d $TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION
			mv "$TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
				$_PROTOBUF_FOLDER
		fi

		export PATH=$_PROTOBUF_FOLDER/bin/:$PATH
	fi
}
