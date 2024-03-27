termux_step_massage() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"

	local ADDING_PREFIX=""
	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		ADDING_PREFIX="glibc/"
	fi

	# Remove lib/charset.alias which is installed by gettext-using packages:
	rm -f lib/charset.alias

	# Remove cache file created by update-desktop-database:
	rm -f share/applications/mimeinfo.cache

	# Remove cache file created by glib-compile-schemas:
	rm -f share/glib-2.0/schemas/gschemas.compiled

	# Remove cache file generated when using glib-cross-bin:
	rm -rf opt/glib/cross/share/glib-2.0/codegen/__pycache__

 	# Removing the pacman log that is often included in the package:
  	rm -f var/log/pacman.log

	# Remove cache file created by gtk-update-icon-cache:
	rm -f share/icons/hicolor/icon-theme.cache

	# Remove locale files we're not interested in::
	rm -Rf share/locale

	# `update-mime-database` updates NOT ONLY "$PREFIX/share/mime/mime.cache".
	# Simply removing this specific file does not solve the issue.
	if [ -e "share/mime/mime.cache" ]; then
		termux_error_exit "MIME cache found in package. Please disable \`update-mime-database\`."
	fi

	# Remove old kept libraries (readline):
	find . -name '*.old' -print0 | xargs -0 -r rm -f

	# Move over sbin to bin:
	for file in sbin/*; do if test -f "$file"; then mv "$file" bin/; fi; done
	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		for file in glibc/sbin/*; do if test -f "$file"; then mv "$file" glibc/bin/; fi; done
	fi

	# Remove world permissions and make sure that user still have read-write permissions.
	chmod -Rf u+rw,g-rwx,o-rwx . || true

	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		if [ "$TERMUX_PKG_NO_STRIP" != "true" ] && [ "$TERMUX_DEBUG_BUILD" = "false" ]; then
			# Strip binaries. file(1) may fail for certain unusual files, so disable pipefail.
			set +e +o pipefail
			find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" \) -type f |
				xargs -r file | grep -E "ELF .+ (executable|shared object)" | cut -f 1 -d : |
				xargs -r "$STRIP" --strip-unneeded --preserve-dates
			set -e -o pipefail
		fi

		if [ "$TERMUX_PKG_NO_ELF_CLEANER" != "true" ]; then
			# Remove entries unsupported by Android's linker:
			find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" -o -path "./opt/*" \) -type f -print0 | xargs -r -0 \
				"$TERMUX_ELF_CLEANER" --api-level $TERMUX_PKG_API_LEVEL
		fi
	fi

	local pattern=""
	for file in ${TERMUX_PKG_NO_SHEBANG_FIX_FILES}; do
		if [[ -z "${pattern}" ]]; then
			pattern="${file}"
			continue
		fi
		pattern+='|'"${file}"
	done
	if [[ -n "${pattern}" ]]; then
		pattern='(|./)('"${pattern}"')$'
	fi

	if [ "$TERMUX_PKG_NO_SHEBANG_FIX" != "true" ]; then
		# Fix shebang paths:
		while IFS= read -r -d '' file; do
			if [[ -n "${pattern}" ]] && [[ -n "$(echo "${file}" | grep -E "${pattern}")" ]]; then
				echo "INFO: Skip shebang fix for ${file}"
				continue
			fi
			if head -c 100 "$file" | head -n 1 | grep -E "^#!.*/bin/.*" | grep -q -E -v -e "^#! ?/system" -e "^#! ?$TERMUX_PREFIX_CLASSICAL"; then
				sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$TERMUX_PREFIX/bin/\2@" "$file"
			fi
		done < <(find -L . -type f -print0)
	fi

	# Delete the info directory file.
	rm -rf ./${ADDING_PREFIX}share/info/dir

	# Mostly specific to X11-related packages.
	rm -f ./${ADDING_PREFIX}share/icons/hicolor/icon-theme.cache

	test ! -z "$TERMUX_PKG_RM_AFTER_INSTALL" && rm -Rf $TERMUX_PKG_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

	if [ -d ./${ADDING_PREFIX}share/man ]; then
		# Remove non-english man pages:
		find ./${ADDING_PREFIX}share/man -mindepth 1 -maxdepth 1 -type d ! -name man\* | xargs -r rm -rf

		# Compress man pages with gzip:
		find ./${ADDING_PREFIX}share/man -type f ! -iname \*.gz -print0 | xargs -r -0 gzip

		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
		while IFS= read -r -d '' file; do
			local _link_value
			_link_value=$(readlink $file)
			rm $file
			ln -s $_link_value.gz $file.gz
		done < <(find ./${ADDING_PREFIX}share/man -type l ! -iname \*.gz -print0)
	fi

	# Check so files were actually installed. Exclude
	# share/doc/$TERMUX_PKG_NAME/ as a license file is always
	# installed there.
	if [ "$(find . -path "./${ADDING_PREFIX}share/doc/$TERMUX_PKG_NAME" -prune -o -type f -print | head -n1)" = "" ]; then
		if [ -f "$TERMUX_PKG_SRCDIR"/configure.ac -o -f "$TERMUX_PKG_SRCDIR"/configure.in ]; then
			termux_error_exit "No files in package. Maybe you need to run autoreconf -fi before configuring."
		else
			termux_error_exit "No files in package."
		fi
	fi

	local HARDLINKS
	HARDLINKS="$(find . -type f -links +1)"
	if [ -n "$HARDLINKS" ]; then
		if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
			termux_error_exit "Package contains hard links: $HARDLINKS"
		elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
			local declare hard_list
			for i in $HARDLINKS; do
				hard_list[$(ls -i "$i" | awk '{printf $1}')]+="$i "
			done
			local root_file
			for i in ${!hard_list[@]}; do
				root_file=""
				for j in ${hard_list[$i]}; do
					if [ -z "$root_file" ]; then
						root_file="$j"
						continue
					fi
					ln -sf "${TERMUX_PREFIX_CLASSICAL}/${root_file:2}" "${j}"
				done
			done
		fi
	fi

	# Check for directory "$PREFIX/man" which indicates packaging error.
	if [ -d "./${ADDING_PREFIX}man" ]; then
		termux_error_exit "Package contains directory \"\$PREFIX/man\" ($TERMUX_PREFIX/man). Use \"\$PREFIX/share/man\" ($TERMUX_PREFIX/share/man) instead."
	fi

	# Check for directory "$PREFIX/$PREFIX" which almost always indicates
	# packaging error.
	if [ -d "./${TERMUX_PREFIX#/}" ]; then
		termux_error_exit "Package contains directory \"\$PREFIX/\$PREFIX\" ($TERMUX_PREFIX/${TERMUX_PREFIX#/})"
	fi

	# Check for Debianish Python directory which indicates packaging error.
	local _python_deb_install_layout_dir="${ADDING_PREFIX}lib/python3/dist-packages"
	if [ -d "./${_python_deb_install_layout_dir}" ]; then
		termux_error_exit "Package contains directory \"\$PREFIX/${_python_deb_install_layout_dir}\" ($TERMUX_PREFIX/${_python_deb_install_layout_dir})"
	fi

	# Check so that package is not affected by
	# https://github.com/android/ndk/issues/1614, or
	# https://github.com/termux/termux-packages/issues/9944
	if [[ "${TERMUX_PACKAGE_LIBRARY}" == "bionic" ]]; then
		echo "INFO: Using READELF ... ${READELF} ... $(command -v "${READELF}")"
		local t0=$(cut -d"." -f1 /proc/uptime)
		echo "INFO: Generating symbols regex"
		SYMBOLS="$(${READELF} -s $(${TERMUX_HOST_PLATFORM}-clang -print-libgcc-file-name) | grep "FUNC    GLOBAL HIDDEN" | awk '{print $8}')"
		SYMBOLS+=" $(echo libandroid_{sem_{open,close,unlink},shm{ctl,get,at,dt}})"
		SYMBOLS+=" $(libc_o_map)"
		SYMBOLS+=" $(libc_p_map)"
		SYMBOLS+=" $(libc_q_map)"
		SYMBOLS+=" $(libc_r_map)"
		SYMBOLS+=" $(libc_s_map)"
		SYMBOLS+=" $(libc_t_map)"
		SYMBOLS+=" $(libc_u_map)"
		SYMBOLS+=" $(echo ${TERMUX_PKG_EXTRA_UNDEF_SYMBOLS_TO_CHECK})"
		grep_pattern="$(create_grep_pattern $SYMBOLS)"
		local t1=$(cut -d"." -f1 /proc/uptime)
		echo "INFO: Done ... $((t1-t0))s"
		echo "INFO: Total symbols $(echo ${SYMBOLS} | wc -w)"
		local t0=$(cut -d"." -f1 /proc/uptime)
		echo "INFO: Running symbol checks"
		local files=$(find . -type f)
		local valid=$(echo "${files}" | xargs -P"$(nproc)" -i bash -c 'if "${READELF}" -h {} &>/dev/null; then echo {}; fi')
		local undef=$(echo "${valid}" | xargs -P"$(nproc)" -n1 "${READELF}" -s | grep -E "${grep_pattern}")
		local t1=$(cut -d"." -f1 /proc/uptime)
		echo "INFO: Done ... $((t1-t0))s"
		local numberOfFiles=$(echo "${files}" | wc -l)
		local numberOfValid=$(echo "${valid}" | wc -l)
		echo "INFO: Checked ${numberOfValid} / ${numberOfFiles} files"
		if [[ "${numberOfValid}" -gt "${numberOfFiles}" ]]; then
			termux_error_exit "${numberOfValid} > ${numberOfFiles}"
		fi
		if [[ -n "${undef}" ]]; then
			local e=0
			local valid_s=$(echo "${valid}" | sort)
			for f in ${valid_s}; do
				local undef_s=$("${READELF}" -s "${f}" | grep -E "${grep_pattern}")
				if [[ -n "${undef_s}" ]]; then
					case "${f}" in
					*.a) echo -e "SKIP: ${f} contains undefined symbols:\n${undef_s}" >&2 ;;
					*.rlib) echo -e "SKIP: ${f} contains undefined symbols:\n${undef_s}" >&2 ;;
					*) e=1 && echo -e "ERROR: ${f} contains undefined symbols:\n${undef_s}" >&2 ;;
					esac
				fi
			done
			if [[ "${e}" == "1" ]]; then termux_error_exit "Refer above"; fi
		fi
	fi

	if [ "$TERMUX_PACKAGE_FORMAT" = "debian" ]; then
		termux_create_debian_subpackages
	elif [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		termux_create_pacman_subpackages
	fi

	# Remove unnecessary files in haskell packages:
	if ! [[ $TERMUX_PKG_NAME =~ ghc|ghc-libs ]]; then
		test -f ./${ADDING_PREFIX}lib/ghc-*/settings && rm -rf ./${ADDING_PREFIX}lib/ghc-*/settings
	fi

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
}

