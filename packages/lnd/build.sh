TERMUX_PKG_HOMEPAGE=https://github.com/lightningnetwork/lnd
TERMUX_PKG_DESCRIPTION="Lightning Network Daemon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.7.1-beta
TERMUX_PKG_SRCURL=(https://github.com/lightningnetwork/lnd/releases/download/v$TERMUX_PKG_VERSION/lnd-source-v$TERMUX_PKG_VERSION.tar.gz
                   https://github.com/lightningnetwork/lnd/releases/download/v$TERMUX_PKG_VERSION/vendor.tar.gz)
TERMUX_PKG_SHA256=(ae8cb77eb7567ed9f8041a17eb6f65280cf81f4fbc3bf10eb671a423f62fc948
                   3bbfa000e2b4c7702f92d24235b5a098f37fd7b5830ca42586678f03d7cf9da3)
TERMUX_PKG_DEPENDS="bitcoin"
TERMUX_PKG_CONFFILES="var/service/lnd/run var/service/lnd/log/run"
TERMUX_PKG_BUILD_IN_SRC=true

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

termux_step_make() {
    termux_setup_golang

    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lnd
    GO111MODULE=on go build -tags linux -v -mod=vendor -ldflags "-X github.com/lightningnetwork/lnd/build.Commit=v$TERMUX_PKG_VERSION" ./cmd/lncli
}

termux_step_make_install() {
    install -Dm700 lnd lncli "$TERMUX_PREFIX"/bin/
}

termux_step_post_make_install() {
    mkdir -p $TERMUX_PREFIX/var/service
    cd $TERMUX_PREFIX/var/service
    mkdir -p lnd/log
    echo "#!$TERMUX_PREFIX/bin/sh" > lnd/run
    echo 'exec lnd 2>&1' >> lnd/run
    chmod +x lnd/run
    touch lnd/down

    ln -sf $TERMUX_PREFIX/share/termux-services/svlogger lnd/log/run
}
