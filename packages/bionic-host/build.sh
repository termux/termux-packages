TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/bionic/
TERMUX_PKG_DESCRIPTION="bionic libc, libm, libdl and dynamic linker for ubuntu host"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.0.0-r51"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SHA256=6b42a86fc2ec58f86862a8f09a5465af0758ce24f2ca8c3cabb3bb6a81d96525
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
# Should be handled by AOSP build system so I am disable it here.
TERMUX_PKG_UNDEF_SYMBOLS_FILES="all"

# Function to obtain the .deb URL
obtain_deb_url() {
	# jammy is last known Ubuntu distro which contains `libncurses.so.5` in packages
	local url="https://packages.ubuntu.com/jammy/amd64/$1/download"
	local retries=5
	local wait=5
	local attempt
	local deb_url

	for ((attempt=1; attempt<=retries; attempt++)); do
		local PAGE="$(curl -s "$url")"
		>&2 echo page
		>&2 echo "$PAGE"
		if deb_url=$(echo "$PAGE" | grep -Eo 'http://.*\.deb' | head -n 1); then
			if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
			else
				>&2 echo "Attempt $attempt: Received empty URL or server answered with `Internal server error` page. Retrying in $wait seconds..."
			fi
		else
			>&2 echo "Attempt $attempt: Command failed. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	>&2 echo "Failed to obtain URL after $retries attempts."
	exit 1
}


termux_step_get_source() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	case "${TERMUX_ARCH}" in
		i686) _ARCH=x86 ;;
		aarch64) _ARCH=arm64 ;;
		*) _ARCH=${TERMUX_ARCH} ;;
	esac

	export LD_LIBRARY_PATH="${TERMUX_PKG_SRCDIR}/prefix/lib/x86_64-linux-gnu:${TERMUX_PKG_SRCDIR}/prefix/usr/lib/x86_64-linux-gnu"
	export PATH="$(sed "s#/home/`whoami`/.cargo/bin:##" <<< $PATH):${TERMUX_PKG_SRCDIR}/prefix/usr/bin:$PATH"

	mkdir -p ${TERMUX_PKG_SRCDIR}/prefix
	cd ${TERMUX_PKG_SRCDIR}

	cp -f ${TERMUX_PKG_BUILDER_DIR}/LICENSE.txt ${TERMUX_PKG_SRCDIR}/LICENSE.txt
	
	for i in libtinfo5 libncurses5 openssh-client; do
		local URL="$(obtain_deb_url $i)"
		wget "$URL" -O ${TERMUX_PKG_CACHEDIR}/${URL##*/}

		mkdir -p ${TERMUX_PKG_TMPDIR}/${URL##*/}
		ar x ${TERMUX_PKG_CACHEDIR}/${URL##*/} --output=${TERMUX_PKG_TMPDIR}/${URL##*/}
		tar xf ${TERMUX_PKG_TMPDIR}/${URL##*/}/data.tar.zst -C ${TERMUX_PKG_SRCDIR}/prefix
	done

	termux_download https://storage.googleapis.com/git-repo-downloads/repo ${TERMUX_PKG_CACHEDIR}/repo SKIP_CHECKSUM
	chmod +x ${TERMUX_PKG_CACHEDIR}/repo
	${TERMUX_PKG_CACHEDIR}/repo init \
		-u https://android.googlesource.com/platform/manifest \
		-b main -m ${TERMUX_PKG_BUILDER_DIR}/default.xml
	${TERMUX_PKG_CACHEDIR}/repo sync -c -j32

	sed -i '1s|.*|\#!'${TERMUX_PKG_SRCDIR}'/prebuilts/python/linux-x86/2.7.5/bin/python2|' ${TERMUX_PKG_SRCDIR}/bionic/libc/fs_config_generator.py
	sed -i '1s|.*|\#!'${TERMUX_PKG_SRCDIR}'/prebuilts/python/linux-x86/2.7.5/bin/python2|' ${TERMUX_PKG_SRCDIR}/external/clang/clang-version-inc.py
	sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/Android.bp
	sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/crash_dump.cpp
	sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/debuggerd.cpp
}

termux_step_configure() {
	:
}

termux_step_make() {
	env -i LD_LIBRARY_PATH=$LD_LIBRARY_PATH PATH=$PATH bash -c "
		set -e;
		cd ${TERMUX_PKG_SRCDIR}
		source build/envsetup.sh;
		lunch aosp_${_ARCH}-eng;
		make JAVA_NOT_REQUIRED=true linker libc libm libdl libicuuc debuggerd crash_dump
	"
}

termux_step_make_install() {
	mkdir -p ${TERMUX_PREFIX}/opt/bionic-host/usr/icu
	cp ${TERMUX_PKG_SRCDIR}/external/icu/icu4c/source/stubdata/icudt58l.dat ${TERMUX_PREFIX}/opt/bionic-host/usr/icu/
	cp -r ${TERMUX_PKG_SRCDIR}/out/target/product/generic*/system/* ${TERMUX_PREFIX}/opt/bionic-host/
}
