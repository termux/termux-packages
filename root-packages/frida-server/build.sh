TERMUX_PKG_HOMEPAGE=https://www.frida.re
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
_MAJOR_VERSION=11
_MINOR_VERSION=0
_MICRO_VERSION=12
TERMUX_PKG_VERSION=$_MAJOR_VERSION.$_MINOR_VERSION.$_MICRO_VERSION
TERMUX_PKG_SRCURL="https://github.com/frida/frida/archive/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256="4ef25eff488b8283ef50ea28b8f40c4da197b13601f78a1a508b7373a7ef7ca0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"

###
# NOTE THAT BUILDING FRIDA REQUIRES npm AND rsync
###

#          submodule name              commit                             sha256
_submodules=("capstone"     "a1a383436ba147767af1887c2015e5a863359669" "e3267fa036a84c695d371a08830701702b82fa32a961b0f5ecaa65a56eaf5dcc"
	     "frida-core"   "29a784e39a4306a42dced23d5f29bfdef78e2af9" "999f2cf06778d0844edc30029920b1fd1917f8e71c87e5798ddfccf1fc8ad47f"
	     "frida-gum"    "97b135889d237bde25d124b2dc50e781d02fe3d0" "f8d647e73d52a9cce79e6089c2438e36dd518dda01937597fd4da4760089d640"
	     "frida-python" "cf4033d9067b7926d1449bc2324deb1d9ea7e43c" "ba8ff5c3c170143734308734ced12fa3ed245ade19e9149912cdaf301ef92bda"
	     "frida-clr"    "e3260d8f0c749372c4ab4fbb243cfe2c4e0f1eef" "273975246bdd36cc45f7f2c6ea65f079336902e701aa4cad2e462e81d3437afa"
	     "frida-qml"    "af6fde67449bad7aec1d36071ba7cbc7ef2f2dc7" "61484407afbb89306f874f2af3275db8f8955376a5acf6cb947cb89b1ff757a9"
	     "frida-swift"  "4fe0b0891430bd28ce9faeb62b6b29644e97f06e" "0ac156bfa8063a53ee42a42d77414a257f283500edc1b94ff335abc4ffc9bfff"
	     "releng/meson" "00a48399a1f5f2dab637bb7dca74dd27980becdc" "1e54e6d56dd7f5d9430849f23ba3653d5a4a137c4bfbaacf8aef8fdefc6df68c")

termux_step_pre_configure () {
	mkdir -p $TERMUX_PKG_SRCDIR/build
	cd $TERMUX_PKG_TMPDIR
	# github's releases doesn't include git submodules, therefore we have to do this mess:
	for idx in $(seq 0 3 $((${#_submodules[@]}-1))); do
		termux_download https://github.com/frida/$(basename ${_submodules[$idx]})/archive/${_submodules[$((idx+1))]}.zip \
				$TERMUX_PKG_CACHEDIR/$(basename ${_submodules[$idx]}).zip \
				${_submodules[$((idx+2))]}
		unzip -q $TERMUX_PKG_CACHEDIR/$(basename ${_submodules[$idx]}).zip
		mv $(basename ${_submodules[$idx]})-*/* $TERMUX_PKG_SRCDIR/${_submodules[$idx]}/
		# releng/common.mk normally echoes commit message to these *submodule-stamp files
		echo ${_submodules[$((idx+1))]} > $TERMUX_PKG_SRCDIR/build/.$(basename ${_submodules[$idx]})-submodule-stamp
	done
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
	make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	rsync -r $TERMUX_PKG_SRCDIR/build/frida-android-$arch/ $TERMUX_PREFIX
}
