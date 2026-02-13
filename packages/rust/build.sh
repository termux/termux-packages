# Contributor: @kcotugno
TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org/
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.93.1"
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-${TERMUX_PKG_VERSION}-src.tar.xz
TERMUX_PKG_SHA256=848c9171212c998c069e6979a205a1a44fa3235a463696d62e24701c83596ce0
TERMUX_PKG_DEPENDS="clang, libandroid-execinfo, libc++, libllvm (<< $TERMUX_LLVM_NEXT_MAJOR_VERSION), lld, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="wasi-libc"
TERMUX_PKG_SUGGESTS="rust-analyzer"
TERMUX_PKG_NO_REPLACE_GUESS_SCRIPTS=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
bin/llc
bin/llvm-*
bin/opt
bin/sh
share/wasi-sysroot
"

termux_pkg_auto_update() {
	local e=0
	local api_url1="https://releases.rs"
	local api_url2="https://forge.rust-lang.org/infra/other-installation-methods.html"
	local api_url1_r=$(curl -Ls "${api_url1}")
	local api_url2_r=$(curl -Ls "${api_url2}")
	local latest_version=$(echo "${api_url1_r}" | sed -ne "s|.*Stable: \([0-9]*\+.\+[0-9]*\+.\+[0-9]*\) Beta:.*|\1|p")
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: Already up to date."
		return
	fi
	local latest_version_url=$(echo "${api_url2_r}" | grep static.rust-lang.org | sed -nE 's|.*(https.*.xz)".*|\1|p')
	if [[ -z "$(echo ${latest_version_url} | grep ${latest_version})" ]]; then
		echo -e "INFO: Not updating to ${latest_version}. Only these are available:\n${latest_version_url}"
		return
	fi
	[[ -z "${api_url1_r}" ]] && e=1
	[[ -z "${api_url2_r}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	local uptime_now=$(cat /proc/uptime)
	local uptime_s="${uptime_now//.*}"
	local uptime_h_limit=2
	local uptime_s_limit=$((uptime_h_limit*60*60))
	[[ -z "${uptime_s}" ]] && [[ "$(uname -o)" != "Android" ]] && e=1
	[[ "${uptime_s}" == 0 ]] && [[ "$(uname -o)" != "Android" ]] && e=1
	[[ "${uptime_s}" -gt "${uptime_s_limit}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url1_r=${api_url1_r}
		api_url2_r=${api_url2_r}
		latest_version=${latest_version}
		latest_version_url=${latest_version_url}
		uptime_now=${uptime_now}
		uptime_s=${uptime_s}
		uptime_s_limit=${uptime_s_limit}
		EOL
		return
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	sed \
		-e "s/^\tlocal BOOTSTRAP_VERSION=.*/\tlocal BOOTSTRAP_VERSION=${TERMUX_PKG_VERSION}/" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	# default rust-std package to be installed
	TERMUX_PKG_DEPENDS+=", rust-std-${CARGO_TARGET_NAME/_/-}"

	local p="${TERMUX_PKG_BUILDER_DIR}/0001-set-TERMUX_PKG_API_LEVEL.diff"
	echo "Applying patch: $(basename "${p}")"
	sed "s|@TERMUX_PKG_API_LEVEL@|${TERMUX_PKG_API_LEVEL}|g" "${p}" \
		| patch --silent -p1

	# assist with downstream patch methods that bulk-replace
	# string 'com.termux' throughout the repository
	local original_prefix_component_one="/data/data/com."
	local original_prefix_component_two="termux/files/usr"
	local original_prefix="${original_prefix_component_one}${original_prefix_component_two}"
	if [[ "$TERMUX_PREFIX" != "$original_prefix" ]]; then
		local patch="$TERMUX_PKG_BUILDER_DIR/force-allow-edit-vendor.diff"
		echo "Applying patch: $(basename "$patch")"
		patch --silent -p1 < "$patch"

		local crate=openssl-probe
		local crate_src_dir="$(realpath "$(find "$TERMUX_PKG_SRCDIR/vendor" -name "$crate"'*' | sort | tail -n1)")"
		local crate_dest_dir="$crate_src_dir-custom-termux-prefix"
		cp -r "$crate_src_dir" "$crate_dest_dir"

		echo "Replacing '$original_prefix' with '$TERMUX_PREFIX' in '$crate_dest_dir/src/lib.rs'"
		sed -i -e "s|$original_prefix|$TERMUX_PREFIX|g" "$crate_dest_dir/src/lib.rs"

		local dir
		for dir in "$TERMUX_PKG_SRCDIR"/{,src/tools/cargo,src/tools/miri}; do
			echo '' >> "$dir/Cargo.toml"
			echo '[patch.crates-io]' >> "$dir/Cargo.toml"
			echo "$crate = { path = \"${crate_dest_dir}\" }" >> "$dir/Cargo.toml"
		done
	fi

	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	mkdir -p $RUST_LIBDIR

	# we can't use -L$PREFIX/lib since it breaks things but we need to link against libLLVM-9.so
	ln -vfst "${RUST_LIBDIR}" \
		"${TERMUX_PREFIX}/lib/libLLVM-${TERMUX_LLVM_MAJOR_VERSION}.so"

	# https://github.com/termux/termux-packages/issues/18379
	# NDK r26 multiple ld.lld: error: undefined symbol: __cxa_*
	ln -vfst "${RUST_LIBDIR}" "${TERMUX_PREFIX}"/lib/libc++_shared.so

	# https://github.com/termux/termux-packages/issues/11640
	# https://github.com/termux/termux-packages/issues/11658
	# The build system somehow tries to link binaries against a wrong libc,
	# leading to build failures for arm and runtime errors for others.
	# The following command is equivalent to
	#	ln -vfst $RUST_LIBDIR \
	#		$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/lib{c,dl}.so
	# but written in a future-proof manner.
	ln -vfst $RUST_LIBDIR $(echo | $CC -x c - -Wl,-t -shared | grep '\.so$')

	ln -vfst "${RUST_LIBDIR}" "${TERMUX_PREFIX}"/lib/libandroid-execinfo.so
}

termux_step_configure() {
	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	# this is about to get ugly but i have to make sure a rustc in a proper bin lib
	# configuration is used otherwise it fails a long time into the build...
	# like 30 to 40 + minutes ... so lets get it right

	# upstream tests build using versions N and N-1
	local BOOTSTRAP_VERSION=1.93.0
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		if ! rustup install "${BOOTSTRAP_VERSION}"; then
			echo "WARN: ${BOOTSTRAP_VERSION} is unavailable, fallback to stable version!"
			BOOTSTRAP_VERSION=stable
			rustup install "${BOOTSTRAP_VERSION}"
		fi
		rustup default "${BOOTSTRAP_VERSION}-x86_64-unknown-linux-gnu"
		export PATH="${HOME}/.rustup/toolchains/${BOOTSTRAP_VERSION}-x86_64-unknown-linux-gnu/bin:${PATH}"
	fi
	local RUSTC=$(command -v rustc)
	local CARGO=$(command -v cargo)

	# rust 1.89.0
	export WASI_SDK_PATH="${TERMUX_PKG_TMPDIR}/wasi-sdk"
	rm -fr "${WASI_SDK_PATH}"
	mkdir -p "${WASI_SDK_PATH}"/{bin,share}
	ln -fsv "${TERMUX_PREFIX}/share/wasi-sysroot" "${WASI_SDK_PATH}/share/wasi-sysroot"
	local clang
	for clang in wasm32-wasip{1,2,3}-clang{,++}; do
		ln -fsv "$(command -v clang)" "${WASI_SDK_PATH}/bin/${clang}"
	done

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		local dir="${TERMUX_STANDALONE_TOOLCHAIN}/toolchains/llvm/prebuilt/linux-x86_64/bin"
		mkdir -p "${dir}"
		local target clang
		for target in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android; do
			for clang in clang clang++; do
				ln -fsv "${TERMUX_PREFIX}/bin/clang" "${dir}/${target}${TERMUX_PKG_API_LEVEL}-${clang}"
			done
		done
	fi

	sed \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@TERMUX_STANDALONE_TOOLCHAIN@|${TERMUX_STANDALONE_TOOLCHAIN}|g" \
		-e "s|@TERMUX_HOST_LLVM_BASE_DIR@|${TERMUX_HOST_LLVM_BASE_DIR}|g" \
		-e "s|@CARGO_TARGET_NAME@|${CARGO_TARGET_NAME}|g" \
		-e "s|@RUSTC@|${RUSTC}|g" \
		-e "s|@CARGO@|${CARGO}|g" \
		"${TERMUX_PKG_BUILDER_DIR}"/bootstrap.toml > bootstrap.toml

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export ${env_host}_OPENSSL_DIR=$TERMUX_PREFIX
	export RUST_LIBDIR=$TERMUX_PKG_BUILDDIR/_lib
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L${RUST_LIBDIR}"

	# x86_64: __lttf2
	case "${TERMUX_ARCH}" in
	x86_64)
		export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=$(${CC} -print-libgcc-file-name)" ;;
	esac

	# NDK r26
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-lc++_shared"

	# rust 1.79.0
	# note: ld.lld: error: undefined reference due to --no-allow-shlib-undefined: syncfs
	"${CC}" ${CPPFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/syncfs.c"
	"${AR}" rcu "${RUST_LIBDIR}/libsyncfs.a" syncfs.o
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-l:libsyncfs.a"

	# rust 1.87.0
	# note: ld.lld: error: undefined reference due to --no-allow-shlib-undefined: backtrace
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-landroid-execinfo"

	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-Wl,-rpath=${TERMUX_PREFIX}/lib -C link-arg=-Wl,--enable-new-dtags"

	unset CC CFLAGS CFLAGS_${env_host} CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG RANLIB

	# Needed by wasm32-wasip2
	cargo install wasm-component-ld
}

termux_step_make() {
	:
}

termux_step_make_install() {
	# install causes on device build fail to continue
	# dist uses a lot of spaces on CI
	local job="install"
	[[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]] && job="dist"

	# rust 1.87.0
	# https://github.com/termux/termux-packages/issues/25360
	# build to stage 2 to fix rust-analyzer error
	"${TERMUX_PKG_SRCDIR}/x.py" "${job}" -j "${TERMUX_PKG_MAKE_PROCESSES}" --stage 2

	# wasm32* not added into bootstrap.toml
	# due to CI and on device build error:
	# error: could not document `std`
	"${TERMUX_PKG_SRCDIR}/x.py" install -j "${TERMUX_PKG_MAKE_PROCESSES}" --target wasm32-unknown-unknown --stage 2 std
	[[ ! -e "${TERMUX_PREFIX}/share/wasi-sysroot" ]] && termux_error_exit "wasi-sysroot not found"
	"${TERMUX_PKG_SRCDIR}/x.py" install -j "${TERMUX_PKG_MAKE_PROCESSES}" --target wasm32-wasip1 --stage 2 std
	"${TERMUX_PKG_SRCDIR}/x.py" install -j "${TERMUX_PKG_MAKE_PROCESSES}" --target wasm32-wasip2 --stage 2 std
	"${TERMUX_PKG_SRCDIR}/x.py" install -j "${TERMUX_PKG_MAKE_PROCESSES}" --target wasm32-wasip3 --stage 2 std

	"${TERMUX_PKG_SRCDIR}/x.py" dist -j "${TERMUX_PKG_MAKE_PROCESSES}" --stage 2 rustc-dev

	# remove version suffix: beta, nightly
	local VERSION=${TERMUX_PKG_VERSION//~*}

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		echo "WARN: Replacing on device rust! Caveat emptor!"
		rm -fr ${TERMUX_PREFIX}/lib/rustlib/${CARGO_TARGET_NAME}
		rm -fv $(find ${TERMUX_PREFIX}/lib -maxdepth 1 -type l -exec ls -l "{}" \; | grep rustlib | sed -e "s|.* ${TERMUX_PREFIX}/lib|${TERMUX_PREFIX}/lib|" -e "s| -> .*||")
	fi
	ls build/dist/*-${VERSION}*.tar.gz | xargs -P${TERMUX_PKG_MAKE_PROCESSES} -n1 -t -r tar -xf
	local tgz
	for tgz in $(ls build/dist/*-${VERSION}*.tar.gz); do
		echo "INFO: ${tgz}"
		./$(basename "${tgz}" | sed -e "s|.tar.gz$||")/install.sh --prefix=${TERMUX_PREFIX}
	done

	cd "$TERMUX_PREFIX/lib"
	rm -fv libc.so libdl.so

	ln -vfs rustlib/${CARGO_TARGET_NAME}/lib/*.so .
	ln -vfs lld ${TERMUX_PREFIX}/bin/rust-lld

	cd "$TERMUX_PREFIX/lib/rustlib"
	rm -fr \
		components \
		install.log \
		uninstall.sh \
		rust-installer-version \
		manifest-* \
		x86_64-unknown-linux-gnu

	cd "${TERMUX_PREFIX}/lib/rustlib/${CARGO_TARGET_NAME}/lib"
	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"
	ls *.rlib | tee "${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"

	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"
	ls *.so | tee "${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"

	echo "INFO: ${TERMUX_PKG_BUILDDIR}/rustc-dev-${VERSION}-${CARGO_TARGET_NAME}/rustc-dev/manifest.in"
	cat "${TERMUX_PKG_BUILDDIR}/rustc-dev-${VERSION}-${CARGO_TARGET_NAME}/rustc-dev/manifest.in" | tee "${TERMUX_PKG_BUILDDIR}/manifest.in"

	sed -e 's/^.....//' -i "${TERMUX_PKG_BUILDDIR}/manifest.in"
	local _included=$(cat "${TERMUX_PKG_BUILDDIR}/manifest.in")
	local _included_rlib=$(echo "${_included}" | grep '\.rlib$')
	local _included_so=$(echo "${_included}" | grep '\.so$')
	local _included=$(echo "${_included}" | grep -v "/rustc-src/")
	local _included=$(echo "${_included}" | grep -v '\.rlib$')
	local _included=$(echo "${_included}" | grep -v '\.so$')

	echo "INFO: _rlib"
	while IFS= read -r _rlib; do
		echo "${_rlib}"
		local _included_rlib=$(echo "${_included_rlib}" | grep -v "${_rlib}")
	done < "${TERMUX_PKG_BUILDDIR}/rustlib-rlib.txt"
	echo "INFO: _so"
	while IFS= read -r _so; do
		echo "${_so}"
		local _included_so=$(echo "${_included_so}" | grep -v "${_so}")
	done < "${TERMUX_PKG_BUILDDIR}/rustlib-so.txt"

	export _INCLUDED=$(echo -e "${_included}\n${_included_rlib}\n${_included_so}")
	echo -e "INFO: _INCLUDED:\n${_INCLUDED}"

	# check runpath entry
	local cargo_readelf=$(${READELF} -d ${TERMUX_PREFIX}/bin/cargo)
	local cargo_runpath=$(echo "${cargo_readelf}" | sed -ne "s|.*RUNPATH.*\[\(.*\)\].*|\1|p")
	if [[ "${cargo_runpath}" != "${TERMUX_PREFIX}/lib" ]]; then
		termux_error_exit "
		Mismatch RUNPATH found. Check readelf output below:
		${cargo_readelf}
		"
	fi
}

# References:
# https://src.fedoraproject.org/rpms/rust/blob/rawhide/f/rust.spec
# https://gitlab.archlinux.org/archlinux/packaging/packages/rust/-/blob/main/PKGBUILD
