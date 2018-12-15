TERMUX_PKG_HOMEPAGE=https://www.frida.re/
TERMUX_PKG_DESCRIPTION="Dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers"
_MAJOR_VERSION=12
_MINOR_VERSION=2
_MICRO_VERSION=26
TERMUX_PKG_VERSION=()
TERMUX_PKG_SHA256=()
TERMUX_PKG_VERSION+=(${_MAJOR_VERSION}.$_MINOR_VERSION.$_MICRO_VERSION) # frida
# Sort of abusive use of $TERMUX_PKG_VERSION:
TERMUX_PKG_VERSION+=(7388bf76dc65d1962d7d514c92de8d6be7555599) # capstone
TERMUX_PKG_VERSION+=(7754b239601babc0dcbad4f8ee31681235981adb) # frida-clr
TERMUX_PKG_VERSION+=(56b8b55815c67b1fa7b5c483bf92e1724c600175) # frida-core
TERMUX_PKG_VERSION+=(a1cdb28e16ff2888c582ddd34b939a6d2b2146d1) # frida-gum
TERMUX_PKG_VERSION+=(cb736c69c7d47ee447515f78d476a3e9de525712) # frida-node
TERMUX_PKG_VERSION+=(5c2dc4da5549c9c30e7af944281fb3c6033c2c4c) # frida-python
TERMUX_PKG_VERSION+=(6e7b9a55b5b59b32e601f6934c2d0a6e3c299161) # frida-qml
TERMUX_PKG_VERSION+=(2c9cc1f87b839b8621afdfce43e44da29deaafab) # frida-swift
TERMUX_PKG_VERSION+=(cb3df03d31c3f801745485787e5dc9e42809a230) # frida-tools
TERMUX_PKG_VERSION+=(931f387786fbc92fa9c678bf72b60fc040ce895a) # releng/meson

TERMUX_PKG_SHA256+=(c70b70be06c65252c3e5d914101186ade61eb4a6214f4b29e80ad3deecb27557) # frida
TERMUX_PKG_SHA256+=(43ef0cc72fc19b72393be94d01dcad48835f98a72475aea8187f47ff8475014d) # capstone
TERMUX_PKG_SHA256+=(0a60f97a32ea1c926b5bf060a822a0d6d44f5e047b80269e7ea6fbc16a178640) # frida-clr
TERMUX_PKG_SHA256+=(f5ff752bc03de0c795bc213f04516c6f880a151955bf2b45520b599be472ad56) # frida-core
TERMUX_PKG_SHA256+=(1d17ffb57936dafd29f4745535a3327af191fcbdc45211fee87abd91662e3ca1) # frida-gum
TERMUX_PKG_SHA256+=(fbf0c770d6e38f5cd60b3f0616c495a62da3fd25b5f67b9816ef1024dce82246) # frida-node
TERMUX_PKG_SHA256+=(0bffd060a0f8c1bf1ad7b1837c10fc2d39ea2854861b7727f5336bb173e12cea) # frida-python
TERMUX_PKG_SHA256+=(c65eb620a879e386268b50e1369c808c0dd92fdcac711b15fb3089b1c1493af9) # frida-qml
TERMUX_PKG_SHA256+=(9e5fe8463dfaa829d95787a77f613eef45e15e094e54e7df3c944acedbd76693) # frida-swift
TERMUX_PKG_SHA256+=(b5476b10cdc1bc930154c52203a89fae8539432c49575e21551d4e1425252dae) # frida-tools
TERMUX_PKG_SHA256+=(42fc33147373f7ee8293486a420d32abc7aea956adfba5c7e98ccdacb1c6cf07) # releng/meson

_modules=(frida capstone frida-clr frida-core frida-gum frida-node frida-python frida-qml frida-swift frida-tools meson)
TERMUX_PKG_SRCURL=(https://github.com/frida/frida/archive/$TERMUX_PKG_VERSION.tar.gz
		   https://github.com/frida/capstone/archive/${TERMUX_PKG_VERSION[1]}.zip
		   https://github.com/frida/frida-clr/archive/${TERMUX_PKG_VERSION[2]}.zip
		   https://github.com/frida/frida-core/archive/${TERMUX_PKG_VERSION[3]}.zip
		   https://github.com/frida/frida-gum/archive/${TERMUX_PKG_VERSION[4]}.zip
		   https://github.com/frida/frida-node/archive/${TERMUX_PKG_VERSION[5]}.zip
		   https://github.com/frida/frida-python/archive/${TERMUX_PKG_VERSION[6]}.zip
		   https://github.com/frida/frida-qml/archive/${TERMUX_PKG_VERSION[7]}.zip
		   https://github.com/frida/frida-swift/archive/${TERMUX_PKG_VERSION[8]}.zip
		   https://github.com/frida/frida-tools/archive/${TERMUX_PKG_VERSION[9]}.zip
		   https://github.com/frida/meson/archive/${TERMUX_PKG_VERSION[10]}.zip)

TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS="ANDROID_NDK_ROOT=$HOME/lib/android-ndk"
TERMUX_PKG_HOSTBUILD=yes

termux_step_host_build () {
	local node_version=8.14.0 #9.11.2
	termux_download https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-x64.tar.xz \
			${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz \
			a56d1af4d7da81504338b09809cf10b3144808d47d4117b9bd9a5a4ec4d5d9b9
	tar -xf ${TERMUX_PKG_CACHEDIR}/node-v${node_version}-linux-x64.tar.xz --strip-components=1
}

termux_step_post_extract_package () {
	mkdir build
	for i in $(seq 1 $(( ${#_modules[@]}-1 ))); do
		rm -rf ${_modules[$i]}
		mv ${_modules[$i]}-${TERMUX_PKG_VERSION[$i]} ${_modules[$i]}
		echo ${TERMUX_PKG_VERSION[$i]} > ${TERMUX_PKG_SRCDIR}/build/.${_modules[$i]}-submodule-stamp
	done
	mv meson releng/
}

termux_step_post_configure () {
	# frida-version.h is normally generated from git and the commits.
	sed -i "s/@TERMUX_PKG_VERSION@/$TERMUX_PKG_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MAJOR_VERSION@/$_MAJOR_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MINOR_VERSION@/$_MINOR_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
	sed -i "s/@_MICRO_VERSION@/$_MICRO_VERSION/g" ${TERMUX_PKG_SRCDIR}/build/frida-version.h
}

termux_step_make () {
	if [[ ${TERMUX_ARCH} == "aarch64" ]]; then
		arch=arm64
	elif [[ ${TERMUX_ARCH} == "i686" ]]; then
		arch=x86
	else
		arch=${TERMUX_ARCH}
	fi
	# Build only for desired architecture:
	sed -i "s/@TERMUX_ARCH@/$arch/g" ${TERMUX_PKG_SRCDIR}/Makefile.linux.mk
	PATH=${TERMUX_PKG_HOSTBUILD_DIR}/bin:$PATH make server-android ${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install () {
	# Only include frida-server and frida-inject. Is something else useful?
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-server ${TERMUX_PREFIX}/bin/
	install ${TERMUX_PKG_BUILDDIR}/build/frida-android-${arch}/bin/frida-inject ${TERMUX_PREFIX}/bin/
}
