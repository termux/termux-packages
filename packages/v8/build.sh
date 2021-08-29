TERMUX_PKG_HOMEPAGE=https://v8.dev
TERMUX_PKG_DESCRIPTION="Google's open source JavaScript engine"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=9.4.140
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {

        mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR

	git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
	mkdir -p depot_tools/fakebin
	ln -sfr /usr/bin/python2 depot_tools/fakebin/python
	export PATH="$(pwd)/depot_tools/fakebin:$(pwd)/depot_tools:${PATH}"


        fetch --force --no-history v8
        pwd
        ls -lah

	echo "target_os = ['android']" >> ./.gclient

	gclient sync -D -r -n --no-history $TERMUX_PKG_VERSION

        cd v8
        ./build/install-build-deps-android.sh

}

termux_step_make() {
        ls -lah
	#termux_setup_gn
	
	#cp $TERMUX_PKG_BUILDER_DIR/v8.pc $TERMUX_PKG_SRCDIR
	#sed -e "s|@VERSION@|$TERMUX_PKG_VERSION|g" \
	#    -e "s|@DESCRIPTION@|$TERMUX_PKG_DESCRIPTION|g" \
	#    -e "s|@URL@|$TERMUX_PKG_HOMEPAGE|g" \
	#    -e "s|@CFLAGS@|$CFLAGS|g" \
	#    -i v8.pc

	local DEST_CPU
	if [ $TERMUX_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $TERMUX_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	fi
	#export PKG_CONFIG_PATH=$TERMUX_PREFIX/lib/pkgconfig     
        python2 tools/dev/v8gen.py arm64.release -vv -- '
        target_os = "android"
        target_cpu = "arm64"
        v8_target_cpu = "arm64"
        is_component_build = false
        v8_use_external_startup_data = false
        v8_static_library = true
        use_custom_libcxx=false
        v8_monolithic = true
        symbol_level = 0
        '

	# Create missing directories

	ninja -C out/arm64 v8_monolith
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/lib/ out/$TERMUX_ARCH/obj/libv8_monolith.a
	install -Dm644 -t $TERMUX_PREFIX/include/v8/ include/*.h
	for dir in include/*/; do
		install -Dm644 -t "$TERMUX_PREFIX/include/v8/${dir##include/}" "$dir"/*.h
	done
	install -Dm644 -t $TERMUX_PREFIX/lib/pkgconfig/ v8.pc
}
