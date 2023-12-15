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
	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ] && [ -d "lib" ]; then
		SYMBOLS="$($READELF -s $($TERMUX_HOST_PLATFORM-clang -print-libgcc-file-name) | grep "FUNC    GLOBAL HIDDEN" | awk '{print $8}')"
		SYMBOLS+=" $(echo libandroid_{sem_{open,close,unlink},shm{ctl,get,at,dt}})"
		SYMBOLS+=" $(echo backtrace{,_symbols{,_fd}})"
		SYMBOLS+=" posix_spawn posix_spawnp"
		grep_pattern="$(create_grep_pattern $SYMBOLS)"
		for lib in $(find lib -name "*.so"); do
			if ! $READELF -h "$lib" &> /dev/null; then
				continue
			fi
			if $READELF -s "$lib" | egrep "${grep_pattern}" &> /dev/null; then
				termux_error_exit "$lib contains undefined symbols:\n$($READELF -s "$lib" | egrep "${grep_pattern}")"
			fi
		done
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