# Local function called by termux_step_massage
create_grep_pattern() {
	symbol_type='NOTYPE[[:space:]]+GLOBAL[[:space:]]+DEFAULT[[:space:]]+UND[[:space:]]+'
	echo -n "$symbol_type$1"'$'
	shift 1
	for arg in "$@"; do
		echo -n "|$symbol_type$arg"'$'
	done
}

# https://android.googlesource.com/platform/bionic/+/main/libc/libc.map.txt
libc_o_map() {
	# Android 8.x
	local symbols=""
	case "${TERMUX_ARCH}" in
	arm|i686) symbols+=" bsd_signal" ;;
	esac
	symbols+="
	__sendto_chk
	__system_property_read_callback
	__system_property_wait
	catclose
	catgets
	catopen
	ctermid
	endgrent
	endpwent
	futimes
	futimesat
	getdomainname
	getgrent
	getpwent
	getsubopt
	hasmntopt
	lutimes
	mallopt
	mblen
	msgctl
	msgget
	msgrcv
	msgsnd
	nl_langinfo
	nl_langinfo_l
	pthread_getname_np
	quotactl
	semctl
	semget
	semop
	semtimedop
	setdomainname
	setgrent
	setpwent
	shmat
	shmctl
	shmdt
	shmget
	sighold
	sigignore
	sigpause
	sigrelse
	sigset
	strtod_l
	strtof_l
	strtol_l
	strtoul_l
	sync_file_range
	towctrans
	towctrans_l
	wctrans
	wctrans_l
	"
	# libm
	symbols+="
	cacoshl
	cacosl
	casinhl
	casinl
	catanhl
	catanl
	ccoshl
	ccosl
	cexpl
	clog
	clogf
	clogl
	cpow
	cpowf
	cpowl
	csinhl
	csinl
	ctanhl
	ctanl
	"
	# libdl
	symbols+="
	__cfi_shadow_size
	__cfi_slowpath
	__cfi_slowpath_diag
	"
	echo ${symbols}
}

