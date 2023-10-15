TERMUX_PKG_HOMEPAGE=https://rizin.re
TERMUX_PKG_DESCRIPTION="UNIX-like reverse engineering framework and command-line toolset"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=v0.6.2
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

# Get the Android architecture
ARCH=$(getprop ro.product.cpu.abi)

# Set the appropriate source URL based on the architecture
if [ "$ARCH" == "arm64-v8a" ]; then
    TERMUX_PKG_SRCURL=https://github.com/rizinorg/rizin/releases/download/$TERMUX_PKG_VERSION/rizin-$TERMUX_PKG_VERSION-android-aarch64.tar.gz
    TERMUX_PKG_SHA256=3a9c924031e0e0f3923b8adbe3e833a7dffb2d87a0fabadcf49504a2770a67f5
elif [ "$ARCH" == "armeabi-v7a" ]; then
    TERMUX_PKG_SRCURL=https://github.com/rizinorg/rizin/releases/download/$TERMUX_PKG_VERSION/rizin-$TERMUX_PKG_VERSION-android-arm.tar.gz
    TERMUX_PKG_SHA256=cc3c2943dde9e05b1b308402999f484cb71f23107407d2263712e4d66785256a
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# The original "termux_extract_src_archive" always strips the first components
# but the source of 7zip is directly under the root directory of the tar file

termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$file" -C "$TERMUX_PKG_SRCDIR"
	cp -r "$TERMUX_PKG_SRCDIR/data/data/org.rizinorg.rizininstaller/bin/" "/data/data/com.termux/files/usr/"
	cp -r "$TERMUX_PKG_SRCDIR/data/data/org.rizinorg.rizininstaller/share/" "/data/data/com.termux/files/usr/"
	/data/data/com.termux/files/usr/bin/find "/data/data/com.termux/files/usr/bin/bin/" -type f -name 'rz-*' -exec /data/data/com.termux/files/usr/bin/chmod +x {} \;
	/data/data/com.termux/files/usr/bin/find "/data/data/com.termux/files/usr/bin/bin/" -type f -name 'rizin' -exec /data/data/com.termux/files/usr/bin/chmod +x {} \;
}