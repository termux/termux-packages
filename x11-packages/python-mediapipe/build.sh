TERMUX_PKG_HOMEPAGE=https://ai.google.dev/edge/mediapipe
TERMUX_PKG_DESCRIPTION="Cross-platform, customizable ML solutions for live and streaming media"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.3"
TERMUX_PKG_SRCURL=https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f61f5e5f1cd291489d20410e83f635e02066e2adf7e2a68e062d0e3c2d5316b5
TERMUX_PKG_DEPENDS="libc++, opencv, python, python-numpy, python-pip"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, setuptools, build, packaging"
TERMUX_PKG_PYTHON_TARGET_DEPS="absl-py, attrs, flatbuffers, protobuf"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/python*/site-packages/mediapipe/tasks/python/test
"

__setup_bazelisk() {
	local TERMUX_BAZELISK_VERSION=1.26.0
	local TERMUX_BAZELISK_SHA256=6539c12842ad76966f3d493e8f80d67caa84ec4a000e220d5459833c967c12bc
	local TERMUX_BAZELISK_URL="https://github.com/bazelbuild/bazelisk/releases/download/v${TERMUX_BAZELISK_VERSION}/bazelisk-linux-amd64"
	local TERMUX_BAZELISK_FOLDER="${TERMUX_COMMON_CACHEDIR}/bazelisk-${TERMUX_BAZELISK_VERSION}"
	local TERMUX_BAZELISK_FILE="${TERMUX_BAZELISK_FOLDER}/bazelisk"

	mkdir -p "${TERMUX_BAZELISK_FOLDER}"
	if [ ! -e "${TERMUX_BAZELISK_FILE}" ]; then
		termux_download "${TERMUX_BAZELISK_URL}" \
			"${TERMUX_BAZELISK_FILE}-tmp" \
			"${TERMUX_BAZELISK_SHA256}"
		chmod +x "${TERMUX_BAZELISK_FILE}-tmp"
		mv "${TERMUX_BAZELISK_FILE}-tmp" "${TERMUX_BAZELISK_FILE}"
	fi

	export PATH="${TERMUX_BAZELISK_FOLDER}:${PATH}"
	export BAZELISK_HOME="${TERMUX_BAZELISK_FOLDER}/bazelisk-home"
}

termux_step_pre_configure() {
	sed -i "s|__version__ = 'dev'|__version__ = '${TERMUX_PKG_VERSION}'|g" setup.py
}

