# shellcheck shell=bash
termux_step_configure_haskell_build() {
	termux_setup_jailbreak_cabal
	printf "%s" "Jailbreaking Cabal file..."
	if jailbreak-cabal "${TERMUX_PKG_SRCDIR}"/*.cabal; then
		echo "done."
	else
		termux_error_exit "failed."
	fi

	ENABLE_SHARED="--enable-shared"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-shared/}" ]]; then
		ENABLE_SHARED=""
	fi

	DYNAMIC_EXECUTABLE="
	--ghc-options=-dynamic
	--enable-executable-dynamic
	--disable-library-vanilla
	"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-executable-dynamic/}" ]]; then
		DYNAMIC_EXECUTABLE=""
	fi

	HOST_FLAG="--host=${TERMUX_HOST_PLATFORM}"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--host=/}" ]]; then
		HOST_FLAG=""
	fi

	LIBEXEC_FLAG="--libexecdir=${TERMUX_PREFIX}/libexec"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--libexecdir=/}" ]]; then
		LIBEXEC_FLAG=""
	fi

	QUIET_BUILD=
	if [[ "${TERMUX_QUIET_BUILD}" = true ]]; then
		QUIET_BUILD="-v0"
	fi

	LIB_STRIPPING="--enable-library-stripping"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-library-stripping=/}" ]] || [[ "${TERMUX_DEBUG_BUILD}" = true ]]; then
		LIB_STRIPPING=""
	fi

	EXECUTABLE_STRIPPING="--enable-executable-stripping"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-executable-stripping=/}" ]] || [[ "${TERMUX_DEBUG_BUILD}" = true ]]; then
		EXECUTABLE_STRIPPING=""
	fi

	SPLIT_SECTIONS="--enable-split-sections"
	if [[ "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}" != "${TERMUX_PKG_EXTRA_CONFIGURE_ARGS/--disable-split-sections=/}" ]]; then
		SPLIT_SECTIONS=""
	fi

	# Avoid gnulib wrapping of functions when cross compiling. See
	# http://wiki.osdev.org/Cross-Porting_Software#Gnulib
	# https://gitlab.com/sortix/sortix/wikis/Gnulib
	# https://github.com/termux/termux-packages/issues/76
	AVOID_GNULIB=""
	AVOID_GNULIB+=" ac_cv_func_nl_langinfo=yes"
	AVOID_GNULIB+=" ac_cv_func_calloc_0_nonnull=yes"
	AVOID_GNULIB+=" ac_cv_func_chown_works=yes"
	AVOID_GNULIB+=" ac_cv_func_getgroups_works=yes"
	AVOID_GNULIB+=" ac_cv_func_malloc_0_nonnull=yes"
	AVOID_GNULIB+=" ac_cv_func_posix_spawn=no"
	AVOID_GNULIB+=" ac_cv_func_posix_spawnp=no"
	AVOID_GNULIB+=" ac_cv_func_realloc_0_nonnull=yes"
	AVOID_GNULIB+=" am_cv_func_working_getline=yes"
	AVOID_GNULIB+=" gl_cv_func_dup2_works=yes"
	AVOID_GNULIB+=" gl_cv_func_fcntl_f_dupfd_cloexec=yes"
	AVOID_GNULIB+=" gl_cv_func_fcntl_f_dupfd_works=yes"
	AVOID_GNULIB+=" gl_cv_func_fnmatch_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_abort_bug=no"
	AVOID_GNULIB+=" gl_cv_func_getcwd_null=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_path_max=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_posix_signature=yes"
	AVOID_GNULIB+=" gl_cv_func_gettimeofday_clobber=no"
	AVOID_GNULIB+=" gl_cv_func_gettimeofday_posix_signature=yes"
	AVOID_GNULIB+=" gl_cv_func_link_works=yes"
	AVOID_GNULIB+=" gl_cv_func_lstat_dereferences_slashed_symlink=yes"
	AVOID_GNULIB+=" gl_cv_func_malloc_0_nonnull=yes"
	AVOID_GNULIB+=" gl_cv_func_memchr_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkdir_trailing_dot_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkdir_trailing_slash_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkfifo_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mknod_works=yes"
	AVOID_GNULIB+=" gl_cv_func_realpath_works=yes"
	AVOID_GNULIB+=" gl_cv_func_select_detects_ebadf=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_retval_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_truncation_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_stat_dir_slash=yes"
	AVOID_GNULIB+=" gl_cv_func_stat_file_slash=yes"
	AVOID_GNULIB+=" gl_cv_func_strerror_0_works=yes"
	AVOID_GNULIB+=" gl_cv_func_strtold_works=yes"
	AVOID_GNULIB+=" gl_cv_func_symlink_works=yes"
	AVOID_GNULIB+=" gl_cv_func_tzset_clobber=no"
	AVOID_GNULIB+=" gl_cv_func_unlink_honors_slashes=yes"
	AVOID_GNULIB+=" gl_cv_func_unlink_honors_slashes=yes"
	AVOID_GNULIB+=" gl_cv_func_vsnprintf_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_vsnprintf_zerosize_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_wcrtomb_works=yes"
	AVOID_GNULIB+=" gl_cv_func_wcwidth_works=yes"
	AVOID_GNULIB+=" gl_cv_func_working_getdelim=yes"
	AVOID_GNULIB+=" gl_cv_func_working_mkstemp=yes"
	AVOID_GNULIB+=" gl_cv_func_working_mktime=yes"
	AVOID_GNULIB+=" gl_cv_func_working_strerror=yes"
	AVOID_GNULIB+=" gl_cv_header_working_fcntl_h=yes"
	AVOID_GNULIB+=" gl_cv_C_locale_sans_EILSEQ=yes"

	# NOTE: We do not want to quote AVOID_GNULIB as we want word expansion.
	# shellcheck disable=SC2086
	# shellcheck disable=SC2250,SC2154,SC2248,SC2312
	env $AVOID_GNULIB termux-ghc-setup configure \
		$TERMUX_HASKELL_OPTIMISATION \
		--prefix=$TERMUX_PREFIX \
		--configure-option=--disable-rpath \
		--configure-option=--disable-rpath-hack \
		--configure-option=--host=$HOST_FLAG \
		--ghc-option=-optl-Wl,-rpath=$TERMUX_PREFIX/lib \
		--ghc-option=-optl-Wl,--enable-new-dtags \
		--with-compiler="$(command -v termux-ghc)" \
		--with-ghc-pkg="$(command -v termux-ghc-pkg)" \
		--with-hsc2hs="$(command -v termux-hsc2hs)" \
		--hsc2hs-option=--cross-compile \
		--with-ld=$LD \
		--with-strip=$STRIP \
		--with-ar=$AR \
		--with-pkg-config=$PKG_CONFIG \
		--with-happy="$(command -v happy)" \
		--with-alex="$(command -v alex)" \
		--extra-include-dirs=$TERMUX_PREFIX/include \
		--extra-lib-dirs=$TERMUX_PREFIX/lib \
		--disable-tests \
		$TERMUX_HASKELL_LLVM_BACKEND \
		$SPLIT_SECTIONS \
		$EXECUTABLE_STRIPPING \
		$LIB_STRIPPING \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS \
		$ENABLE_SHARED \
		$QUIET_BUILD \
		$LIBEXEC_FLAG \
		$DYNAMIC_EXECUTABLE
}
