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


        fetch --force v8
        pwd

        ls -lah
        
        cd ../

        cat <<- EOF > ./.gclient
	solutions = [
	  {
	    "name": "v8",
	    "url": "https://chromium.googlesource.com/v8/v8.git",
	    "deps_file": "DEPS",
	    "managed": False,
	    "custom_deps": {},
	  },
	]
	EOF
	echo "target_os = ['android']" >> ./.gclient

	gclient sync -D -r $TERMUX_PKG_VERSION  

        cd v8
        #./build/install-build-deps-android.sh

}

termux_step_make() {
        echo "-------------------------"
        ls -la
        cd v8
        termux_setup_gn

        CLANG_BASE=$NDK/toolchains/llvm/prebuilt/linux-x86_64
        BIN_DIR=$CLANG_BASE/bin
        AR=$BIN_DIR/llvm-ar
    #STRIP=$BIN_DIR/${TOOLNAME_PREFIX}-strip

	cp $TERMUX_PKG_BUILDER_DIR/v8.pc $TERMUX_PKG_SRCDIR
	sed -e "s|@VERSION@|$TERMUX_PKG_VERSION|g" \
	    -e "s|@DESCRIPTION@|$TERMUX_PKG_DESCRIPTION|g" \
	    -e "s|@URL@|$TERMUX_PKG_HOMEPAGE|g" \
	    -e "s|@CFLAGS@|$CFLAGS|g" \
	    -i v8.pc

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
	export PKG_CONFIG_PATH=$TERMUX_PREFIX/lib/pkgconfig
	gn gen -C out/$TERMUX_ARCH --args="$(cat <<- EOF
		v8_monolithic=true
		is_component_build=false
		v8_use_external_startup_data=false
		target_cpu="$DEST_CPU"
		v8_target_cpu="$DEST_CPU"
		use_custom_libcxx=false
		is_debug=false
                android_ndk_root="$NDK"
                android_ndk_version = "21d"
                android_ndk_major_version = 21 
                is_clang=true 
                clang_base_path="$CLANG_BASE"
                clang_use_chrome_plugins=false 
		EOF
	)"


}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/lib/ out/$TERMUX_ARCH/obj/libv8_monolith.a
	install -Dm644 -t $TERMUX_PREFIX/include/v8/ include/*.h
	for dir in include/*/; do
		install -Dm644 -t "$TERMUX_PREFIX/include/v8/${dir##include/}" "$dir"/*.h
	done
	install -Dm644 -t $TERMUX_PREFIX/lib/pkgconfig/ v8.pc
}
