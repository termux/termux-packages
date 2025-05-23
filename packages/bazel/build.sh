TERMUX_PKG_HOMEPAGE=https://bazel.build/
TERMUX_PKG_DESCRIPTION="Correct, reproducible, and fast builds for everyone"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="7.6.1"
TERMUX_PKG_SRCURL=https://github.com/bazelbuild/bazel/releases/download/$TERMUX_PKG_VERSION/bazel-$TERMUX_PKG_VERSION-dist.zip
TERMUX_PKG_SHA256=c1106db93eb8a719a6e2e1e9327f41b003b6d7f7e9d04f206057990775a7760e
TERMUX_PKG_DEPENDS="libarchive, openjdk-21, patch, unzip, zip"
TERMUX_PKG_BUILD_DEPENDS="libandroid-spawn-static, patch, unzip, zip"
TERMUX_PKG_ANTI_BUILD_DEPENDS="openjdk-21"
TERMUX_PKG_BREAKS="openjdk-11, openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_NO_STRIP=true
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

__sed_verbose() {
	local path=$1; shift;
	sed --follow-symlinks -i".bak-nix" "$@" "$path"
	diff -U0 "$path.bak-nix" "$path" | sed "s/^/  /" || true
	rm -f "$path.bak-nix"
}

__fix_harcoded_paths() {
	# Ref: https://github.com/NixOS/nixpkgs/blob/release-23.11/pkgs/development/tools/build-managers/bazel/bazel_7/default.nix

	# Unzip builtins_bzl.zip so the contents get patched
	local builtins_bzl=src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl
	unzip ${builtins_bzl}.zip -d ${builtins_bzl}_zip >/dev/null
	rm ${builtins_bzl}.zip
	builtins_bzl=''${builtins_bzl}_zip/builtins_bzl

	echo
	echo "Substituting */bin/* hardcoded paths in src/main/java/com/google/devtools"
	# Prefilter the files with grep for speed
	grep -rlZ /bin/ \
		src/main/java/com/google/devtools \
		src/main/starlark/builtins_bzl/common/python \
		tools \
	| while IFS="" read -r -d "" path; do
		# If you add more replacements here, you must change the grep above!
		# Only files containing /bin are taken into account.
		__sed_verbose "$path" \
			-e "s!/usr/local/bin/bash!${TERMUX_PREFIX}/bin/bash!g" \
			-e "s!/usr/bin/bash!${TERMUX_PREFIX}/bin/bash!g" \
			-e "s!/bin/bash!${TERMUX_PREFIX}/bin/bash!g" \
			-e "s!/usr/bin/env bash!${TERMUX_PREFIX}/bin/bash!g" \
			-e "s!/usr/bin/env python2!${TERMUX_PREFIX}/bin/python!g" \
			-e "s!/usr/bin/env python!${TERMUX_PREFIX}/bin/python!g" \
			-e "s!/usr/bin/env!${TERMUX_PREFIX}/bin/env!g" \
			-e "s!/bin/true!${TERMUX_PREFIX}/bin/true!g"
	done

	# Fixup scripts that generate scripts. Not fixed up by patchShebangs below.
	__sed_verbose scripts/bootstrap/compile.sh \
		-e "s!/bin/bash!${TERMUX_PREFIX}/bin/bash!g"

	# reconstruct the now patched builtins_bzl.zip
	pushd src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip &>/dev/null
		zip ../builtins_bzl.zip $(find builtins_bzl -type f) >/dev/null
		rm -rf builtins_bzl
	popd &>/dev/null
	rmdir src/main/java/com/google/devtools/build/lib/bazel/rules/builtins_bzl_zip
}

__setup_bazelisk() {
	local TERMUX_BAZELISK_VERSION=1.26.0
	local TERMUX_BAZELISK_SHA256=6539c12842ad76966f3d493e8f80d67caa84ec4a000e220d5459833c967c12bc
	local TERMUX_BAZELISK_URL="https://github.com/bazelbuild/bazelisk/releases/download/v$TERMUX_BAZELISK_VERSION/bazelisk-linux-amd64"
	local TERMUX_BAZELISK_FOLDER="${TERMUX_COMMON_CACHEDIR}/bazelisk-${TERMUX_BAZELISK_VERSION}"
	local TERMUX_BAZELISK_FILE="${TERMUX_BAZELISK_FOLDER}/bazelisk"

	mkdir -p "${TERMUX_BAZELISK_FOLDER}"
	if [ ! -e "${TERMUX_BAZELISK_FILE}" ]; then
		termux_download "${TERMUX_BAZELISK_URL}" \
			"${TERMUX_BAZELISK_FILE}"-tmp \
			"${TERMUX_BAZELISK_SHA256}"
		chmod +x "${TERMUX_BAZELISK_FILE}"-tmp
		mv "${TERMUX_BAZELISK_FILE}"-tmp "${TERMUX_BAZELISK_FILE}"
	fi

	export PATH="${TERMUX_BAZELISK_FOLDER}:${PATH}"
	export BAZELISK_HOME="${TERMUX_BAZELISK_FOLDER}/bazelisk-home"
}

