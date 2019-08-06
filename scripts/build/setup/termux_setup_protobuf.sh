termux_setup_protobuf() {
	local _PROTOBUF_VERSION=$(bash -c ". $TERMUX_SCRIPTDIR/packages/libprotobuf/build.sh; echo \$TERMUX_PKG_VERSION")
	local _PROTOBUF_ZIP=protoc-$_PROTOBUF_VERSION-linux-x86_64.zip
	local _PROTOBUF_FOLDER=$TERMUX_COMMON_CACHEDIR/protobuf-$_PROTOBUF_VERSION

	if [ -z "$TERMUX_ON_DEVICE_BUILD" ]; then
		if [ ! -d "$_PROTOBUF_FOLDER" ]; then
			termux_download \
				https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP \
				$TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP \
				15e395b648a1a6dda8fd66868824a396e9d3e89bc2c8648e3b9ab9801bea5d55

			rm -Rf "$TERMUX_PKG_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
			unzip $TERMUX_PKG_TMPDIR/$_PROTOBUF_ZIP -d $TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION
			mv "$TERMUX_PKG_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
				$_PROTOBUF_FOLDER
		fi

		export PATH=$_PROTOBUF_FOLDER/bin/:$PATH
	else
		if [ "$(dpkg-query -W -f '${db:Status-Status}\n' protobuf 2>/dev/null)" != "installed" ]; then
			echo "Package 'protobuf' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install protobuf"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh libprotobuf"
			echo
			exit 1
		fi
	fi
}
