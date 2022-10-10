TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_VERSION="1.3-20220728"
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/dialog-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=54418973d559a461b00695fafe68df62f2bc73d506b436821d77ca3df454190b
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncursesw --enable-widec --with-pkg-config"
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	# This does health check on SRCURL and tries auto update if SRCURL is dead
	local output_file curl_response file_checksum new_pkg_version
	output_file=$(basename "$TERMUX_PKG_SRCURL")
	curl_response=$(curl -s -w '%{response_code}\n' -o "$output_file" "$TERMUX_PKG_SRCURL")
	if [ "$curl_response" = 200 ]; then
		file_checksum=$(sha256sum $output_file | cut -d' ' -f1)
		rm -f "$output_file"
		if [ "$file_checksum" = "$TERMUX_PKG_SHA256" ]; then
			echo "INFO: No update needed. Already at version '$TERMUX_PKG_VERSION'."
			return 0
		else
			echo -e "ERROR: Wrong checksum for $output_file\nExpected: $TERMUX_PKG_SHA256\nActual:   $file_checksum" >&2
			return 1
		fi
	fi
	echo "INFO: Getting response code: $curl_response. Attempting to auto update..."
	new_pkg_version=$(grep "<B>" "$output_file" | sed -e "s|.*<B>\(.*\)</B>.*|\1|" -e "/linux\/misc/d" -e "s|dialog-\(.*\).tgz|\1|")
	if [ -z "$new_pkg_version" ]; then
		echo "ERROR: Failed to parse html for new version. Printing '$output_file'..." >&2
		cat "$output_file" >&2
		rm -f "$output_file"
		return 1
	fi
	rm -f "$output_file"
	termux_pkg_upgrade_version "$new_pkg_version"
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Put a temporary link for libtinfo.so
	ln -s -f $TERMUX_PREFIX/lib/libncursesw.so $TERMUX_PREFIX/lib/libtinfo.so
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/libtinfo.so
}
