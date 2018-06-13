TERMUX_PKG_HOMEPAGE=https://www.frida.re
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
_MAJOR_VERSION=11
_MINOR_VERSION=0
_MICRO_VERSION=12
TERMUX_PKG_VERSION=()
TERMUX_PKG_SHA256=()
TERMUX_PKG_VERSION+=($_MAJOR_VERSION.$_MINOR_VERSION.$_MICRO_VERSION) # frida
# Sort of abusive use of $TERMUX_PKG_VERSION:
TERMUX_PKG_VERSION+=(a1a383436ba147767af1887c2015e5a863359669) # capstone
TERMUX_PKG_VERSION+=(29a784e39a4306a42dced23d5f29bfdef78e2af9) # frida-core
TERMUX_PKG_VERSION+=(97b135889d237bde25d124b2dc50e781d02fe3d0) # frida-gum
TERMUX_PKG_VERSION+=(cf4033d9067b7926d1449bc2324deb1d9ea7e43c) # frida-python
TERMUX_PKG_VERSION+=(e3260d8f0c749372c4ab4fbb243cfe2c4e0f1eef) # frida-clr
TERMUX_PKG_VERSION+=(af6fde67449bad7aec1d36071ba7cbc7ef2f2dc7) # frida-qml
TERMUX_PKG_VERSION+=(4fe0b0891430bd28ce9faeb62b6b29644e97f06e) # frida-swift
TERMUX_PKG_VERSION+=(00a48399a1f5f2dab637bb7dca74dd27980becdc) # releng/meson
TERMUX_PKG_SHA256+=(4ef25eff488b8283ef50ea28b8f40c4da197b13601f78a1a508b7373a7ef7ca0) # frida
TERMUX_PKG_SHA256+=(e3267fa036a84c695d371a08830701702b82fa32a961b0f5ecaa65a56eaf5dcc) # capstone
TERMUX_PKG_SHA256+=(999f2cf06778d0844edc30029920b1fd1917f8e71c87e5798ddfccf1fc8ad47f) # frida-core
TERMUX_PKG_SHA256+=(f8d647e73d52a9cce79e6089c2438e36dd518dda01937597fd4da4760089d640) # frida-gum
TERMUX_PKG_SHA256+=(ba8ff5c3c170143734308734ced12fa3ed245ade19e9149912cdaf301ef92bda) # frida-python
TERMUX_PKG_SHA256+=(273975246bdd36cc45f7f2c6ea65f079336902e701aa4cad2e462e81d3437afa) # frida-clr
TERMUX_PKG_SHA256+=(61484407afbb89306f874f2af3275db8f8955376a5acf6cb947cb89b1ff757a9) # frida-qml
TERMUX_PKG_SHA256+=(0ac156bfa8063a53ee42a42d77414a257f283500edc1b94ff335abc4ffc9bfff) # frida-swift
TERMUX_PKG_SHA256+=(1e54e6d56dd7f5d9430849f23ba3653d5a4a137c4bfbaacf8aef8fdefc6df68c) # releng/meson
_modules=(frida capstone frida-core frida-gum frida-python frida-clr frida-qml frida-swift meson)
TERMUX_PKG_SRCURL=(https://github.com/frida/frida/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/frida/capstone/archive/${TERMUX_PKG_VERSION[1]}.zip
		   https://github.com/frida/frida-core/archive/${TERMUX_PKG_VERSION[2]}.zip
		   https://github.com/frida/frida-gum/archive/${TERMUX_PKG_VERSION[3]}.zip
		   https://github.com/frida/frida-python/archive/${TERMUX_PKG_VERSION[4]}.zip
		   https://github.com/frida/frida-clr/archive/${TERMUX_PKG_VERSION[5]}.zip
		   https://github.com/frida/frida-qml/archive/${TERMUX_PKG_VERSION[6]}.zip
		   https://github.com/frida/frida-swift/archive/${TERMUX_PKG_VERSION[7]}.zip
		   https://github.com/frida/meson/archive/${TERMUX_PKG_VERSION[8]}.zip)

TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"
TERMUX_PKG_HOSTBUILD=yes

termux_step_host_build () {
	termux_download https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz \
		    $TERMUX_PKG_CACHEDIR/node-v8.11.3-linux-x64.tar.xz
	tar -xf $TERMUX_PKG_CACHEDIR/node-v8.11.3-linux-x64.tar.xz --strip-components=1
}

termux_step_post_extract_package () {
	mkdir build
	for i in $(seq 1 $(( ${#_modules[@]}-1 ))); do
		rm -rf ${_modules[$i]}
		mv ${_modules[$i]}-${TERMUX_PKG_VERSION[$i]} ${_modules[$i]}
		echo ${TERMUX_PKG_VERSION[$i]} > $TERMUX_PKG_SRCDIR/build/.${_modules[$i]}-submodule-stamp
	done
	mv meson releng/
}

termux_step_post_configure () {
	# frida-version.h is normally generated from git and the commits.
	sed -i "s/@TERMUX_PKG_VERSION@/$TERMUX_PKG_VERSION/g" $TERMUX_PKG_SRCDIR/build/frida-version.h
	sed -i "s/@_MAJOR_VERSION@/$_MAJOR_VERSION/g" $TERMUX_PKG_SRCDIR/build/frida-version.h
	sed -i "s/@_MINOR_VERSION@/$_MINOR_VERSION/g" $TERMUX_PKG_SRCDIR/build/frida-version.h
	sed -i "s/@_MICRO_VERSION@/$_MICRO_VERSION/g" $TERMUX_PKG_SRCDIR/build/frida-version.h
}

termux_step_make () {
	if [ $TERMUX_ARCH == "aarch64" ]; then
		arch=arm64
	elif [ $TERMUX_ARCH == "i686" ]; then
		arch=x86
	else
		arch=$TERMUX_ARCH
	fi
	# Build only for desired architecture:
	sed -i "s/@TERMUX_ARCH@/$arch/g" $TERMUX_PKG_SRCDIR/Makefile.linux.mk
	NODE=$TERMUX_PKG_HOSTBUILD_DIR/bin/node make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	# Only include frida-server and frida-inject. Is something else useful?
	install $TERMUX_PKG_BUILDDIR/build/frida-android-$arch/bin/frida-server $TERMUX_PREFIX/bin/
	install $TERMUX_PKG_BUILDDIR/build/frida-android-$arch/bin/frida-inject $TERMUX_PREFIX/bin/
}
