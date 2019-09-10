TERMUX_PKG_HOMEPAGE=https://github.com/lightningnetwork/lnd
TERMUX_PKG_DESCRIPTION="Lightning Network Daemon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.7.0-beta 
TERMUX_PKG_SRCURL=(https://github.com/lightningnetwork/lnd/releases/download/v$TERMUX_PKG_VERSION/lnd-source-v$TERMUX_PKG_VERSION.tar.gz https://github.com/lightningnetwork/lnd/releases/download/v$TERMUX_PKG_VERSION/vendor.tar.gz) 
TERMUX_PKG_SHA256=(d5d9178178dca9a3e770dc74d655f579e6aafaec9e7b32a726c44dc093c52aa0 4ee8e4b7d8372c8e750125dcdd93cd1b1b55687460a2f7fe1c8a23e60bb17e7b)
TERMUX_PKG_BUILD_IN_SRC=true 

termux_step_make() {
    termux_setup_golang

    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v0.7.0-beta" ./cmd/lnd
    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v0.7.0-beta" ./cmd/lncli

}

termux_step_make_install() {
    
    install -Dm700 lnd lncli "$TERMUX_PREFIX"/bin/
}

termux_step_extract_package() { #modded without stripping
	if [ -z "${TERMUX_PKG_SRCURL:=""}" ] || [ -n "${TERMUX_PKG_SKIP_SRC_EXTRACT:=""}" ]; then
		mkdir -p "$TERMUX_PKG_SRCDIR"
		return
	fi
	cd "$TERMUX_PKG_TMPDIR"
	local PKG_SRCURL=(${TERMUX_PKG_SRCURL[@]})
	local PKG_SHA256=(${TERMUX_PKG_SHA256[@]})
	if  [ ! ${#PKG_SRCURL[@]} == ${#PKG_SHA256[@]} ] && [ ! ${#PKG_SHA256[@]} == 0 ]; then
		termux_error_exit "Error: length of TERMUX_PKG_SRCURL isn't equal to length of TERMUX_PKG_SHA256."
	fi
	# STRIP=1 extracts archives straight into TERMUX_PKG_SRCDIR while STRIP=0 puts them in subfolders. zip has same behaviour per default
	# If this isn't desired then this can be fixed in termux_step_post_extract_package.
	local STRIP=0
	for i in $(seq 0 $(( ${#PKG_SRCURL[@]}-1 ))); do
		test "$i" -gt 0 && STRIP=0
		local filename
		filename=$(basename "${PKG_SRCURL[$i]}")
		local file="$TERMUX_PKG_CACHEDIR/$filename"
		# Allow TERMUX_PKG_SHA256 to be empty:
		set +u
		termux_download "${PKG_SRCURL[$i]}" "$file" "${PKG_SHA256[$i]}"
		set -u

		local folder
		set +o pipefail
		if [ "${file##*.}" = zip ]; then
			folder=$(unzip -qql "$file" | head -n1 | tr -s ' ' | cut -d' ' -f5-)
			rm -Rf $folder
			unzip -q "$file"
			mv $folder "$TERMUX_PKG_SRCDIR"
		else
			mkdir -p "$TERMUX_PKG_SRCDIR"
			tar xf "$file" -C "$TERMUX_PKG_SRCDIR" --strip-components=$STRIP
		fi
		set -o pipefail
	done
}

