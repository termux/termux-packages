# shellcheck shell=bash
# shellcheck disable=SC2034
TERMUX_PKG_HOMEPAGE="https://github.com/awslabs/aws-crt-python"
TERMUX_PKG_DESCRIPTION="Python Bindings for the AWS Common Runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.4"
TERMUX_PKG_SRCURL="git+${TERMUX_PKG_HOMEPAGE}"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="openssl, python-pip"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_step_post_get_source() {
	python3 "${TERMUX_PKG_SRCDIR}/continuous-delivery/update-version.py"
}

termux_step_configure() {
	termux_setup_cmake
}

termux_step_make_install() {
	local toolchain_file
	local sys_proc
	local build_type

	if ${TERMUX_DEBUG_BUILD}; then
		build_type="Debug"
	else
		build_type="Release"
	fi

	toolchain_file="$(mktemp -p "${TERMUX_PKG_TMPDIR}" "aws-crt-python.XXXXXX.cmake")"
	if ${TERMUX_ON_DEVICE_BUILD}; then
		cat <<-EOF >"${toolchain_file}"
			set(CMAKE_LINKER "$(command -v ${LD}) ${LDFLAGS}")
		EOF
	else
		CXXFLAGS+=" --target=${CCTERMUX_HOST_PLATFORM}"
		CFLAGS+=" --target=${CCTERMUX_HOST_PLATFORM}"
		LDFLAGS+=" --target=${CCTERMUX_HOST_PLATFORM}"

		sys_proc="${TERMUX_ARCH}"
		if [ "${sys_proc}" = "arm" ]; then
			sys_proc="armv7-a"
		fi

		cat <<-EOF >"${toolchain_file}"
			set(CMAKE_CROSSCOMPILING ON)
			set(CMAKE_LINKER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${LD} ${LDFLAGS}")
			set(CMAKE_SYSTEM_NAME "Android")
			set(CMAKE_SYSTEM_VERSION "${TERMUX_PKG_API_LEVEL}")
			set(CMAKE_SYSTEM_PROCESSOR "${sys_proc}")
			set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN "${TERMUX_STANDALONE_TOOLCHAIN}")
			set(CMAKE_ANDROID_NDK "${NDK}")
		EOF
	fi

	cat <<-EOF >>"${toolchain_file}"
		set(CMAKE_BUILD_TYPE "${build_type}")
		set(CMAKE_C_FLAGS "${CFLAGS} ${CPPFLAGS}")
		set(CMAKE_CXX_FLAGS "${CXXFLAGS} ${CPPFLAGS}")
		set(CMAKE_FIND_ROOT_PATH "${TERMUX_PREFIX}")
		set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
		set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
		set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
		set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)
		set(CMAKE_PREFIX_PATH "${TERMUX_PREFIX}")
		set(CMAKE_INSTALL_PREFIX "${TERMUX_PREFIX}")
		set(CMAKE_INSTALL_LIBDIR "${TERMUX_PREFIX}/lib")
		set(CMAKE_USE_SYSTEM_LIBRARIES ON)
	EOF

	CMAKE_TOOLCHAIN_FILE="${toolchain_file}" AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO=1 \
		pip3 install --no-binary :all: "${TERMUX_PKG_SRCDIR}" --prefix "${TERMUX_PREFIX}" ||
		{
			rm -f "${toolchain_file}"
			termux_error_exit "Failed to install ${TERMUX_PKG_NAME}"
		}
	rm -f "${toolchain_file}"
}
