TERMUX_PKG_HOMEPAGE=https://dotnet.microsoft.com/en-us/
TERMUX_PKG_DESCRIPTION=".NET 8.0"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@truboxl"
TERMUX_PKG_VERSION="8.0.22"
TERMUX_PKG_REVISION=2
_DOTNET_SDK_VERSION="8.0.122"
TERMUX_PKG_SRCURL=git+https://github.com/dotnet/dotnet
TERMUX_PKG_GIT_BRANCH="v${_DOTNET_SDK_VERSION}"
TERMUX_PKG_BUILD_DEPENDS="krb5, libicu, openssl, zlib"
TERMUX_PKG_SUGGESTS="dotnet-sdk-8.0"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
# https://github.com/dotnet/runtime/issues/7335
# linux-x86 is not officially supported but works
# TODO linux-bionic-arm is broken
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/dotnet/core/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*v\(8.0.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi

	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	sed \
		-e "s|^_DOTNET_SDK_VERSION=.*|_DOTNET_SDK_VERSION=\"8.0.1${latest_version##*.}\"|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	# set up dotnet cli and override source files
	./prep.sh
}

termux_step_pre_configure() {
	# this is a workaround for build-all.sh
	TERMUX_PKG_DEPENDS="aspnetcore-runtime-8.0, dotnet-host, dotnet-runtime-8.0"

	termux_setup_cmake
	termux_setup_ninja

	# aspnetcore needs nodejs <= 19, but nodejs 18.x and 19.x are EOL
	local NODEJS_VERSION=18.20.8
	local NODEJS_SHA256=5467ee62d6af1411d46b6a10e3fb5cacc92734dbcef465fea14e7b90993001c9
	local NODEJS_FOLDER="${TERMUX_PKG_CACHEDIR}/nodejs-${NODEJS_VERSION}"
	local NODEJS_TAR_XZ="${TERMUX_PKG_CACHEDIR}/node.tar.xz"
	termux_download \
		https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz \
		"${NODEJS_TAR_XZ}" \
		"${NODEJS_SHA256}"
	mkdir -p "${NODEJS_FOLDER}"
	tar -xf "${NODEJS_TAR_XZ}" -C "${NODEJS_FOLDER}" --strip-components=1
	export PATH="${NODEJS_FOLDER}/bin:${PATH}"
	if [[ "$(node --version)" != "v${NODEJS_VERSION}" ]]; then
		termux_error_exit "$(command -v node) $(node --version) != ${NODEJS_VERSION}"
	fi
}

