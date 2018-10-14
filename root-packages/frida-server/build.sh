TERMUX_PKG_HOMEPAGE=https://www.frida.re
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
_MAJOR_VERSION=12
_MINOR_VERSION=2
_MICRO_VERSION=14
TERMUX_PKG_VERSION=()
TERMUX_PKG_SHA256=()
TERMUX_PKG_VERSION+=($_MAJOR_VERSION.$_MINOR_VERSION.$_MICRO_VERSION) # frida
# Sort of abusive use of $TERMUX_PKG_VERSION:
TERMUX_PKG_VERSION+=(7388bf76dc65d1962d7d514c92de8d6be7555599) # capstone
TERMUX_PKG_VERSION+=(6193db218e9f31cfe2246bdd48afd13a20147a8a) # frida-core
TERMUX_PKG_VERSION+=(2d62e31310ffe0473a29f5cfbbab10f79e2825bb) # frida-gum
TERMUX_PKG_VERSION+=(2ed895b881f69206df28854791ffb84d301709a6) # frida-python
TERMUX_PKG_VERSION+=(7754b239601babc0dcbad4f8ee31681235981adb) # frida-clr
TERMUX_PKG_VERSION+=(6e7b9a55b5b59b32e601f6934c2d0a6e3c299161) # frida-qml
TERMUX_PKG_VERSION+=(2c9cc1f87b839b8621afdfce43e44da29deaafab) # frida-swift
TERMUX_PKG_VERSION+=(931f387786fbc92fa9c678bf72b60fc040ce895a) # releng/meson

TERMUX_PKG_SHA256+=(44a8c6f2b2f507485e1f2000e7f715b08df57c71b5421f3f803413c8453bb9d0) # frida
TERMUX_PKG_SHA256+=(43ef0cc72fc19b72393be94d01dcad48835f98a72475aea8187f47ff8475014d) # capstone
TERMUX_PKG_SHA256+=(07ee95b8714ab73e66496b27074319c7fa5a4872184a10492ee6b1d387f46dbe) # frida-core
TERMUX_PKG_SHA256+=(a684c9e5adada5af1247fd26fd916e0f0bc525d4f1a51c512a5c46f18f1c0a75) # frida-gum
TERMUX_PKG_SHA256+=(32f0e9108c7a09f6ffff7c542dcc6352a48c852186bb59d8ff384298bf105ba7) # frida-python
TERMUX_PKG_SHA256+=(0a60f97a32ea1c926b5bf060a822a0d6d44f5e047b80269e7ea6fbc16a178640) # frida-clr
TERMUX_PKG_SHA256+=(c65eb620a879e386268b50e1369c808c0dd92fdcac711b15fb3089b1c1493af9) # frida-qml
TERMUX_PKG_SHA256+=(9e5fe8463dfaa829d95787a77f613eef45e15e094e54e7df3c944acedbd76693) # frida-swift
TERMUX_PKG_SHA256+=(42fc33147373f7ee8293486a420d32abc7aea956adfba5c7e98ccdacb1c6cf07) # releng/meson
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
	local node_version=8.12.0
	termux_download https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-x64.tar.xz \
			$TERMUX_PKG_CACHEDIR/node-v${node_version}-linux-x64.tar.xz \
			29a20479cd1e3a03396a4e74a1784ccdd1cf2f96928b56f6ffa4c8dae40c88f2
	tar -xf $TERMUX_PKG_CACHEDIR/node-v${node_version}-linux-x64.tar.xz --strip-components=1
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
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	# Only include frida-server and frida-inject. Is something else useful?
	install $TERMUX_PKG_BUILDDIR/build/frida-android-$arch/bin/frida-server $TERMUX_PREFIX/bin/
	install $TERMUX_PKG_BUILDDIR/build/frida-android-$arch/bin/frida-inject $TERMUX_PREFIX/bin/
}