termux_step_configure() {
	mkdir -p "$TERMUX_PKG_TMPDIR/bin" "$TERMUX_COMMON_CACHEDIR/bazel-repo-cache"
	export PATH="$TERMUX_PKG_TMPDIR/bin:$PATH"
	export XDG_CACHE_HOME="$TERMUX_PKG_TMPDIR/fake-xdg-cache-home"
	export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"

	local _py3
	_py3="$(command -v python3)"

	printf '\n' >> "$TERMUX_PKG_SRCDIR/.bazelrc"
	cat <<- EOF >> "$TERMUX_PKG_SRCDIR/.bazelrc"
		build --repository_cache=$TERMUX_COMMON_CACHEDIR/bazel-repo-cache
		build --http_timeout_scaling=4.0
		build --action_env=PATH
		build --action_env=PYTHON_BIN_PATH=$_py3
		build --repo_env=PYTHON_BIN_PATH=$_py3
		build --host_action_env=PATH
		build --copt=-D__TERMUX__
		build --copt=-DLITERT_DISABLE_OPENGL_SUPPORT
	EOF

	local _real_bazel
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		_real_bazel="$(command -v bazel7 || command -v bazel)"
		cat <<- EOF >> "$TERMUX_PKG_SRCDIR/.bazelrc"
			build --extra_toolchains=@rules_python_bzlmod//python/runtime_env_toolchains:all
			build --repo_env=CC=$(command -v clang)
			build --repo_env=CXX=$(command -v clang++)
			build --host_copt=-D__TERMUX__
			build --host_linkopt=-llog
		EOF
	else
		__setup_bazelisk
		export USE_BAZEL_VERSION="7.4.1"
		_real_bazel="$(command -v bazelisk)"

		rm -rf "$TERMUX_PREFIX/tmp/custom-toolchain"
		mkdir -p "$TERMUX_PREFIX/tmp/custom-toolchain"
		cp -Rf "$TERMUX_STANDALONE_TOOLCHAIN"/* "$TERMUX_PREFIX/tmp/custom-toolchain/"
		rm -rf "$TERMUX_PREFIX/tmp/custom-toolchain/toolchains"

		rm -rf termux-cross/
		mkdir -p termux-cross/
		cp -Rfv "$TERMUX_SCRIPTDIR/packages/bazel/termux-cross/"* termux-cross/
		mv termux-cross/toolchain/template "termux-cross/toolchain/$TERMUX_ARCH"

		cat <<- 'EOF' > "termux-cross/toolchain/$TERMUX_ARCH/bin/wrapper.sh"
			#!/usr/bin/env sh
			_tool="$(basename "$0")"
			for _bin in external/*termux-toolchain/bin/"$_tool"; do
				if [ -x "$_bin" ]; then
					exec "$_bin" "$@"
				fi
			done
			echo "ERROR: $_tool not found under external/*termux-toolchain/bin/" >&2
			exit 127
		EOF
		chmod 755 "termux-cross/toolchain/$TERMUX_ARCH/bin/wrapper.sh"

		local _file
		for _file in $AR $CC $CXX $LD $NM $OBJDUMP $STRIP; do
			ln -sf wrapper.sh "termux-cross/toolchain/$TERMUX_ARCH/bin/$(basename "$_file")"
		done

		sed -i -e 's|cc_toolchain_config(name = "@TERMUX_ARCH@_toolchain_config")|cc_toolchain_config(\n    name = "@TERMUX_ARCH@_toolchain_config",\n    prefix_files = ["@termux-prefix//:prefix"],\n    toolchain_files = ["@termux-toolchain//:toolchain"],\n)|' \
			"termux-cross/toolchain/$TERMUX_ARCH/BUILD"

		cp "$TERMUX_PKG_BUILDER_DIR/cc_toolchain_config.bzl" \
			"termux-cross/toolchain/$TERMUX_ARCH/cc_toolchain_config.bzl"

		for _file in "termux-cross/toolchain/$TERMUX_ARCH"/{BUILD,cc_toolchain_config.bzl}; do
			sed -i "s|@TERMUX_ARCH@|$TERMUX_ARCH|g
					s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g
					s|@AR@|$(basename "$AR")|g
					s|@CC@|$(basename "$CC")|g
					s|@CPP@|$(basename "$CPP")|g
					s|@CXX@|$(basename "$CXX")|g
					s|@LD@|$(basename "$LD")|g
					s|@NM@|$(basename "$NM")|g
					s|@OBJDUMP@|$(basename "$OBJDUMP")|g
					s|@STRIP@|$(basename "$STRIP")|g" "$_file"
		done

		local _bazel_cpu="$TERMUX_ARCH"
		if [[ "$TERMUX_ARCH" == "x86_64" ]]; then
			_bazel_cpu="k8"
		fi

		cat <<- EOF >> "$TERMUX_PKG_SRCDIR/.bazelrc"
			build --extra_toolchains=//termux-cross/toolchain/${TERMUX_ARCH}:${TERMUX_ARCH}_linux_toolchain
			build --host_crosstool_top=@bazel_tools//tools/cpp:toolchain
			build --crosstool_top=//termux-cross/toolchain/${TERMUX_ARCH}:gcc_toolchain
			build --host_platform=@platforms//host
			build --platforms=//termux-cross/platforms:termux_${TERMUX_ARCH}
			build --cpu=${_bazel_cpu}
		EOF
	fi

	cat <<- EOF > "$TERMUX_PKG_TMPDIR/bin/bazel"
		#!/usr/bin/env bash
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		exec "$_real_bazel" "\$@"
	EOF
	chmod 755 "$TERMUX_PKG_TMPDIR/bin/bazel"
}

termux_step_post_make_install() {
	bazel shutdown || true
	rm -rf "$TERMUX_PREFIX/tmp/custom-toolchain"
}
