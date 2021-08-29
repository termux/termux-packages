TERMUX_PKG_HOMEPAGE=https://v8.dev
TERMUX_PKG_DESCRIPTION="Google's open source JavaScript engine"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=9.4.140
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
	rm -rf $TERMUX_PKG_CACHEDIR/depot_tools
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --depth 1 $TERMUX_PKG_CACHEDIR/depot_tools
	rm -f $TERMUX_PKG_CACHEDIR/depot_tools/{ninja,gn}
	
	export PATH=$TERMUX_PKG_CACHEDIR/depot_tools:$PATH

	cd $TERMUX_PKG_CACHEDIR
	rm -rf $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
        fetch --force v8
        pwd
        ls -lah

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

}

termux_step_make() {
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
	gn gen -C out/$TERMUX_ARCH --args="$(cat <<- EOF
		v8_monolithic=true
		is_component_build=false
		v8_use_external_startup_data=false
		target_cpu="$DEST_CPU"
		v8_target_cpu="$DEST_CPU"
		use_custom_libcxx=false
		is_debug=false
		use_sysroot=false
		is_clang=false
		EOF
	)"

	# Create missing directories
	mkdir -p out/$TERMUX_ARCH/gen/shim_headers/icui18n_shim/third_party/icu/source/i18n/unicode/ \
		out/$TERMUX_ARCH/gen/shim_headers/icuuc_shim/third_party/icu/source/common/unicode

	ninja -C out/$TERMUX_ARCH v8_monolith
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/lib/ out/$TERMUX_ARCH/obj/libv8_monolith.a
	install -Dm644 -t $TERMUX_PREFIX/include/v8/ include/*.h
	for dir in include/*/; do
		install -Dm644 -t "$TERMUX_PREFIX/include/v8/${dir##include/}" "$dir"/*.h
	done
	install -Dm644 -t $TERMUX_PREFIX/lib/pkgconfig/ v8.pc
}
