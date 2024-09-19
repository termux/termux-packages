TERMUX_PKG_HOMEPAGE=https://dart.dev/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="sdk/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.3
TERMUX_PKG_SRCURL=https://github.com/dart-lang/sdk/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee2cfea26c9eb22a5e7df5f68e13863d4e55ff14c06a286bf98d866f7b85652d
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+.\d+.\d+$'

# Dart uses tar and gzip to extract downloaded packages.
# Busybox-based versions of such utilities cause issues so
# complete ones should be used.
TERMUX_PKG_DEPENDS="gzip, tar"

termux_pkg_auto_update() {
	# Taken from packages/taplo

	# Get latest release tag:
	local api_url="https://api.github.com/repos/dart-lang/sdk/git/refs/tags"
	local latest_refs_tags
	latest_refs_tags=$(curl -s "${api_url}" | jq '.[].ref' | sed -ne "s|.*${TERMUX_PKG_UPDATE_VERSION_REGEXP}\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi

	local latest_version
	latest_version=$(tail -n1 <<< "$latest_refs_tags")
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	# We want to avoid re-filtering the version.
	# It's already cleaned up, so unset the regexp.
	# See: https://github.com/termux/termux-packages/issues/20836
	unset TERMUX_PKG_UPDATE_VERSION_REGEXP

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_get_source() {
	git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	mkdir -p depot_tools/fakebin
	ln -sfr /usr/bin/python depot_tools/fakebin/python
	export PATH="${PWD}/depot_tools/fakebin:${PWD}/depot_tools:${PATH}"

	fetch dart

	echo "target_os = ['android']" >> .gclient
	gclient sync -D --force --reset
}

termux_step_pre_configure() {
	sed -i -e 's:\([^A-Za-z0-9_]\)/usr/bin:\1'$TERMUX_PREFIX'/local/bin:g' \
		-e 's:\([^A-Za-z0-9_]\)/bin:\1'$TERMUX_PREFIX'/bin:g' \
		"$TERMUX_PKG_SRCDIR/sdk/third_party/pkg/pub/lib/src/io.dart"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	cd sdk

	rm -f ./out/*/args.gn

	case "$TERMUX_ARCH" in
		"arm")
			python3 ./tools/build.py --no-rbe --mode release --arch=arm --os=android create_sdk
			chmod +x ./out/ReleaseAndroidARM/dart-sdk/bin/*
			cp -r ./out/ReleaseAndroidARM/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		"i686")
			python3 ./tools/build.py --no-rbe --mode release --arch=ia32 --os=android create_sdk
			chmod +x ./out/ReleaseAndroidIA32/dart-sdk/bin/*
			cp -r ./out/ReleaseAndroidIA32/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		"aarch64")
			python3 ./tools/build.py --no-rbe --mode release --arch=arm64c --os=android create_sdk
			chmod +x ./out/ReleaseAndroidARM64C/dart-sdk/bin/*
			cp -r ./out/ReleaseAndroidARM64C/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		"x86_64")
			python3 ./tools/build.py --no-rbe --mode release --arch=x64c --os=android create_sdk
			chmod +x ./out/ReleaseAndroidX64C/dart-sdk/bin/*
			cp -r ./out/ReleaseAndroidX64C/dart-sdk "${TERMUX_PREFIX}/lib"
		;;
		*)
			termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
		;;
	esac

	for file in "${TERMUX_PREFIX}/lib/dart-sdk/bin"/*; do
		if [[ -f "$file" ]]; then
			echo -e "#!${TERMUX_PREFIX}/bin/sh\nexec $file  \"\$@\"" > "${TERMUX_PREFIX}/bin/$(basename "$file")"
			chmod +x "${TERMUX_PREFIX}/bin/$(basename "$file")"
		fi
	done
}

termux_step_post_make_install() {
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/dart-pub-bin.sh" \
		"$TERMUX_PREFIX/etc/profile.d/dart-pub-bin.sh"
}