libc_p_map() {
	# Android 9
	local symbols="
	__freading
	__free_hook
	__fseterr
	__fwriting
	__malloc_hook
	__memalign_hook
	__realloc_hook
	aligned_alloc
	endhostent
	endnetent
	endprotoent
	epoll_pwait64
	fexecve
	fflush_unlocked
	fgetc_unlocked
	fgets_unlocked
	fputc_unlocked
	fputs_unlocked
	fread_unlocked
	fwrite_unlocked
	getentropy
	getnetent
	getprotoent
	getrandom
	getlogin_r
	glob
	globfree
	hcreate
	hcreate_r
	hdestroy
	hdestroy_r
	hsearch
	hsearch_r
	iconv
	iconv_close
	iconv_open
	posix_spawn
	posix_spawnattr_destroy
	posix_spawnattr_getflags
	posix_spawnattr_getpgroup
	posix_spawnattr_getschedparam
	posix_spawnattr_getschedpolicy
	posix_spawnattr_getsigdefault
	posix_spawnattr_getsigdefault64
	posix_spawnattr_getsigmask
	posix_spawnattr_getsigmask64
	posix_spawnattr_init
	posix_spawnattr_setflags
	posix_spawnattr_setpgroup
	posix_spawnattr_setschedparam
	posix_spawnattr_setschedpolicy
	posix_spawnattr_setsigdefault
	posix_spawnattr_setsigdefault64
	posix_spawnattr_setsigmask
	posix_spawnattr_setsigmask64
	posix_spawn_file_actions_addclose
	posix_spawn_file_actions_adddup2
	posix_spawn_file_actions_addopen
	posix_spawn_file_actions_destroy
	posix_spawn_file_actions_init
	posix_spawnp
	ppoll64
	pselect64
	pthread_attr_getinheritsched
	pthread_attr_setinheritsched
	pthread_mutex_timedlock_monotonic_np
	pthread_mutexattr_getprotocol
	pthread_mutexattr_setprotocol
	pthread_rwlock_timedrdlock_monotonic_np
	pthread_rwlock_timedwrlock_monotonic_np
	pthread_setschedprio
	pthread_sigmask64
	sem_timedwait_monotonic_np
	sethostent
	setnetent
	setprotoent
	sigaction64
	sigaddset64
	sigdelset64
	sigemptyset64
	sigfillset64
	sigismember64
	signalfd64
	sigpending64
	sigprocmask64
	sigsuspend64
	sigtimedwait64
	sigwait64
	sigwaitinfo64
	strptime_l
	swab
	syncfs
	wcsftime_l
	wcstod_l
	wcstof_l
	wcstol_l
	wcstoul_l
	"
	echo ${symbols}
}

