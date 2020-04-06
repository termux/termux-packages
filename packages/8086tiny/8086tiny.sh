#!@TERMUX_PREFIX@/bin/bash

VERSION="@PACKAGE_VERSION@"

PROGRAM="@TERMUX_PREFIX@/libexec/8086tiny"
BIOS_IMAGE="@TERMUX_PREFIX@/share/8086tiny/bios.bin"
FD_IMAGE=""
HDD_IMAGE=""

cleanup() {
	stty cooked echo
	echo
}

usage() {
	echo "Usage: 8086tiny [floppy image] [harddisk image]"
	echo
	echo "8086tiny is a tiny, free, open source, portable Intel PC emulator/VM."
	echo
	echo "Options:"
	echo
	echo " -h, --help       show this help and exit"
	echo " -v, --version    show version information"
	echo
}

while (( $# > 0 )); do
	case "$1" in
		-h|--help)
			usage
			exit 0
			;;
		-v|--version)
			echo "8086tiny $VERSION"
			exit 0
			;;
		-*)
			echo "Unknown option '$1'."
			echo
			usage
			exit 1
			;;
		*)
			if [ -z "$FD_IMAGE" ]; then
				FD_IMAGE="$1"
				shift 1
				continue
			fi

			if [ -z "$HDD_IMAGE" ]; then
				HDD_IMAGE="$1"
				shift 1
				continue
			fi
			;;
	esac
	shift 1
done

if [ -z "$FD_IMAGE" ]; then
	FD_IMAGE="@TERMUX_PREFIX@/share/8086tiny/dos.img"
fi

clear
trap cleanup INT TERM
stty cbreak raw -echo min 0

if [ -n "$HDD_IMAGE" ]; then
	"$PROGRAM" "$BIOS_IMAGE" "$FD_IMAGE" "$HDD_IMAGE"
else
	"$PROGRAM" "$BIOS_IMAGE" "$FD_IMAGE"
fi

cleanup
