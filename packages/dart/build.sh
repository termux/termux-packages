TERMUX_PKG_HOMEPAGE=https://www.dartlang.org/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_LICENSE_FILE="sdk/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.16.0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

# Dart uses tar and gzip to extract downloaded packages.
# Busybox-based versions of such utilities cause issues so
# complete ones should be used.
TERMUX_PKG_DEPENDS="gzip, tar"

termux_step_get_source() {
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR

	git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	mkdir -p depot_tools/fakebin
	ln -sfr /usr/bin/python2 depot_tools/fakebin/python
	export PATH="$(pwd)/depot_tools/fakebin:$(pwd)/depot_tools:${PATH}"

	fetch dart

	cd sdk
	git checkout $TERMUX_PKG_VERSION
	cd ../

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

	if [ $TERMUX_ARCH = "arm" ]; then
		python2 ./tools/build.py --no-goma --mode release --arch=arm --os=android create_sdk
		chmod +x ./out/ReleaseAndroidARM/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidARM/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "i686" ]; then
		python2 ./tools/build.py --no-goma --mode release --arch=ia32 --os=android create_sdk
		chmod +x ./out/ReleaseAndroidIA32/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidIA32/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		python2 ./tools/build.py --no-goma --mode release --arch=arm64c --os=android create_sdk
		chmod +x ./out/ReleaseAndroidARM64C/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidARM64C/dart-sdk ${TERMUX_PREFIX}/lib
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		python2 ./tools/build.py --no-goma --mode release --arch=x64c --os=android create_sdk
		chmod +x ./out/ReleaseAndroidX64C/dart-sdk/bin/*
		cp -r ./out/ReleaseAndroidX64C/dart-sdk ${TERMUX_PREFIX}/lib
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