termux_step_get_source() {
	local f="$(basename "${TERMUX_PKG_SRCURL}")"
	termux_download \
		"${TERMUX_PKG_SRCURL}" \
		"$TERMUX_PKG_CACHEDIR/${f}" \
		"${TERMUX_PKG_SHA256}"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	unzip -d "$TERMUX_PKG_SRCDIR" "$TERMUX_PKG_CACHEDIR/${f}" > /dev/null
}

termux_step_post_get_source() {
	# Fix hardcoded paths
	__fix_harcoded_paths

	# Copy patches
	rm -rf third_party/termux-patches/
	mkdir -p third_party/termux-patches/
	cp -Rfv $TERMUX_PKG_BUILDER_DIR/dep-patches/* third_party/termux-patches/
}

termux_step_configure() {
	# Setup bazelisk
	__setup_bazelisk
	export USE_BAZEL_VERSION="$TERMUX_PKG_VERSION"

	# Copy toolchain to tmp
	rm -rf $TERMUX_PREFIX/tmp/custom-toolchain
	mkdir -p $TERMUX_PREFIX/tmp/custom-toolchain
	cp -Rf $TERMUX_STANDALONE_TOOLCHAIN/* $TERMUX_PREFIX/tmp/custom-toolchain/
	# Bazel's glob doesn't support nested symlink
	rm -rf $TERMUX_PREFIX/tmp/custom-toolchain/toolchains

	# Copy cross files
	rm -rf termux-cross/
	mkdir -p termux-cross/
	cp -Rfv $TERMUX_PKG_BUILDER_DIR/termux-cross/* termux-cross/

	# Instantiate termux-cross template
	mv termux-cross/toolchain/template termux-cross/toolchain/$TERMUX_ARCH
	local _file
	for _file in $AR $CC $CXX $LD $NM $OBJDUMP $STRIP; do
		ln -sf wrapper.sh termux-cross/toolchain/$TERMUX_ARCH/bin/$(basename $_file)
	done
	for _file in termux-cross/toolchain/$TERMUX_ARCH/{BUILD,cc_toolchain_config.bzl}; do
		sed -i "s|@TERMUX_ARCH@|$TERMUX_ARCH|g
				s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g
				s|@AR@|$(basename $AR)|g
				s|@CC@|$(basename $CC)|g
				s|@CPP@|$(basename $CPP)|g
				s|@CXX@|$(basename $CXX)|g
				s|@LD@|$(basename $LD)|g
				s|@NM@|$(basename $NM)|g
				s|@OBJDUMP@|$(basename $OBJDUMP)|g
				s|@STRIP@|$(basename $STRIP)|g" $_file
	done

	# Add elf-cleaner to PATH
	mkdir -p $TERMUX_PKG_TMPDIR/elf-cleaner-bin
	ln -sf $(command -v $TERMUX_ELF_CLEANER) $TERMUX_PKG_TMPDIR/elf-cleaner-bin/
	export PATH="$TERMUX_PKG_TMPDIR/elf-cleaner-bin:$PATH"
}

termux_step_make() {
	(set +e +u
	unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
	export XDG_CACHE_HOME="$TERMUX_PKG_TMPDIR/fake-xdg-cache-home"
	bazelisk build \
		--extra_toolchains=//termux-cross/toolchain/$TERMUX_ARCH:${TERMUX_ARCH}_linux_toolchain \
		--host_crosstool_top=@bazel_tools//tools/cpp:toolchain \
		--crosstool_top=//termux-cross/toolchain/${TERMUX_ARCH}:gcc_toolchain \
		--host_platform=@platforms//host \
		--platforms=//termux-cross/platforms:termux_${TERMUX_ARCH} --cpu=${TERMUX_ARCH} \
		--enable_bzlmod --verbose_failures \
			//src:bazel_nojdk
	bazelisk shutdown) || (set +e +u
		bazelisk shutdown
		termux_error_exit "ERROR: \`bazelisk build\` failed."
	)
}

termux_step_make_install() {
	install -Dm700 ./scripts/packages/bazel.sh $TERMUX_PREFIX/bin/bazel
	install -Dm700 ./bazel-bin/src/bazel_nojdk $TERMUX_PREFIX/bin/bazel-real
}
