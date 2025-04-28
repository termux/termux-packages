TERMUX_PKG_HOMEPAGE=https://pypy.org
TERMUX_PKG_DESCRIPTION="A fast, compliant alternative implementation of Python 3"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
_MAJOR_VERSION=3.11
TERMUX_PKG_VERSION="7.3.19"
TERMUX_PKG_SRCURL=https://downloads.python.org/pypy/pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION-src.tar.bz2
TERMUX_PKG_SHA256=4817c044bb469a3274e60aa3645770f81eb4f9166ea7fdc4e6c351345554c8d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdbm, libandroid-posix-semaphore, libandroid-support, libbz2, libcrypt, libexpat, libffi, liblzma, libsqlite, ncurses, ncurses-ui-libs, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, python2, tk, xorgproto"
TERMUX_PKG_RECOMMENDS="clang, make, pkg-config"
TERMUX_PKG_SUGGESTS="pypy3-tkinter"
TERMUX_PKG_BUILD_IN_SRC=true
# remove files generated as a result of running python2 inside proot
TERMUX_PKG_RM_AFTER_INSTALL="
bin/easy_install-2*
bin/pip2*
lib/python2*
"

install_package_from_root_repo() {
	# based on the implementations of read_package_lists and pull_package in
	# https://github.com/termux/termux-packages/blob/7a95ee9c2d0ee05e370d1cf951d9f75b4aef8677/scripts/generate-bootstraps.sh

	local package_to_download_name=$1
	local ROOTFS=$2
	declare -A PACKAGE_METADATA
	declare -A PACKAGE_URLS
	declare -A REPO_BASE_URLS=(
		["root"]="https://packages-cf.termux.dev/apt/termux-root/dists/root/stable"
	)
	local PKGDIR="${TERMUX_PKG_CACHEDIR}/packages-${TERMUX_ARCH}"
	local package_tmpdir="${PKGDIR}/${package_to_download_name}"
	mkdir -p "$package_tmpdir"

	local architecture
	for architecture in all "$TERMUX_ARCH"; do
		for repository in "${!REPO_BASE_URLS[@]}"; do
			REPO_BASE_URL="${REPO_BASE_URLS[${repository}]}"
			if [ ! -e "${TERMUX_PKG_TMPDIR}/${repository}-packages.${architecture}" ]; then
				echo "[*] Downloading ${repository} package list for architecture '${architecture}'..."
				if ! curl --fail --location \
					--output "${TERMUX_PKG_TMPDIR}/${repository}-packages.${architecture}" \
					"${REPO_BASE_URL}/binary-${architecture}/Packages"; then
					if [ "$architecture" = "all" ]; then
						echo "[!] Skipping architecture-independent package list as not available..."
						continue
					fi
				fi
				echo >> "${TERMUX_PKG_TMPDIR}/${repository}-packages.${architecture}"
			fi

			echo "[*] Reading ${repository} package list for '${architecture}'..."
			while read -r -d $'\xFF' package; do
				if [ -n "$package" ]; then
					local package_name
					package_name=$(echo "$package" | grep -i "^Package:" | awk '{ print $2 }')
					package_url="$(dirname "$(dirname "$(dirname "${REPO_BASE_URL}")")")"/"$(echo "${package}" | \
						grep -i "^Filename:" | awk '{ print $2 }')"

					if [ -z "${PACKAGE_METADATA["$package_name"]-}" ]; then
						PACKAGE_METADATA["$package_name"]="$package"
						PACKAGE_URLS["$package_name"]="$package_url"
					else
						local prev_package_ver cur_package_ver
						cur_package_ver=$(echo "$package" | grep -i "^Version:" | awk '{ print $2 }')
						prev_package_ver=$(echo "${PACKAGE_METADATA["$package_name"]}" | grep -i "^Version:" | awk '{ print $2 }')

						# If package has multiple versions, make sure that our metadata
						# contains the latest one.
						if [ "$(echo -e "${prev_package_ver}\n${cur_package_ver}" | sort -rV | head -n1)" = "${cur_package_ver}" ]; then
							PACKAGE_METADATA["$package_name"]="$package"
							PACKAGE_URLS["$package_name"]="$package_url"
						fi
					fi
				fi
			done < <(sed -e "s/^$/\xFF/g" "${TERMUX_PKG_TMPDIR}/${repository}-packages.${architecture}")
		done
	done
	local package_to_download_url="${PACKAGE_URLS[${package_to_download_name}]}"

	# (dependencies skipped in this case because dnsmasq has no dependencies)

	echo "[*] Downloading '$package_to_download_name'..."
	termux_download "$package_to_download_url" "$package_tmpdir/package.deb" SKIP_CHECKSUM

	echo "[*] Extracting '$package_to_download_name'..."
	(
		cd "$package_tmpdir"
		ar x package.deb

		# data.tar may have extension different from .xz
		if [ -f "./data.tar.xz" ]; then
			data_archive="data.tar.xz"
		elif [ -f "./data.tar.gz" ]; then
			data_archive="data.tar.gz"
		else
			termux_error_exit "No data.tar.* found in '$package_to_download_name'."
		fi

		# Extract files
		# (in this case stripping all 6 leading components /data/data/com.termux/files/usr)
		tar xf "$data_archive" --strip-components=6 -C "$ROOTFS"
	)
}

termux_step_post_get_source() {
	local p="$TERMUX_PKG_BUILDER_DIR/9998-link-against-pypy3-on-testcapi.diff"
	echo "Applying $(basename "${p}")"
	sed 's|@TERMUX_PYPY_MAJOR_VERSION@|'"${_MAJOR_VERSION}"'|g' "${p}" \
		| patch --silent -p1

	p="$TERMUX_PKG_BUILDER_DIR/9999-add-ANDROID_API_LEVEL-for-sysconfigdata.diff"
	echo "Applying $(basename "${p}")"
	sed 's|@TERMUX_PKG_API_LEVEL@|'"${TERMUX_PKG_API_LEVEL}"'|g' "${p}" \
		| patch --silent -p1
}

