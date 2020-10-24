TERMUX_PKG_HOMEPAGE=https://www.dartlang.org/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="sdk/LICENSE"
TERMUX_PKG_VERSION=2.10.2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

# Dart uses tar and gzip to extract downloaded packages.
# Busybox-based versions of such utilities cause issues so
# complete ones should be used.
TERMUX_PKG_DEPENDS="gzip, tar"

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_CACHEDIR
	cd $TERMUX_PKG_CACHEDIR

	if [ ! -d "./depot_tools/.git" ]; then
		rm -rf depot_tools
		git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	else
		cd depot_tools
		git pull
		cd ..
	fi

	# Doesn't support python as python3.
	mkdir -p $TERMUX_PKG_TMPDIR/fakebin
	ln -sfr /usr/bin/python2 $TERMUX_PKG_TMPDIR/fakebin/python
	export PATH="${TERMUX_PKG_TMPDIR}/fakebin:${TERMUX_PKG_CACHEDIR}/depot_tools:${PATH}"

	if [ -f "${TERMUX_PKG_CACHEDIR}/.gclient" ]; then
		# If existing sources.
		gclient sync
	else
		fetch dart
	fi

	cd sdk
	git checkout $TERMUX_PKG_VERSION
	cd ../

	echo "target_os = ['android']" >> .gclient
	gclient sync -D --force --reset

	# Don't copy sources when executing ./scripts/setup-offline-bundle.sh.
	if [ "$TERMUX_PKG_CACHEDIR/.src" != "$TERMUX_PKG_SRCDIR" ]; then
		mkdir -p $TERMUX_PKG_SRCDIR
		cp -rf $TERMUX_PKG_CACHEDIR/. $TERMUX_PKG_SRCDIR/
	fi
}

termux_step_make() {
	:
}

termux_step_make_install() {
	cd sdk

	rm -f ./out/*/args.gn

	if [ $TERMUX_ARCH = "arm" ]; then
		DART_MAKE_PLATFORM_SDK=true python2 ./tools/build.py --no-goma --mode release --arch=arm --os=android create_sdk
		chmod +x ./out/ReleaseAndroidARM/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidARM/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "i686" ]; then
		DART_MAKE_PLATFORM_SDK=true python2 ./tools/build.py --no-goma --mode release --arch=ia32 --os=android create_sdk
		chmod +x ./out/ReleaseAndroidIA32/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidIA32/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DART_MAKE_PLATFORM_SDK=true python2 ./tools/build.py --no-goma --mode release --arch=arm64 --os=android create_sdk
		chmod +x ./out/ReleaseAndroidARM64/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidARM64/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DART_MAKE_PLATFORM_SDK=true python2 ./tools/build.py --no-goma --mode release --arch=x64 --os=android create_sdk
		chmod +x ./out/ReleaseAndroidX64/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidX64/dart-sdk ${TERMUX_PREFIX}/lib
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	for file in ${TERMUX_PREFIX}/lib/dart-sdk/bin/*; do
		if [[ -f "$file" ]]; then
			echo -e "#!${TERMUX_PREFIX}/bin/sh\nexec $file  \"\$@\"" > ${TERMUX_PREFIX}/bin/$(basename $file)
			chmod +x ${TERMUX_PREFIX}/bin/$(basename $file)
		fi
	done
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/dart-pub-bin.sh \
		$TERMUX_PREFIX/etc/profile.d/dart-pub-bin.sh
}