libc_q_map() {
	# Android 10
	local symbols=""
	case "${TERMUX_ARCH}" in
	arm) symbols+=" __aeabi_read_tp" ;;
	i686) symbols+=" ___tls_get_addr" ;;
	esac
	case "${TERMUX_ARCH}" in
	arm|riscv64|x86_64) symbols+=" __tls_get_addr" ;;
	esac
	symbols+="
	__res_randomid
	android_fdsan_close_with_tag
	android_fdsan_create_owner_tag
	android_fdsan_exchange_owner_tag
	android_fdsan_get_error_level
	android_fdsan_get_owner_tag
	android_fdsan_get_tag_type
	android_fdsan_get_tag_value
	android_fdsan_set_error_level
	android_get_device_api_level
	getloadavg
	pthread_sigqueue
	reallocarray
	timespec_get
	"
	# Used by libselinux | apex
	symbols+=" __system_properties_init"
	# Used by libmemunreachable | apex llndk
	symbols+=" malloc_backtrace malloc_disable malloc_enable malloc_iterate"
	# Used by libandroid_net | apex
	symbols+=" android_getaddrinfofornet"
	# Used by libandroid_runtime, libcutils, libmedia, and libmediautils | apex llndk
	symbols+=" android_mallopt"
	echo ${symbols}
}

