TERMUX_PKG_HOMEPAGE=https://dart.dev/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="sdk/LICENSE"
TERMUX_PKG_MAINTAINER="@samujjal-gogoi"
TERMUX_PKG_VERSION="3.6.2"
TERMUX_PKG_SRCURL=https://github.com/dart-lang/sdk/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bd2a2d650cd4dd41da889b0c17beea866401469536f312c924489ccc6607ccee
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# Dart uses tar and gzip to extract downloaded packages.
# Busybox-based versions of such utilities cause issues so
# complete ones should be used.
TERMUX_PKG_DEPENDS="gzip, tar"

termux_pkg_auto_update() {
	curl -fLSso VERSION https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION
	local latest_version=$(jq -r .version VERSION)
	rm -f VERSION
	if [[ ${latest_version} = "null" ]]; then
		echo "ERROR: Failed to get latest version."
		exit 1
	fi
	if [[ ${latest_version} = ${TERMUX_PKG_VERSION} ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi
	termux_pkg_upgrade_version ${latest_version}
}

termux_step_get_source() {
	mkdir -p ${TERMUX_PKG_SRCDIR}
	cd ${TERMUX_PKG_SRCDIR}
	git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH="${PWD}/depot_tools:${PATH}"
	fetch --no-history --no-hooks dart
	cd sdk
	git fetch --depth 1 origin tag ${TERMUX_PKG_VERSION}
	git checkout ${TERMUX_PKG_VERSION}
	echo 'target_os = ["android"]' >> ../.gclient
	gclient sync -DRf
}

termux_step_make_install() {
	cd sdk
	case "$TERMUX_ARCH" in
		arm)
			./tools/build.py --no-rbe -m release -a arm --os android create_sdk
			mv ./out/ReleaseAndroidARM/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		i686)
			./tools/build.py --no-rbe -m release -a ia32 --os android create_sdk
			mv ./out/ReleaseAndroidIA32/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		aarch64)
			./tools/build.py --no-rbe -m release -a arm64c --os android create_sdk
			mv ./out/ReleaseAndroidARM64C/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		x86_64)
			./tools/build.py --no-rbe -m release -a x64c --os android create_sdk
			mv ./out/ReleaseAndroidX64C/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		*)
			termux_error_exit "Unsupported arch '${TERMUX_ARCH}'"
		;;
	esac
	for file in ${TERMUX_PREFIX}/lib/dart-sdk/bin/*; do
		if [[ -f ${file} && -x ${file} ]]; then
			echo -e "#!${TERMUX_PREFIX}/bin/sh\nexec ${file} \"\$@\"" > "${TERMUX_PREFIX}/bin/$(basename "${file}")"
			chmod +x "${TERMUX_PREFIX}/bin/$(basename "${file}")"
		fi
	done
}

termux_step_post_make_install() {
	install -Dm 600 ${TERMUX_PKG_BUILDER_DIR}/dart-pub-bin.sh ${TERMUX_PREFIX}/etc/profile.d/dart-pub-bin.sh
}
