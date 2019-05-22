TERMUX_PKG_HOMEPAGE=https://www.dartlang.org/
TERMUX_PKG_DESCRIPTION="Dart is a general-purpose programming language."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SKIP_SRC_EXTRACT=1
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_extract_package() {
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR

	git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	export PATH="$(pwd)/depot_tools:${PATH}"

	fetch dart

	cd sdk
	git checkout $TERMUX_PKG_VERSION
	cd ../

	echo "target_os = ['android']" >> .gclient
	gclient sync -D --force --reset
}

termux_step_make() {
	cd sdk

	local DEST_CPU
	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	rm -f ./out/*/args.gn
	DART_MAKE_PLATFORM_SDK=true python2 ./tools/build.py --mode release --arch=$DEST_CPU --os=android create_sdk
}

termux_step_make_install() {
	cd sdk

	local DEST_CPU
	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="ARM"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="IA32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="ARM64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="X64"
	else
		termux_error_exit "Unsupported arch '$TERMUX_ARCH'"
	fi

	chmod +x ./out/ReleaseAndroid${DEST_CPU}/dart-sdk/bin/*
	cp -r ./out/ReleaseAndroid${DEST_CPU}/dart-sdk ${TERMUX_PREFIX}/lib

	for file in ${TERMUX_PREFIX}/lib/dart-sdk/bin/*; do
		if [[ -f "$file" ]]; then
			echo -e "#!${TERMUX_PREFIX}/bin/sh\nexec $file  \"\$@\"" > ${TERMUX_PREFIX}/bin/$(basename $file)
			chmod +x ${TERMUX_PREFIX}/bin/$(basename $file)
		fi
	done
}
