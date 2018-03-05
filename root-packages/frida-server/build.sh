TERMUX_PKG_HOMEPAGE=https://www.frida.re
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
_MAJOR_VERSION=10
_MINOR_VERSION=6
_MICRO_VERSION=55
TERMUX_PKG_VERSION=$_MAJOR_VERSION.$_MINOR_VERSION.$_MICRO_VERSION
TERMUX_PKG_SRCURL="https://github.com/frida/frida/archive/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256="9ffcc4927bea960d80af2a0dab0e022dfe1dce511aa6fbc60dd0c2994a7477b0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"

#          submodule name              commit                             sha256
_submodules=("capstone"     "a1a383436ba147767af1887c2015e5a863359669" "e3267fa036a84c695d371a08830701702b82fa32a961b0f5ecaa65a56eaf5dcc"
	     "frida-core"   "b46081304f904773882f6efac4507c627a38fcdb" "369933f40d3b8b8cd7345734f83d668c31ea6b45b606f26babb202ae6361240c"
	     "frida-gum"    "919bb8ed76382053214cb874fd848ee49c6833cf" "cbc33931b28919eb3c78894357ec5a7f496a2771a3100d72923b923aea25d9c2"
	     "frida-python" "47f491c6b93868167c95477b85cd827c582cb0c7" "f186209bc3f930f4d31d1e9e326e8e3ea4e3bb5fe85bc4360a631eadd9d1a9cc"
	     "frida-clr"    "145e0eda9f449fc7ac33c77f3665f0830d02393d" "39ab131eca2eb16df047f65344dc1f7cc9f28a62142e6bf1af242e3c240f501b"
	     "frida-qml"    "af6fde67449bad7aec1d36071ba7cbc7ef2f2dc7" "61484407afbb89306f874f2af3275db8f8955376a5acf6cb947cb89b1ff757a9"
	     "frida-swift"  "b2ebd7da1ee2eb08cc08e637563b2535985e00ff" "771202747cec02d10d30e2d2601f87b17496dcbcf5cfb00e0fbba673b791216d"
    	     "releng/meson" "eb26824fa9078b857fc3dd266434894a4fde1b35" "500f1190545451e627a9c8a73f3666d13821b7af2f32abab4ec9dd39afbdebc7")

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
	make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
	# make python-64 ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	if [ $TERMUX_ARCH == "aarch64" ]; then
		arch=arm64
	else
		arch=$TERMUX_ARCH
	fi
	
	rsync -r $TERMUX_PKG_SRCDIR/build/frida-android-$arch /data/data/com.termux/files/usr/
}
