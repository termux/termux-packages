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

	# Remove old kept libraries (readline) and directories (rust):
	find . -name '*.old' -print0 | xargs -0 -r rm -fr

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
		find ./${ADDING_PREFIX}share/man -type f ! -iname \*.gz -print0 | xargs -r -0 gzip -9 -n

		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
		while IFS= read -r -d '' file; do
			local _link_value
			_link_value=$(readlink $file)
			rm $file
			ln -s $_link_value.gz $file.gz
		done < <(find ./${ADDING_PREFIX}share/man -type l ! -iname \*.gz -print0)
	fi

	# Remove python-glibc package files that are created
	# due to its launch during package compilation.
	if [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ] && [ "$TERMUX_PKG_NAME" != "python-glibc" ]; then
		rm -f ./${ADDING_PREFIX}lib/python${TERMUX_PYTHON_VERSION}/__pycache__/{base64,platform,quopri}.cpython-${TERMUX_PYTHON_VERSION//./}.pyc
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
		echo "INFO: READELF=${READELF} ... $(command -v ${READELF})"
		export pattern_file=$(mktemp)
		echo "INFO: Generating symbols regex to ${pattern_file}"
		local t0=$(get_epoch)
		local SYMBOLS=$(${READELF} -s $(${TERMUX_HOST_PLATFORM}-clang -print-libgcc-file-name) | grep -E "FUNC[[:space:]]+GLOBAL[[:space:]]+HIDDEN" | awk '{ print $8 }')
		SYMBOLS+=" $(echo libandroid_{sem_{open,close,unlink},shm{ctl,get,at,dt}})"
		# TODO replace grep all symbols with a parser
		SYMBOLS+=" $(grep "^    [_a-zA-Z0-9]*;" ${TERMUX_SCRIPTDIR}/scripts/lib{c,dl,m}.map.txt | cut -d":" -f2 | sed -e "s/^    //" -e "s/;.*//")"
		SYMBOLS+=" ${TERMUX_PKG_EXTRA_UNDEF_SYMBOLS_TO_CHECK}"
		SYMBOLS=$(echo $SYMBOLS | tr " " "\n" | sort | uniq)
		create_grep_pattern ${SYMBOLS} > "${pattern_file}"
		local t1=$(get_epoch)
		echo "INFO: Done ... $((t1-t0))s"
		echo "INFO: Total symbols $(echo ${SYMBOLS} | wc -w)"

		local nproc=$(nproc)
		echo "INFO: Identifying files with nproc=${nproc}"
		local t0=$(get_epoch)
		local files=$(find . -type f)
		# use bash to see if llvm-readelf crash
		# https://github.com/llvm/llvm-project/issues/89534
		local valid=$(echo "${files}" | xargs -P"${nproc}" -i bash -c 'if ${READELF} -h "{}" &>/dev/null; then echo "{}"; fi')
		local t1=$(get_epoch)
		echo "INFO: Done ... $((t1-t0))s"
		local numberOfFiles=$(echo "${files}" | wc -l)
		local numberOfValid=$(echo "${valid}" | wc -l)
		echo "INFO: Found ${numberOfValid} / ${numberOfFiles} files"
		if [[ "${numberOfValid}" -gt "${numberOfFiles}" ]]; then
			termux_error_exit "${numberOfValid} > ${numberOfFiles}"
		fi

		echo "INFO: Running symbol checks on ${numberOfValid} files with nproc=${nproc}"
		local t0=$(get_epoch)
		local undef=$(echo "${valid}" | xargs -P"${nproc}" -i sh -c '${READELF} -s "{}" | grep -Ef "${pattern_file}"')
		local t1=$(get_epoch)
		echo "INFO: Done ... $((t1-t0))s"

		[[ -n "${undef}" ]] && echo "INFO: Found files with undefined symbols"
		if [[ "${TERMUX_PKG_UNDEF_SYMBOLS_FILES}" == "all" ]]; then
			echo "INFO: Skipping output result as TERMUX_PKG_UNDEF_SYMBOLS_FILES=all"
			undef=""
		fi

		if [[ -n "${undef}" ]]; then
			echo "INFO: Showing result"
			local t0=$(get_epoch)
			local e=0
			local c=0
			local valid_s=$(echo "${valid}" | sort)
			local f excluded_f
			while IFS= read -r f; do
				# exclude object, static files
				case "${f}" in
				*.a) (( e &= ~1 )) || : ;;
				*.o) (( e &= ~1 )) || : ;;
				*.obj) (( e &= ~1 )) || : ;;
				*.rlib) (( e &= ~1 )) || : ;;
				*.syso) (( e &= ~1 )) || : ;;
				*) (( e |= 1 )) || : ;;
				esac
				while IFS= read -r excluded_f; do
					[[ "${f}" == ${excluded_f} ]] && (( e &= ~1 )) && break
				done < <(echo "${TERMUX_PKG_UNDEF_SYMBOLS_FILES}")
				[[ "${TERMUX_PKG_UNDEF_SYMBOLS_FILES}" == "error" ]] && (( e |= 1 )) || :
				[[ $(( e & 1 )) == 0 ]] && echo "SKIP: ${f}" && continue
				local undef_s=$(${READELF} -s "${f}" | grep -Ef "${pattern_file}")
				if [[ -n "${undef_s}" ]]; then
					((c++)) || :
					if [[ $(( e & 1 )) != 0 ]]; then
						echo -e "ERROR: ${f} contains undefined symbols:\n${undef_s}" >&2
						(( e |= 2 )) || :
					else
						local undef_su=$(echo "${undef_s}" | awk '{ print $8 }' | sort | uniq)
						local undef_su_len=$(echo ${undef_su} | wc -w)
						echo "SKIP: ${f} contains undefined symbols: ${undef_su_len}" >&2
					fi
				fi
			done < <(echo "${valid_s}")
			local t1=$(get_epoch)
			echo "INFO: Done ... $((t1-t0))s"
			echo "INFO: Found ${c} files with undefined symbols after exclusion"
			if [[ "${c}" -gt "${numberOfValid}" ]]; then
				termux_error_exit "${c} > ${numberOfValid}"
			fi
			[[ $(( e & 2 )) != 0 ]] && termux_error_exit "Refer above"
		fi
		rm -f "${pattern_file}"
		unset pattern_file
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
	local symbol_type='NOTYPE[[:space:]]+GLOBAL[[:space:]]+DEFAULT[[:space:]]+UND[[:space:]]+'
	echo -n "$symbol_type$1"'$'
	shift 1
	local arg
	for arg in "$@"; do
		echo -n "|$symbol_type$arg"'$'
	done
}

get_epoch() {
	[[ -e /proc/uptime ]] && cut -d"." -f1 /proc/uptime && return
	[[ -n "$(command -v date)" ]] && date +%s && return
	echo 0
}
