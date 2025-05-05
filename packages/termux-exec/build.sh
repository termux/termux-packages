TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-exec-package
TERMUX_PKG_DESCRIPTION="Utils and libraries for Termux exec including a LD_PRELOAD shared library for proper functioning of the Termux execution environment"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.4.0
TERMUX_PKG_SRCURL=https://github.com/termux/termux-exec-package/archive/refs/tags/v${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=ed82c94592a4fc18845d5d45b6f2f36f78ad5910e5ffdccaaa10dbd9279e3682
TERMUX_PKG_BUILD_DEPENDS="termux-core-static"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_MAKE_ARGS="TERMUX_EXEC_PKG__VERSION=${TERMUX_PKG_VERSION} TERMUX_EXEC_PKG__ARCH=${TERMUX_ARCH} \
TERMUX__NAME=${TERMUX__NAME} TERMUX__LNAME=${TERMUX__LNAME} \
TERMUX__REPOS_HOST_ORG_NAME=${TERMUX__REPOS_HOST_ORG_NAME} \
TERMUX_APP__NAME=${TERMUX_APP__NAME} \
TERMUX_APP__PACKAGE_NAME=${TERMUX_APP__PACKAGE_NAME} TERMUX_APP__DATA_DIR=${TERMUX_APP__DATA_DIR} \
TERMUX__ROOTFS=${TERMUX__ROOTFS} TERMUX__PREFIX=${TERMUX__PREFIX} \
TERMUX_ENV__S_ROOT=${TERMUX_ENV__S_ROOT} \
TERMUX_ENV__SS_TERMUX=${TERMUX_ENV__SS_TERMUX} TERMUX_ENV__S_TERMUX=${TERMUX_ENV__S_TERMUX} \
TERMUX_ENV__SS_TERMUX_APP=${TERMUX_ENV__SS_TERMUX_APP} TERMUX_ENV__S_TERMUX_APP=${TERMUX_ENV__S_TERMUX_APP} \
TERMUX_ENV__SS_TERMUX_ROOTFS=${TERMUX_ENV__SS_TERMUX_ROOTFS} TERMUX_ENV__S_TERMUX_ROOTFS=${TERMUX_ENV__S_TERMUX_ROOTFS} \
TERMUX_ENV__SS_TERMUX_EXEC=${TERMUX_ENV__SS_TERMUX_EXEC} TERMUX_ENV__S_TERMUX_EXEC=${TERMUX_ENV__S_TERMUX_EXEC} \
TERMUX_ENV__SS_TERMUX_EXEC__TESTS=${TERMUX_ENV__SS_TERMUX_EXEC__TESTS} TERMUX_ENV__S_TERMUX_EXEC__TESTS=${TERMUX_ENV__S_TERMUX_EXEC__TESTS}"

termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/licenses"
	cp -af "$TERMUX_PKG_SRCDIR/LICENSE" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/copyright"
	cp -af "$TERMUX_PKG_SRCDIR/licenses/"* "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/licenses/"
}

termux_step_strip_elf_symbols() {
	termux_step_strip_elf_symbols__from_paths . \
	\( \
		\( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" \) -a \
		\( ! -path "./libexec/installed-tests/termux-exec/*" \) \
	\)
}

termux_step_post_massage() {
	# Hack to compile `libtermux-exec_nos_c_tre_runtime-binary-tests` for api level 28 if default (currently 24) is less than it.
	if [[ "$TERMUX_PKG_API_LEVEL" -lt 28 ]]; then
		export TERMUX_PKG_API_LEVEL=28
		termux_step_setup_toolchain

		local QUIET_BUILD=
		if [ "$TERMUX_QUIET_BUILD" = true ]; then
			QUIET_BUILD="-s"
		fi

		printf "\n%s\n" "Building libtermux-exec_nos_c_tre_runtime-binary-tests for TERMUX_PKG_API_LEVEL '$TERMUX_PKG_API_LEVEL'"
		cd "$TERMUX_PKG_BUILDDIR"
		make $QUIET_BUILD $TERMUX_PKG_EXTRA_MAKE_ARGS TERMUX_EXEC_PKG__TESTS__API_LEVEL=28 build-libtermux-exec_nos_c_tre_runtime-binary-tests

		local TERMUX_EXEC__TESTS__TESTS_PATH="$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/libexec/installed-tests/termux-exec"
		local LIBTERMUX_EXEC__NOS__C__TESTS_PATH="$TERMUX_EXEC__TESTS__TESTS_PATH/lib/termux-exec_nos_c/tre"

		install -m700 build/output/usr/libexec/installed-tests/termux-exec/lib/termux-exec_nos_c/tre/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-fsanitize28 \
			"$LIBTERMUX_EXEC__NOS__C__TESTS_PATH/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-fsanitize28"
		$TERMUX_ELF_CLEANER --api-level 28 "$LIBTERMUX_EXEC__NOS__C__TESTS_PATH/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-fsanitize28"

		install -m700 build/output/usr/libexec/installed-tests/termux-exec/lib/termux-exec_nos_c/tre/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-nofsanitize28 \
			"$LIBTERMUX_EXEC__NOS__C__TESTS_PATH/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-nofsanitize28"
		$TERMUX_ELF_CLEANER --api-level 28 "$LIBTERMUX_EXEC__NOS__C__TESTS_PATH/bin/libtermux-exec_nos_c_tre_runtime-binary-tests-nofsanitize28"
		printf "%s\n\n" "Install libtermux-exec_nos_c_tre_runtime-binary-tests for TERMUX_PKG_API_LEVEL '$TERMUX_PKG_API_LEVEL' successful"
	fi
}

termux_step_create_debscripts() {
	termux_step_create_debscripts__copy_from_dir "$TERMUX_PKG_SRCDIR/build/output/packaging/debian" .
}
