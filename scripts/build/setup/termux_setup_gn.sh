termux_setup_gn() {
	termux_setup_ninja
	local GN_COMMIT=e30a1fe26e5e72cb7cb9f27d9abe2330e4115ae5
	local GN_TARFILE=$TERMUX_COMMON_CACHEDIR/gn_$GN_COMMIT.tar.gz
	local GN_SOURCE=https://gn.googlesource.com/gn/+archive/$GN_COMMIT.tar.gz

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		GN_FOLDER=$TERMUX_SCRIPTDIR/build-tools/gn-$GN_COMMIT
	else
		GN_FOLDER=$TERMUX_COMMON_CACHEDIR/gn-$GN_COMMIT
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$GN_FOLDER" ]; then
			# FIXME: We would like to enable checksums when downloading
			# tar files, but they change each time as the tar metadata
			# differs: https://github.com/google/gitiles/issues/84
			termux_download \
				$GN_SOURCE \
				$GN_TARFILE \
				SKIP_CHECKSUM
			mkdir -p $GN_FOLDER
			tar xf $GN_TARFILE -C $GN_FOLDER
			local LAST_PWD=$(pwd)
			cd $GN_FOLDER
			(
				unset CC CXX CFLAGS CXXFLAGS LD LDFLAGS AR AS CPP OBJCOPY OBJDUMP RANLIB READELF STRIP
				./build/gen.py \
					--no-last-commit-position
				cat <<-EOF >./out/last_commit_position.h
					#ifndef OUT_LAST_COMMIT_POSITION_H_
					#define OUT_LAST_COMMIT_POSITION_H_
					#define LAST_COMMIT_POSITION_NUM 1953
					#define LAST_COMMIT_POSITION "2034 ${GN_COMMIT:0:8}"
					#endif  // OUT_LAST_COMMIT_POSITION_H_
				EOF
				ninja -C out/
			)
			cd $LAST_PWD
		fi
		export PATH=$GN_FOLDER/out:$PATH
	else
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' gn 2>/dev/null)" != "installed" ]] ||
                   [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q gn 2>/dev/null)" ]]; then
			echo "Package 'gn' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install gn"
			echo
			echo "  pacman -S gn"
			echo
			exit 1
		fi
	fi
}