termux_step_configure() {
	export arch
	case "${TERMUX_ARCH}" in
	aarch64) arch=arm64 ;;
	arm) arch=arm ;;
	i686) arch=x86 ;;
	x86_64) arch=x64 ;;
	*) termux_error_exit "Unknown arch: ${TERMUX_ARCH}"
	esac

	export CONFIG="Release"
	if [[ "${TERMUX_DEBUG_BUILD}" == "true" ]]; then
		CONFIG="Debug"
	fi

	export ANDROID_NDK_ROOT="${TERMUX_PKG_TMPDIR}"

	# unified sysroot needed when CMAKE_SYSROOT / --sysroot cannot be used
	export ROOTFS_DIR="${TERMUX_PKG_TMPDIR}/sysroot"
	if [[ -e "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot.tmp" ]]; then
		rm -f "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
		mv -v "${TERMUX_STANDALONE_TOOLCHAIN}"/sysroot{.tmp,}
	fi
	rm -fr "${ROOTFS_DIR}"
	echo "INFO: Copying ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot to ${ROOTFS_DIR}"
	cp -fr "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot" "${ROOTFS_DIR}"
	echo "INFO: Copying ${TERMUX_PREFIX} to ${ROOTFS_DIR}"
	cp -fr "${TERMUX_PREFIX}" "${ROOTFS_DIR}"
	mv -v "${TERMUX_STANDALONE_TOOLCHAIN}"/sysroot{,.tmp}
	ln -sv "${ROOTFS_DIR}" "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"

	#echo "RID=android.${TERMUX_PKG_API_LEVEL}-${arch}" > "${ROOTFS_DIR}/android_platform"

	# manual termux_step_configure_cmake
	CMAKE_PROC="${TERMUX_ARCH}"
	if [[ "${CMAKE_PROC}" == "arm" ]]; then
		CMAKE_PROC="armv7-a"
	fi
	export CFLAGS+=" --target=${CCTERMUX_HOST_PLATFORM}"
	# https://github.com/dotnet/android/pull/4958
	# apphost remove dependency on libc++_shared.so
	# by linking statically
	export CXXFLAGS+=" --target=${CCTERMUX_HOST_PLATFORM} -stdlib=libc++ -static-libstdc++"

	# easier to embed in toolchain file than CMakeArgs
	mkdir -p "${TERMUX_PKG_TMPDIR}/build/cmake"
	cat <<- EOL > "${TERMUX_PKG_TMPDIR}/build/cmake/android.toolchain.cmake"
	set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} ${CFLAGS}")
	set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} ${CXXFLAGS}")
	set(CMAKE_SYSROOT "${ROOTFS_DIR}")
	set(CMAKE_C_COMPILER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${CC}")
	set(CMAKE_CXX_COMPILER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${CXX}")
	set(CMAKE_AR "$(command -v ${AR})")
	set(CMAKE_UNAME "$(command -v uname)")
	set(CMAKE_RANLIB "$(command -v ${RANLIB})")
	set(CMAKE_STRIP "$(command -v ${STRIP})")
	set(CMAKE_FIND_ROOT_PATH "${TERMUX_PREFIX}")
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM "NEVER")
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE "ONLY")
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY "ONLY")
	#set(CMAKE_INSTALL_PREFIX "${TERMUX_PREFIX}")
	#set(CMAKE_INSTALL_LIBDIR "${TERMUX_PREFIX}/lib")
	set(CMAKE_SKIP_INSTALL_RPATH "ON")
	set(CMAKE_USE_SYSTEM_LIBRARIES "True")
	set(CMAKE_CROSSCOMPILING "True")
	set(DOXYGEN_EXECUTABLE "")
	set(BUILD_TESTING "OFF")
	set(CMAKE_LINKER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${LD}")
	set(CMAKE_SYSTEM_NAME "Android")
	set(CMAKE_SYSTEM_VERSION "${TERMUX_PKG_API_LEVEL}")
	set(CMAKE_SYSTEM_PROCESSOR "${CMAKE_PROC}")
	set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN "${TERMUX_STANDALONE_TOOLCHAIN}")

	# https://github.com/dotnet/runtime/blob/445dac9e8e541b2364deea000dde8487ea1ec20e/src/coreclr/pal/src/configure.cmake#L776-L793
	# for unknown reason, this is needed here
	set(HAVE_COMPATIBLE_EXP_EXITCODE 0)

	# https://github.com/dotnet/runtime/issues/57784
	# Android has no liblttng-ust, Linux also has different issue
	set(FEATURE_EVENT_TRACE 0)
	EOL

	echo "INFO: ${TERMUX_PKG_TMPDIR}/build/cmake/android.toolchain.cmake"
	cat "${TERMUX_PKG_TMPDIR}/build/cmake/android.toolchain.cmake"
	echo

	export EXTRA_CFLAGS="${CFLAGS}"
	export EXTRA_CXXFLAGS="${CXXFLAGS}"
	export EXTRA_LDFLAGS="${LDFLAGS}"

	unset CC CFLAGS CXX CXXFLAGS LD LDFLAGS PKGCONFIG PKG_CONFIG PKG_CONFIG_DIR PKG_CONFIG_LIBDIR
}

