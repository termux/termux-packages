#!@TERMUX_PREFIX@/bin/sh
PREFIX=@TERMUX_PREFIX@

check_cmd_status() {
	[ -n "$(command -v "$1")" ] && echo 0 && return
	[ -e "${PREFIX}/bin/$1" ] && echo 1 && return
	echo 2
}

check_cmd() {
	status=$(check_cmd_status "$1")
	[ "${status}" = 0 ] && echo "OK" && return
	[ "${status}" = 1 ] && echo "NOT WORKING"
	[ "${status}" = 2 ] && echo "NOT FOUND"
	echo "error" > "${CMD_STATUS}"
}

install_deps() { (
	LIB=$(basename "$1")
	NEEDED_LIBS=$(readelf -d "$1" | sed -ne "s|.*NEEDED.* \[\(.*\)\]|\1|p" | sort)
	SET_RPATH="0"
	NOT_SYSTEM_LIBS=""
	echo "INFO: ${LIB} ... checking for dependencies"
	for needed_lib in ${NEEDED_LIBS}; do
		IS_SYSTEM_LIB="0"
		for system_lib in ${SYSTEM_LIBS}; do
			[ "${DEBUG}" = "1" ] && echo "DEBUG: ${LIB} ... ${needed_lib} ... ${system_lib}"
			[ "${needed_lib}" = "${system_lib}" ] && IS_SYSTEM_LIB="1" && break
		done
		if [ "${IS_SYSTEM_LIB}" != "1" ]; then
			NOT_SYSTEM_LIBS="${NOT_SYSTEM_LIBS} ${needed_lib}"
		fi
	done
	for needed_lib in ${NOT_SYSTEM_LIBS}; do
		target_needed_lib="${PREFIX}/opt/vendor/lib/${needed_lib}"
		vendor_needed_lib="${VENDOR_LIBDIR}/${needed_lib}"
		if [ -e "${vendor_needed_lib}" ]; then
			echo "INFO: ${LIB} ... found ${vendor_needed_lib}"
			install -Dm644 "${vendor_needed_lib}" "${target_needed_lib}"
			install_deps "${target_needed_lib}"
			SET_RPATH="1"
			continue
		fi
		echo "WARN: ${LIB} ... unable to find ${needed_lib}, this package is now useless" >&2
	done
	if [ "${SET_RPATH}" = "1" ]; then
		echo "INFO: ${LIB} ... found dependencies, patching runpath"
		patchelf --set-rpath '$ORIGIN' "$1"
		return
	fi
	echo "INFO: ${LIB} ... no dependency found, erasing runpath"
	patchelf --remove-rpath "$1"
) }

CMD_STATUS=$(mktemp)
CMDS="
basename
dirname
install
ls
patchelf
readelf
rm
sed
sort
uname
"
for cmd in ${CMDS}; do
	echo "INFO: Checking command ${cmd} ... $(check_cmd "${cmd}" "${CMD_STATUS}")"
done
if [ "$(cat "${CMD_STATUS}")" = "error" ]; then
	rm -f "${CMD_STATUS}"
	echo "WARN: Some commands are not installed! Install them then try again." >&2
	exit
fi
rm -f "${CMD_STATUS}"

UNAME=$(uname -m)
BIT=""
case "${UNAME}" in
aarch64|x86_64) BIT="64" ;;
armv*|i*86) ;;
*) echo "WARN: Unknown arch ${UNAME}" >&2
esac

SYSTEM_LIBS=$(ls /system/lib${BIT})
TARGET_LIBOPENCL="${PREFIX}/opt/vendor/lib/libOpenCL.so"
VENDOR_LIBOPENCL=""
VENDOR_LIBDIR=""
HAS_OPENCL="0"
HAS_MALI="0"
HAS_PVR="0"

# user override
if [ -n "${OVERRIDE_LIBOPENCL}" ]; then
	echo "WARN: Forcing to use ${OVERRIDE_LIBOPENCL} as vendor OpenCL ..." >&2
	if [ -e "${OVERRIDE_LIBOPENCL}" ]; then
		VENDOR_LIBOPENCL="${OVERRIDE_LIBOPENCL}"
		case "${VENDOR_LIBOPENCL}" in
		/vendor/lib/*) VENDOR_LIBDIR="/vendor/lib" ;;
		/vendor/lib64/*) VENDOR_LIBDIR="/vendor/lib64" ;;
		/system/vendor/lib/*) VENDOR_LIBDIR="/system/vendor/lib" ;;
		/system/vendor/lib64/*) VENDOR_LIBDIR="/system/vendor/lib64" ;;
		*) VENDOR_LIBDIR=$(dirname "${VENDOR_LIBOPENCL}") ;;
		esac
		case "${VENDOR_LIBDIR}" in
		*64) SYSTEM_LIBS=$(ls /system/lib64) ;;
		*) SYSTEM_LIBS=$(ls /system/lib) ;;
		esac
	else
		echo "WARN: Falling back to autodetect as provided path is invalid" >&2
	fi
fi

# autodetect
if [ -z "${VENDOR_LIBOPENCL}" ]; then
	if [ -e "/vendor/lib${BIT}" ]; then
		VENDOR_LIBDIR="/vendor/lib${BIT}"
	elif [ -e "/system/vendor/lib${BIT}" ]; then
		VENDOR_LIBDIR="/system/vendor/lib${BIT}"
	else
		echo "WARN: /vendor and /system are not accessible! This package is now useless!" >&2
		exit
	fi

	[ -e "${VENDOR_LIBDIR}/libOpenCL.so" ] && HAS_OPENCL="1"
	[ -e "${VENDOR_LIBDIR}/egl/libGLES_mali.so" ] && HAS_MALI="1"
	[ -e "${VENDOR_LIBDIR}/libPVROCL.so" ] && HAS_PVR="1"

	# autopick
	case "${HAS_OPENCL}:${HAS_MALI}:${HAS_PVR}" in
	0:0:1) VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/libPVROCL.so" ;;
	0:1:0) VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/egl/libGLES_mali.so" ;;
	1:0:0) VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/libOpenCL.so" ;;
	1:0:1) VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/libPVROCL.so" ;;
	1:1:0) VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/egl/libGLES_mali.so" ;;
	*) echo "WARN: No drivers found! This package is now useless!" >&2 && exit
	esac
fi

echo "INFO: VENDOR_LIBOPENCL = ${VENDOR_LIBOPENCL}"
echo "INFO: VENDOR_LIBDIR    = ${VENDOR_LIBDIR}"
echo "INFO: Installing as ${TARGET_LIBOPENCL} ..."
install -Dm644 "${VENDOR_LIBOPENCL}" "${TARGET_LIBOPENCL}"
install_deps "${TARGET_LIBOPENCL}"

echo "
===== Post install notice =====

If there's any ROM upgrades taken place after
installing opencl-vendor-driver package,
reinstall of the package is required to use the
updated OpenCL drivers.

===== Post install notice =====
"
