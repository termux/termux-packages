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
	echo "error" > "${DEPS_STATUS}"
}

DEPS_STATUS=$(mktemp)
DEPS="
basename
grep
install
ls
patchelf
readelf
sed
sort
uname
"
for dep in ${DEPS}; do
	echo "INFO: Checking command ${dep} ... $(check_cmd "${dep}" "${DEPS_STATUS}")"
done
if [ "$(cat "${DEPS_STATUS}")" = "error" ]; then
	rm -f "${DEPS_STATUS}"
	echo "WARN: One or more dependencies are not installed. Install them then try again. Exiting ..." >&2
	exit
fi
rm -f "${DEPS_STATUS}"

UNAME=$(uname -m)
BIT=""
case "${UNAME}" in
aarch64|x86_64)
	BIT="64"
	;;
armv*|i*86)
	;;
*)
	echo "WARN: Unknown arch ${UNAME}" >&2
esac

TARGET_LIBOPENCL="${PREFIX}/opt/vendor/lib/libOpenCL.so"
VENDOR_LIBOPENCL=""
HAS_OPENCL="0"
HAS_MALI="0"

# user override
if [ -n "${OVERRIDE_LIBOPENCL}" ]; then
	echo "WARN: Forcing to use ${OVERRIDE_LIBOPENCL} as vendor OpenCL ..." >&2
	if [ -e "${OVERRIDE_LIBOPENCL}" ]; then
		VENDOR_LIBOPENCL="${OVERRIDE_LIBOPENCL}"
	else
		echo "INFO: Falling back to autodetect as provided path is invalid."
	fi
fi

if [ -z "${VENDOR_LIBOPENCL}" ]; then
	# autodetect
	VENDOR_LIBDIR=""
	if [ -e "/vendor/lib${BIT}" ]; then
		VENDOR_LIBDIR="/vendor/lib${BIT}"
	elif [ -e "/system/vendor/lib${BIT}" ]; then
		VENDOR_LIBDIR="/system/vendor/lib${BIT}"
	else
		echo "WARN: /vendor and /system are not accessible. This package is now useless." >&2
		exit
	fi

	[ -e "${VENDOR_LIBDIR}/libOpenCL.so" ] && HAS_OPENCL="1"
	[ -e "${VENDOR_LIBDIR}/egl/libGLES_mali.so" ] && HAS_MALI="1"

	# autopick
	if [ "${HAS_OPENCL}" = "1" ] && [ "${HAS_MALI}" = "1" ]; then
		VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/egl/libGLES_mali.so"
	elif [ "${HAS_OPENCL}" = "0" ] && [ "${HAS_MALI}" = "1" ]; then
		VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/egl/libGLES_mali.so"
	elif [ "${HAS_OPENCL}" = "1" ] && [ "${HAS_MALI}" = "0" ]; then
		VENDOR_LIBOPENCL="${VENDOR_LIBDIR}/libOpenCL.so"
	else
		echo "WARN: No drivers found! This package is now useless." >&2
		exit
	fi
fi

echo "INFO: Found ${VENDOR_LIBOPENCL}, installing as ${TARGET_LIBOPENCL} ..."
install -Dm644 "${VENDOR_LIBOPENCL}" "${TARGET_LIBOPENCL}"

install_deps() { (
	LIB=$(basename "$1")
	NEEDED_LIBS=$(readelf -d "$1" | grep NEEDED | sed "s|.* \[\(.*\)\]|\1|g" | sort)
	SET_RPATH="0"
	NOT_SYSTEM_LIBS=""
	echo "INFO: Checking ${LIB} for missing dependencies ..."
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
		vendor_needed_lib=""
		if [ -e "${VENDOR_LIBDIR}/${needed_lib}" ]; then
			vendor_needed_lib="${VENDOR_LIBDIR}/${needed_lib}"
		else
			echo "WARN: Unable to find ${needed_lib}. This package may not work properly." >&2
		fi
		if [ -n "${vendor_needed_lib}" ]; then
			echo "INFO: Installing missing dependency ${vendor_needed_lib} ..."
			install -Dm644 "${vendor_needed_lib}" "${target_needed_lib}"
			install_deps "${target_needed_lib}"
			SET_RPATH="1"
		fi
	done
	if [ "${SET_RPATH}" = "1" ]; then
		echo "INFO: Patching rpath for $1 ..."
		patchelf --set-rpath '$ORIGIN' "$1"
	else
		echo "INFO: Removing rpath for $1 ..."
		patchelf --remove-rpath "$1"
	fi
) }

if [ -n "${VENDOR_LIBOPENCL}" ]; then
	SYSTEM_LIBS=$(ls /system/lib${BIT})
	install_deps "${TARGET_LIBOPENCL}"
	echo "
====================
Post install notice:
If there's any ROM upgrades taken place after
installing opencl-vendor-driver package,
reinstall of the package is required to use the
updated OpenCL drivers.
====================
"
fi