termux_step_make() {
	export CROSSCOMPILE=1
	# --online needed to workaround restore issue
	time ./build.sh \
		--clean-while-building \
		--use-mono-runtime \
		--online \
		-- \
		-m:${TERMUX_PKG_MAKE_PROCESSES} \
		/p:Configuration=${CONFIG} \
		/p:OverrideTargetRid=linux-bionic-${arch}

	"${TERMUX_PKG_BUILDDIR}/.dotnet/dotnet" build-server shutdown
	termux_dotnet_kill
}

termux_step_make_install() {
	local _DOTNET_ROOT="${TERMUX_PREFIX}/lib/dotnet"
	rm -fr "${_DOTNET_ROOT}"
	mkdir -p "${_DOTNET_ROOT}"

	# DEBUG copy the artifacts
	#mkdir -p "${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}"
	#find "${TERMUX_PKG_BUILDDIR}/artifacts/x64" -type f \( -name "*.tar.gz" -o -name "*.zip" \) -exec cp -fv "{}" "${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}" \;

	# TODO fix hardcode in source, fixed in dotnet9.0
	# extract tarball
	tar -xf "${TERMUX_PKG_BUILDDIR}/artifacts/x64/${CONFIG}"/dotnet-sdk-*.tar.gz -C "${_DOTNET_ROOT}"
	tar -xf "${TERMUX_PKG_BUILDDIR}/artifacts/x64/${CONFIG}"/dotnet-symbols-sdk-*.tar.gz -C "${_DOTNET_ROOT}"

	# TODO fix hardcode in source, fixed in dotnet9.0
	# needed to fix default build target
	echo "INFO: Patching Microsoft.NETCoreSdk.BundledVersions.props"
	grep "<NETCoreSdkRuntimeIdentifier>" -nH "${_DOTNET_ROOT}"/sdk/*/Microsoft.NETCoreSdk.BundledVersions.props
	grep "<NETCoreSdkPortableRuntimeIdentifier>" -nH "${_DOTNET_ROOT}"/sdk/*/Microsoft.NETCoreSdk.BundledVersions.props
	sed \
		-e "s|<NETCoreSdkRuntimeIdentifier>.*|<NETCoreSdkRuntimeIdentifier>linux-bionic-${arch}</NETCoreSdkRuntimeIdentifier>|" \
		-e "s|<NETCoreSdkPortableRuntimeIdentifier>.*|<NETCoreSdkPortableRuntimeIdentifier>linux-bionic-${arch}</NETCoreSdkPortableRuntimeIdentifier>|" \
		-i "${_DOTNET_ROOT}"/sdk/*/Microsoft.NETCoreSdk.BundledVersions.props
	grep "<NETCoreSdkRuntimeIdentifier>" -nH "${_DOTNET_ROOT}"/sdk/*/Microsoft.NETCoreSdk.BundledVersions.props
	grep "<NETCoreSdkPortableRuntimeIdentifier>" -nH "${_DOTNET_ROOT}"/sdk/*/Microsoft.NETCoreSdk.BundledVersions.props

	# TODO investigate if can replace with runpath or static link
	# this is needed to link libssl.so.3, etc
	cat <<-EOL > "${TERMUX_PREFIX}/bin/dotnet"
	#!${TERMUX_PREFIX}/bin/sh
	LD_LIBRARY_PATH="\${LD_LIBRARY_PATH}:${TERMUX_PREFIX}/lib" exec ${_DOTNET_ROOT}/dotnet "\$@"
	EOL
	chmod 0755 "${TERMUX_PREFIX}/bin/dotnet"

	# https://src.fedoraproject.org/rpms/dotnet8.0/raw/rawhide/f/dotnet.sh.in
	mkdir -p "${TERMUX_PREFIX}/etc/profile.d"
	sed \
		-e "s|@LIBDIR@|${TERMUX_PREFIX}/lib|g" \
		"${TERMUX_PKG_BUILDER_DIR}/dotnet.sh.in" \
		> "${TERMUX_PREFIX}/etc/profile.d/dotnet.sh"

	# shell completion
	install -Dm644 "${TERMUX_PKG_SRCDIR}/src/sdk/scripts/register-completions.bash" "${TERMUX_PREFIX}/share/bash-completion/completions/dotnet"
	install -Dm644 "${TERMUX_PKG_SRCDIR}/src/sdk/scripts/register-completions.zsh" "${TERMUX_PREFIX}/share/zsh/site-functions/_dotnet"

	# manpages
	install -Dm644 -t "${TERMUX_PREFIX}"/share/man/man1 \
		"${TERMUX_PKG_SRCDIR}"/src/sdk/documentation/manpages/sdk/*.1

	# fix executable permissions on files
	find "${_DOTNET_ROOT}" -type f -name 'apphost' -exec chmod 0755 {} \;
	find "${_DOTNET_ROOT}" -type f -name 'singlefilehost' -exec chmod 0755 {} \;
	find "${_DOTNET_ROOT}" -type f -name 'lib*so' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.a' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.dll' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.h' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.json' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.pdb' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.props' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.pubxml' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.targets' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.txt' -exec chmod 0644 {} \;
	find "${_DOTNET_ROOT}" -type f -name '*.xml' -exec chmod 0644 {} \;

	# check libc++
	local dotnet_readelf=$(${READELF} -d ${_DOTNET_ROOT}/dotnet)
	local dotnet_needed=$(echo "${dotnet_readelf}" | sed -ne "s|.*NEEDED.*\[\(.*\)\].*|\1|p")
	if [[ -n "$(echo "${dotnet_needed}" | grep "libc++_shared.so")" ]]; then
		termux_error_exit "
		libc++ found. Check readelf output below:
		${dotnet_readelf}
		"
	fi

	pushd "${TERMUX_PREFIX}"
	# remove unused targeting packs pdb files
	find \
		lib/dotnet/packs/Microsoft.AspNetCore.App.Ref \
		lib/dotnet/packs/Microsoft.NETCore.App.Ref  \
		\( -type f -o -type l \) -name "*.pdb" | sort | xargs -rt rm -f

	# special handling subpackage files
	find \
		lib/dotnet/shared/Microsoft.AspNetCore.App/8.0.* \
		\( -type f -o -type l \) ! -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/aspnetcore-runtime.txt

	find \
		lib/dotnet/shared/Microsoft.AspNetCore.App/8.0.* \
		\( -type f -o -type l \) -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/aspnetcore-runtime-dbg.txt

	find \
		lib/dotnet/packs/Microsoft.AspNetCore.App.Ref/8.0.* \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/aspnetcore-targeting-pack.txt

	find \
		lib/dotnet/packs/Microsoft.NETCore.App.Host.linux-bionic-${arch}/8.0.* \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-apphost-pack.txt

	find \
		bin/dotnet \
		etc/profile.d/dotnet.sh \
		lib/dotnet/LICENSE.txt \
		lib/dotnet/ThirdPartyNotices.txt \
		lib/dotnet/dotnet \
		share/bash-completion/completions/dotnet \
		share/zsh/site-functions/_dotnet \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-host.txt
	echo "share/man/man1" >> "${TERMUX_PKG_TMPDIR}"/dotnet-host.txt

	find \
		lib/dotnet/host/fxr/8.0.* \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-hostfxr.txt

	find \
		lib/dotnet/shared/Microsoft.NETCore.App/8.0.* \
		\( -type f -o -type l \) ! -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-runtime.txt

	find \
		lib/dotnet/shared/Microsoft.NETCore.App/8.0.* \
		\( -type f -o -type l \) -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-runtime-dbg.txt

	find \
		lib/dotnet/metadata/workloads/8.0.* \
		lib/dotnet/packs/Microsoft.AspNetCore.App.Runtime.linux-bionic-${arch}/8.0.* \
		lib/dotnet/packs/Microsoft.NETCore.App.Runtime.linux-bionic-${arch}/8.0.* \
		lib/dotnet/sdk/8.0.* \
		lib/dotnet/sdk-manifests \
		\( -type f -o -type l \) ! -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-sdk.txt

	find \
		lib/dotnet/packs/Microsoft.AspNetCore.App.Runtime.linux-bionic-${arch}/8.0.* \
		lib/dotnet/packs/Microsoft.NETCore.App.Runtime.linux-bionic-${arch}/8.0.* \
		lib/dotnet/sdk/8.0.* \
		\( -type f -o -type l \) -name "*.pdb" | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-sdk-dbg.txt

	find \
		lib/dotnet/packs/Microsoft.NETCore.App.Ref/8.0.* \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-targeting-pack.txt

	find \
		lib/dotnet/templates/8.0.* \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/dotnet-templates.txt

	find \
		lib/dotnet/packs/NETStandard.Library.Ref \
		\( -type f -o -type l \) | sort \
		> "${TERMUX_PKG_TMPDIR}"/netstandard-targeting-pack-2.1.txt
	popd

	local txt
	for txt in "${TERMUX_PKG_TMPDIR}"/*.txt; do
		echo "INFO: $txt"
		cat "$txt"
	done
}

termux_step_post_make_install() {
	echo "INFO: Restoring sysroot"
	rm -fr "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	mv -v "${TERMUX_STANDALONE_TOOLCHAIN}"/sysroot{.tmp,}

	unset ANDROID_NDK_ROOT CONFIG CROSSCOMPILE ROOTFS_DIR
	unset EXTRA_CFLAGS EXTRA_CXXFLAGS EXTRA_LDFLAGS
	unset arch
}

termux_step_post_massage() {
	local _microsoft_netcore_app_dir="${TERMUX_PREFIX}/lib/dotnet/shared/Microsoft.NETCore.App"
	local _rpath_check_file
	for _rpath_check_file in libSystem.Security.Cryptography.Native.OpenSsl.so libcoreclr.so libSystem.Net.Security.Native.so; do
		if [[ ! -f "${_microsoft_netcore_app_dir}/${TERMUX_PKG_VERSION}/${_rpath_check_file}" ]]; then
			echo "ERROR: ${_microsoft_netcore_app_dir}/${TERMUX_PKG_VERSION}/${_rpath_check_file} does not exist!"
			echo "ERROR: Finding '${_rpath_check_file}' in '${_microsoft_netcore_app_dir}':"
			find "${_microsoft_netcore_app_dir}" -name "${_rpath_check_file}" | sort || :
			termux_error_exit "Please review error above!"
		fi
		local _rpath_check_readelf=$("$READELF" -d "${_microsoft_netcore_app_dir}/${TERMUX_PKG_VERSION}/${_rpath_check_file}")
		local _rpath=$(echo "${_rpath_check_readelf}" | sed -ne "s|.*RUNPATH.*\[\(.*\)\].*|\1|p")
		if [[ "${_rpath}" != "${TERMUX_PREFIX}/lib" ]]; then
			termux_error_exit "
			Excessive RUNPATH found. Check readelf output below:
			${_rpath_check_readelf}
			"
		fi
	done
}

# References:
# https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core
# https://learn.microsoft.com/en-us/dotnet/core/distribution-packaging
# https://git.alpinelinux.org/aports/tree/community/dotnet8-stage0/APKBUILD
# https://git.alpinelinux.org/aports/tree/community/dotnet8-runtime/APKBUILD
# https://git.alpinelinux.org/aports/tree/community/dotnet8-sdk/APKBUILD
# https://src.fedoraproject.org/rpms/dotnet8.0/blob/rawhide/f/dotnet8.0.spec
# https://git.launchpad.net/ubuntu/+source/dotnet8/tree/debian/rules
# https://gitlab.archlinux.org/archlinux/packaging/packages/dotnet-core/-/blob/main/PKGBUILD
