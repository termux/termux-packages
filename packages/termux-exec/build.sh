TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-exec
TERMUX_PKG_DESCRIPTION="A LD_PRELOAD library for proper functioning of the Termux execution environment"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.0.0
TERMUX_PKG_SRCURL=file:///home/builder/termux-packages/sources/termux-exec.tar
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="TERMUX_EXEC__VERSION=${TERMUX_PKG_VERSION} \
TERMUX__NAME=${TERMUX__NAME} TERMUX_APP__PACKAGE_NAME=${TERMUX_APP__PACKAGE_NAME} \
TERMUX__ROOTFS=${TERMUX__ROOTFS} TERMUX__PREFIX=${TERMUX__PREFIX} \
TERMUX_ENV__S_ROOT=${TERMUX_ENV__S_ROOT} \
TERMUX_ENV__S_TERMUX=${TERMUX_ENV__S_TERMUX} TERMUX_ENV__SE_TERMUX=\$${TERMUX_ENV__SE_TERMUX} \
TERMUX_ENV__S_TERMUX_API_APP=${TERMUX_ENV__S_TERMUX_API_APP} TERMUX_ENV__SE_TERMUX_API_APP=\$${TERMUX_ENV__SE_TERMUX_API_APP} \
TERMUX_ENV__S_TERMUX_EXEC=${TERMUX_ENV__S_TERMUX_EXEC} TERMUX_ENV__SE_TERMUX_EXEC=\$${TERMUX_ENV__SE_TERMUX_EXEC} \
TERMUX_ENV__S_TERMUX_EXEC_TESTS=${TERMUX_ENV__S_TERMUX_EXEC_TESTS} TERMUX_ENV__SE_TERMUX_EXEC_TESTS=\$${TERMUX_ENV__SE_TERMUX_EXEC_TESTS} \
TERMUX_APP__NAMESPACE=${TERMUX_APP__NAMESPACE} \
TERMUX_APP__SHELL_ACTIVITY__COMPONENT_NAME=${TERMUX_APP__SHELL_ACTIVITY__COMPONENT_NAME} TERMUX_APP__SHELL_SERVICE__COMPONENT_NAME=${TERMUX_APP__SHELL_SERVICE__COMPONENT_NAME}"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_massage() {
	# Hack to compile runtime-binary-tests for api level 28 if default (currently 24) is less than it.
	cd "$TERMUX_PKG_BUILDDIR"
	if [[ "$TERMUX_PKG_API_LEVEL" -lt 28 ]]; then
		export TERMUX_PKG_API_LEVEL=28
		termux_step_setup_toolchain

		local QUIET_BUILD=
		if [ "$TERMUX_QUIET_BUILD" = true ]; then
			QUIET_BUILD="-s"
		fi

		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD TERMUX_EXEC_TESTS_API_LEVEL=28 runtime-binary-tests
		else
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD ${TERMUX_PKG_EXTRA_MAKE_ARGS} TERMUX_EXEC_TESTS_API_LEVEL=28 runtime-binary-tests
		fi

		install -m700 build/tests/runtime-binary-tests-fsanitize28 "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/libexec/installed-tests/termux-exec/runtime-binary-tests-fsanitize28"
		$TERMUX_ELF_CLEANER --api-level 28 "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/libexec/installed-tests/termux-exec/runtime-binary-tests-fsanitize28"

		install -m700 build/tests/runtime-binary-tests-nofsanitize28 "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/libexec/installed-tests/termux-exec/runtime-binary-tests-nofsanitize28"
		$TERMUX_ELF_CLEANER --api-level 28 "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/libexec/installed-tests/termux-exec/runtime-binary-tests-nofsanitize28"
	fi
}
