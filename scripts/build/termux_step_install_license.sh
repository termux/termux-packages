# shellcheck shell=bash
termux_step_install_license() {
	[[ "$TERMUX_PKG_METAPACKAGE" == 'true' ]] && return

	echo "Installing licenses ($TERMUX_PKG_LICENSE) for package '$TERMUX_PKG_NAME'"

	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	local LICENSE COUNTER=0
	local -a LICENSES
	# Parse the license(s)
	IFS="," read -r -a LICENSES <<< "${TERMUX_PKG_LICENSE}"
	shopt -s extglob
	LICENSES=("${LICENSES[@]##+([[:space:]])}")
	LICENSES=("${LICENSES[@]%%+([[:space:]])}")
	shopt -u extglob

	# Was a license file specified?
	if [[ -n "${TERMUX_PKG_LICENSE_FILE}" ]]; then
		local -a LICENSE_FILES
		IFS="," read -r -a LICENSE_FILES <<< "${TERMUX_PKG_LICENSE_FILE}"
		shopt -s extglob
		LICENSE_FILES=("${LICENSE_FILES[@]##+([[:space:]])}")
		LICENSE_FILES=("${LICENSE_FILES[@]%%+([[:space:]])}")
		shopt -u extglob

		COUNTER=1
		local LICENSE_FILE LICENSE_FILEPATH
		local -A INSTALLED_LICENSES=()
		for LICENSE_FILE in "${LICENSE_FILES[@]}"; do
			# Skip empty lines
			[[ -z "${LICENSE_FILE}" ]] && continue

			# Check that the license file exists in the source files
			[[ -f "$TERMUX_PKG_SRCDIR/$LICENSE_FILE" ]] || {
				termux_error_exit "$TERMUX_PKG_SRCDIR/$LICENSE_FILE does not exist"
			}

			LICENSE_FILEPATH="$(basename "$LICENSE_FILE")"
			if [[ -n ${INSTALLED_LICENSES[${LICENSE_FILEPATH}]:-} ]]; then
				# We have already installed a license file named $(basename $LICENSE) so add a suffix to it
				TARGET="$TERMUX_PREFIX/share/doc/${TERMUX_PKG_NAME}/${LICENSE_FILEPATH}.$((COUNTER++))"
			else
				TARGET="$TERMUX_PREFIX/share/doc/${TERMUX_PKG_NAME}/${LICENSE_FILEPATH}"
				# shellcheck disable=SC2190 # this is a valid way to assign key value pairs
				INSTALLED_LICENSES+=("${LICENSE_FILEPATH}" 'already installed')
			fi
			cp -vf "${TERMUX_PKG_SRCDIR}/${LICENSE_FILE}" "$TARGET"
		done
	else # If a license file wasn't specified, find the one we need
		local TO_LICENSE             # link target for generic licenses
		local FROM_SOURCES=0         # flag to check if we've included licenses from the source files yet
		local -a COMMON_LICENSE_FILES=( # search list for licenses with copyright information
			'copying'
			'copyright'
			'licence' # spelled with 'C'
			'license' # spelled with 'S'
		)

		local license_name
		# Add *-$license_name variants of the filenames
		for LICENSE in "${COMMON_LICENSE_FILES[@]}"; do
			for license_name in "${LICENSES[@]}"; do
				COMMON_LICENSE_FILES+=("$LICENSE-$license_name") # times (n+1)
			done
		done

		# Add Uppercase and UPPESTCASE variants of the filenames
		for LICENSE in "${COMMON_LICENSE_FILES[@]@u}" "${COMMON_LICENSE_FILES[@]@U}"; do
			COMMON_LICENSE_FILES+=("$LICENSE") # times 3
		done

		# Add *.md, *.MD, *.rst, *.RST, *.txt, *.TXT variants
		for LICENSE in "${COMMON_LICENSE_FILES[@]}"; do
			COMMON_LICENSE_FILES+=("$LICENSE"{.md,.MD,.rst,.RST,.txt,.TXT}) # times 7
		done

		for LICENSE in "${LICENSES[@]}"; do
			case "$LICENSE" in
				# These licenses contain copyright information,
				# so we cannot use a generic license file
				'BSD'|'BSD 2-Clause'|'BSD 3-Clause'|'BSD Simplified'\
				|'curl'|'HPND'|'ISC'|'Libpng'|'MIT'|'OFL-1.1'\
				|'PythonPL'|'X11'|'ZLIB')
					# We only want to include the license files from the source files once
					if (( ! FROM_SOURCES )); then
						local FILE
						# Find the license file(s) in the source files
						for FILE in "${COMMON_LICENSE_FILES[@]}"; do
							[[ -f "$TERMUX_PKG_SRCDIR/$FILE" ]] && {
								if (( COUNTER )); then
									cp -vf "${TERMUX_PKG_SRCDIR}/$FILE" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/copyright.${COUNTER}"
								else
									cp -vf "${TERMUX_PKG_SRCDIR}/$FILE" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/copyright"
								fi
								(( ++COUNTER, ++FROM_SOURCES ))
							}
						done
						# If we have not found any licenses after searching, that's an error.
						if (( ! FROM_SOURCES )); then
							termux_error_exit "${TERMUX_PKG_NAME}: Could not find a license file for $LICENSE in the package sources"
						fi
					fi
				;;
				*) # For the rest we can use a link to the generic license file
					[[ -f "$TERMUX_SCRIPTDIR/packages/termux-licenses/LICENSES/${LICENSE}.txt" ]] || {
						# If we get here, no license file could be found
						termux_error_exit "${TERMUX_PKG_NAME}: Could not find a license file for $LICENSE in packages/termux-licenses"
					}
					# the link target depends on the libc being used
					case "$TERMUX_PACKAGE_LIBRARY" in
						'bionic') TO_LICENSE="../../LICENSES/${LICENSE}.txt";;
						'glibc')  TO_LICENSE="../../../../share/LICENSES/${LICENSE}.txt";;
						*)        termux_error_exit "'$TERMUX_PACKAGE_LIBRARY' is not a supported libc";;
					esac
					if (( COUNTER )); then
						ln -vsf "$TO_LICENSE" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/copyright.${COUNTER}"
					else
						ln -vsf "$TO_LICENSE" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/copyright"
					fi
					(( ++COUNTER ))
				;;
			esac
		done

		local license_files
		license_files="$(find -L "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" -maxdepth 1 \( -type f -o -type l \) -name "copyright*")"
		[[ -n "$license_files" ]] || {
			termux_error_exit "No LICENSE file was installed for $TERMUX_PKG_NAME"
		}
	fi
return 0
}
