termux_step_massage() {
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"

	# Remove lib/charset.alias which is installed by gettext-using packages:
	rm -f lib/charset.alias

	# Remove locale files we're not interested in::
	rm -Rf share/locale

	# Remove old kept libraries (readline):
	find . -name '*.old' -print0 | xargs -0 -r rm -f

	# Move over sbin to bin:
	for file in sbin/*; do if test -f "$file"; then mv "$file" bin/; fi; done

	# Remove world permissions and make sure that user still have read-write permissions.
	chmod -Rf u+rw,g-rwx,o-rwx . || true

	if [ "$TERMUX_DEBUG" = "" ]; then
		# Strip binaries. file(1) may fail for certain unusual files, so disable pipefail.
		set +e +o pipefail
		find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" \) -type f | \
			xargs -r file | grep -E "ELF .+ (executable|shared object)" | cut -f 1 -d : | \
				xargs -r "$STRIP" --strip-unneeded --preserve-dates
		set -e -o pipefail
	fi

	# Remove entries unsupported by Android's linker:
	find . \( -path "./bin/*" -o -path "./lib/*" -o -path "./libexec/*" \) -type f -print0 | xargs -r -0 "$TERMUX_ELF_CLEANER"

	# Fix shebang paths:
	while IFS= read -r -d '' file
	do
		head -c 100 "$file" | grep -E "^#\!.*\\/bin\\/.*" | grep -q -E -v "^#\! ?\\/system" && \
			sed --follow-symlinks -i -E "1 s@^#\!(.*)/bin/(.*)@#\!$TERMUX_PREFIX/bin/\2@" "$file"
	done < <(find -L . -type f -print0)

	test ! -z "$TERMUX_PKG_RM_AFTER_INSTALL" && rm -Rf $TERMUX_PKG_RM_AFTER_INSTALL

	find . -type d -empty -delete # Remove empty directories

	if [ -d share/man ]; then
		# Remove non-english man pages:
		find share/man -mindepth 1 -maxdepth 1 -type d ! -name man\* | xargs -r rm -rf

		# Compress man pages with gzip:
		find share/man -type f ! -iname \*.gz -print0 | xargs -r -0 gzip

		# Update man page symlinks, e.g. unzstd.1 -> zstd.1:
		while IFS= read -r -d '' file
		do
			local _link_value
			_link_value=$(readlink $file)
			rm $file
			ln -s $_link_value.gz $file.gz
		done < <(find share/man -type l ! -iname \*.gz -print0)
	fi

	termux_create_subpackages

	# .. remove empty directories (NOTE: keep this last):
	find . -type d -empty -delete
}
