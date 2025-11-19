# Contributor: @0x1ACA663
TERMUX_PKG_HOMEPAGE=https://dart.dev/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE=sdk/LICENSE
TERMUX_PKG_MAINTAINER=@0x1ACA663
TERMUX_PKG_VERSION="3.10.1"
TERMUX_PKG_SRCURL=https://github.com/dart-lang/sdk/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a06c72d983ef67dc683a8786561a3239c9666664178807f848e072ba589394e5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXCLUDED_ARCHES=i686

termux_pkg_auto_update() {
	curl --fail --location --show-error --silent --output VERSION \
		https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION
	local version=$(jq --raw-output .version VERSION)
	rm --force VERSION

	case ${version} in
		null) termux_error_exit "Failed to get latest version." ;;
		${TERMUX_PKG_VERSION}) echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'." ;;
		*) termux_pkg_upgrade_version ${version} ;;
	esac
}

termux_step_get_source() {
	mkdir --parents ${TERMUX_PKG_SRCDIR}
	cd ${TERMUX_PKG_SRCDIR}

	git clone --depth 1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH="${PWD}/depot_tools:${PATH}"

	local src_url=https://dart.googlesource.com/sdk.git
	git clone --branch ${TERMUX_PKG_VERSION} --depth 1 --no-tags ${src_url}
	gclient config \
		--name sdk \
		--custom-var download_android_deps=True \
		--unmanaged \
		${src_url}

	gclient sync
}

termux_step_make_install() {
	local arch
	case ${TERMUX_ARCH} in
		arm) arch=arm ;;
		aarch64) arch=arm64 ;;
		x86_64) arch=x64 ;;
		*) termux_error_exit "Unsupported arch '${TERMUX_ARCH}'" ;;
	esac

	cd sdk
	./tools/build.py --no-rbe --arch ${arch} --mode release --os android create_sdk
	mv ./out/ReleaseAndroid${arch^^}/dart-sdk ${TERMUX_PREFIX}/lib
}

termux_step_post_make_install() {
	for file in ${TERMUX_PREFIX}/lib/dart-sdk/bin/*; do
		if [[ -f ${file} && -x ${file} ]]; then
			local wrapper_exe=${TERMUX_PREFIX}/bin/$(basename ${file})
			printf '#!%s/bin/sh\nexec %s "$@"\n' ${TERMUX_PREFIX} ${file} > ${wrapper_exe}
			chmod +x ${wrapper_exe}
		fi
	done

	local dart_internal=${TERMUX_PREFIX}/lib/dart-sdk/lib/_internal
	rm --force ${dart_internal}/vm_platform_strong.dill
	ln --symbolic ${dart_internal}/vm_platform.dill ${dart_internal}/vm_platform_strong.dill

	install -D --mode 600 \
		${TERMUX_PKG_BUILDER_DIR}/dart-pub-bin.sh \
		${TERMUX_PREFIX}/etc/profile.d/dart-pub-bin.sh
}
