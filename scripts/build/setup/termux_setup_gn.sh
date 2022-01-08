termux_setup_gn() {
	termux_setup_ninja
	local GN_COMMIT=e0afadf7a743d5b14737bd454df45d5f1caf0d23
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
					#define LAST_COMMIT_POSITION "1953 ${GN_COMMIT:0:8}"
					#endif  // OUT_LAST_COMMIT_POSITION_H_
				EOF
				ninja -C out/
			)
			cd $LAST_PWD
		fi
		export PATH=$GN_FOLDER/out:$PATH
	else
		if [[ "$(dpkg --version 2>/dev/null)" && "$(dpkg-query -W -f '${db:Status-Status}\n' gn 2>/dev/null)" != "installed" ]] ||
                   [[ "$(pacman -V 2>/dev/null)" && ! "$(pacman -Q gn 2>/dev/null)" ]]; then
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
