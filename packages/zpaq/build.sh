TERMUX_PKG_HOMEPAGE=http://mattmahoney.net/dc/zpaq.html
TERMUX_PKG_DESCRIPTION="a ultra-compression program"
TERMUX_PKG_VERSION=7.15
TERMUX_PKG_SRCURL=http://mattmahoney.net/dc/zpaq$(echo ${TERMUX_PKG_VERSION} | tr -d '.').zip
TERMUX_PKG_SHA256=e85ec2529eb0ba22ceaeabd461e55357ef099b80f61c14f377b429ea3d49d418
TERMUX_PKG_BUILD_IN_SRC=yes
# failed to buils because of undefined reference to libm.so and libc.so
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"
TERMUX_PKG_DEPENDS="ndk-sysroot"

termux_step_extract_package() {
	if [ -z "${TERMUX_PKG_SRCURL:=""}" ]; then
		mkdir -p "$TERMUX_PKG_SRCDIR"
		return
	fi
	cd "$TERMUX_PKG_TMPDIR"
	local filename
	filename=$(basename "$TERMUX_PKG_SRCURL")
	local file="$TERMUX_PKG_CACHEDIR/$filename"
	termux_download "$TERMUX_PKG_SRCURL" "$file" "$TERMUX_PKG_SHA256"

	if [ "x$TERMUX_PKG_FOLDERNAME" = "x" ]; then
		folder=`basename $filename .tar.bz2` && folder=`basename $folder .tar.gz` && folder=`basename $folder .tar.xz` && folder=`basename $folder .tar.lz` && folder=`basename $folder .tgz` && folder=`basename $folder .zip`
		folder="${folder/_/-}" # dpkg uses _ in tar filename, but - in folder
	else
		folder=$TERMUX_PKG_FOLDERNAME
	fi
	rm -Rf $folder
	mkdir -p $folder
	if [ "${file##*.}" = zip ]; then
		unzip -q "$file" -d $folder
	else
		tar xf "$file"
	fi
	mv $folder "$TERMUX_PKG_SRCDIR"
}

termux_step_post_configure() {
	LDFLAGS=${LDFLAGS//-Wl,--fix-cortex-a8/}
}