libc_r_map() {
	# Android 11
	local symbols=""
	case "${TERMUX_ARCH}" in
	aarch64) symbols+=" __tls_get_addr" ;;
	esac
	symbols+="
	__mempcpy_chk
	call_once
	cnd_broadcast
	cnd_destroy
	cnd_init
	cnd_signal
	cnd_timedwait
	cnd_wait
	memfd_create
	mlock2
	mtx_destroy
	mtx_init
	mtx_lock
	mtx_timedlock
	mtx_trylock
	mtx_unlock
	pthread_cond_clockwait
	pthread_mutex_clocklock
	pthread_rwlock_clockrdlock
	pthread_rwlock_clockwrlock
	renameat2
	sem_clockwait
	statx
	thrd_create
	thrd_current
	thrd_detach
	thrd_equal
	thrd_exit
	thrd_join
	thrd_sleep
	thrd_yield
	tss_create
	tss_delete
	tss_get
	tss_set
	"
    # Unwinder implementation
	case "${TERMUX_ARCH}" in
	arm)
		symbols+="
		__aeabi_unwind_cpp_pr0
		__aeabi_unwind_cpp_pr1
		__aeabi_unwind_cpp_pr2
		__gnu_unwind_frame
		_Unwind_Complete
		_Unwind_VRS_Get
		_Unwind_VRS_Pop
		_Unwind_VRS_Set
		"
		;;
	aarch64|i686|x86_64)
		symbols+="
		__deregister_frame
		__register_frame
		_Unwind_ForcedUnwind
		"
		;;
	esac
	symbols+="
	_Unwind_Backtrace
	_Unwind_DeleteException
	_Unwind_Find_FDE
	_Unwind_FindEnclosingFunction
	_Unwind_GetCFA
	_Unwind_GetDataRelBase
	_Unwind_GetGR
	_Unwind_GetIP
	_Unwind_GetIPInfo
	_Unwind_GetLanguageSpecificData
	_Unwind_GetRegionStart
	_Unwind_GetTextRelBase
	_Unwind_RaiseException
	_Unwind_Resume
	_Unwind_Resume_or_Rethrow
	_Unwind_SetGR
	_Unwind_SetIP
	"
	echo ${symbols}
}

libc_s_map() {
	# Android 12
	local symbols="
	__libc_get_static_tls_bounds
	__libc_register_thread_exit_callback
	__libc_iterate_dynamic_tls
	__libc_register_dynamic_tls_listeners
	android_reset_stack_guards
	ffsl
	ffsll
	pidfd_getfd
	pidfd_open
	pidfd_send_signal
	process_madvise
	"
	echo ${symbols}
}

libc_t_map() {
	# Android 13
	local symbols="
	backtrace
	backtrace_symbols
	backtrace_symbols_fd
	preadv2
	preadv64v2
	pwritev2
	pwritev64v2
	"
	echo ${symbols}
}

libc_u_map() {
	# Android 14
	local symbols="
	__freadahead
	close_range
	copy_file_range
	memset_explicit
	posix_spawn_file_actions_addchdir_np
	posix_spawn_file_actions_addfchdir_np
	"
	echo ${symbols}
}