__setup_termux_envs() {
	__pypy3_run_on_target_from_builder=""
	# translation step only reads CFLAGS from environment,
	# not CPPFLAGS, so combine them
	export CFLAGS+=" $CPPFLAGS"
	export CFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD=1"
	export MAKEFLAGS="-j$TERMUX_PKG_MAKE_PROCESSES"
	export PYPY_MULTIARCH="$TERMUX_HOST_PLATFORM"
	export PYPY_USESSION_DIR="$TERMUX_PKG_SRCDIR/usession-dir"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	__pypy3_run_on_target_from_builder="__pypy3_termux_proot_run"

	mkdir -p "$PYPY_USESSION_DIR"

	if [[ ! -d "$TERMUX_PKG_CACHEDIR/proot-additions" ]]; then
		mkdir -p "$TERMUX_PKG_CACHEDIR/proot-additions/bin"
		ln -sf $(command -v llvm-strip) "$TERMUX_PKG_CACHEDIR/proot-additions/bin/strip"
		# dnsmasq cannot be in TERMUX_PKG_BUILD_DEPENDS because it is in the root-packages folder,
		# so it would cause the test-buildorder-random CI check to fail if there.
		install_package_from_root_repo dnsmasq "$TERMUX_PKG_CACHEDIR/proot-additions"
	fi

	export PATH="$TERMUX_PKG_CACHEDIR/proot-additions/bin:$PATH"

	termux_setup_proot
}

__pypy3_termux_proot_run() {
	termux-proot-run env \
		LD_PRELOAD= \
		LD_LIBRARY_PATH="${LD_LIBRARY_PATH-}" \
		PREFIX="$TERMUX_PREFIX" \
		CC="$CC" \
		CFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS" \
		MAKEFLAGS="$MAKEFLAGS" \
		PYTHONPATH="${PYTHONPATH-}" \
		PYPY_MULTIARCH="$PYPY_MULTIARCH" \
		PYPY_USESSION_DIR="$PYPY_USESSION_DIR" \
		"$@"
}

termux_step_configure() {
	__setup_termux_envs

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		# spin up dnsmasq to use for downloading cffi
		$__pypy3_run_on_target_from_builder \
			dnsmasq --pid-file="$TERMUX_PKG_TMPDIR/dnsmasq.pid" &
		$__pypy3_run_on_target_from_builder \
			python2 -m ensurepip --upgrade --no-default-pip
	fi

	$__pypy3_run_on_target_from_builder \
		pip2 install cffi

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		kill -9 $(cat "$TERMUX_PKG_TMPDIR/dnsmasq.pid")
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 sed -i \
		-e "s|'gcc'|'${CC}'|g" -e "s|\"gcc\"|\"${CC}\"|g"
}

termux_step_make() {
	pushd "$TERMUX_PKG_SRCDIR/pypy/goal"

	$__pypy3_run_on_target_from_builder \
		python2 -u "$TERMUX_PKG_SRCDIR/rpython/bin/rpython" --opt=jit

	export PYTHONPATH="$TERMUX_PKG_SRCDIR"
	# prevents ImportError: dlopen failed: library "libpypy3.11-c.so" not found
	# (goes with 9998-link-against-pypy3-on-testcapi.diff)
	export LD_LIBRARY_PATH="$TERMUX_PKG_SRCDIR/pypy/goal"
	export LDFLAGS+=" -L$TERMUX_PKG_SRCDIR/pypy/goal"

	$__pypy3_run_on_target_from_builder \
		"$(pwd)/pypy$_MAJOR_VERSION-c" \
			"$TERMUX_PKG_SRCDIR/pypy/tool/release/package.py" \
			--archive-name="pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION" \
			--targetdir="$TERMUX_PKG_SRCDIR" \
			--no-embedded-dependencies \
			--no-keep-debug
	popd
}

termux_step_make_install() {
	local installdir="$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME"
	rm -rf "$installdir"
	mkdir -p "$installdir"
	tar xf "pypy$_MAJOR_VERSION-v$TERMUX_PKG_VERSION.tar.bz2" --strip-components=1 -C "$installdir"
	ln -sfr "$installdir/bin/$TERMUX_PKG_NAME" "$TERMUX_PREFIX/bin/"
	ln -sfr "$installdir/bin/lib$TERMUX_PKG_NAME-c.so" "$TERMUX_PREFIX/lib/"
}

termux_step_create_debscripts() {
	# postinst script to clean up runtime-generated files of previous pypy3 versions that
	# do not match the current $_MAJOR_VERSION
	# (this one needs to have bash in the shebang, not sh, because of the use of a special
	# wildcard feature that does not work if the shebang is sh [which, in Termux, is bash in sh mode])
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash

	echo "Deleting files from other versions of $TERMUX_PKG_NAME..."
	rm -Rf $TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/lib/pypy*[^$_MAJOR_VERSION]

	exit 0
	POSTINST_EOF

	# Pre-rm script to cleanup runtime-generated files.
	cat <<- PRERM_EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh

	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ] && [ "\$1" != "remove" ]; then
	    exit 0
	fi

	echo "Deleting files from site-packages..."
	rm -Rf $TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/lib/pypy$_MAJOR_VERSION/site-packages/*

	echo "Deleting *.pyc..."
	find $TERMUX_PREFIX/opt/$TERMUX_PKG_NAME/lib/ | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

	exit 0
	PRERM_EOF

	chmod 0755 postinst prerm
}
