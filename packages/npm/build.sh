TERMUX_PKG_HOMEPAGE=https://docs.npmjs.com/cli/
TERMUX_PKG_DESCRIPTION="The package manager for JavaScript"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION="11.9.0"
TERMUX_PKG_SRCURL=git+https://github.com/npm/cli.git
TERMUX_PKG_SHA256=a7bba8c40e179d3be92176026f6c29caf6a8c7b0fcae4eb71951a9e103ac6f9e
TERMUX_PKG_DEPENDS="nodejs | nodejs-lts"
TERMUX_PKG_ANTI_BUILD_DEPENDS="nodejs, nodejs-lts"
# npm was earlier packaged with nodejs and nodejs-lts packages.
TERMUX_PKG_CONFLICTS="nodejs (<= 25.3.0), nodejs-lts (<= 24.13.0)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/npm/cli/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref --raw-output | grep "^refs/tags/v${TERMUX_PKG_VERSION%%.*}" | sed -e 's|refs/tags/v||g')
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_configure() {
	:
}

termux_step_make_install() {
	termux_setup_nodejs

	node scripts/resetdeps.js
	node . run build -w docs

	# Install npm into $TERMUX_PREFIX/lib/node_modules/npm
	rm -rf "$TERMUX_PREFIX/lib/node_modules/npm"
	mkdir -p "$TERMUX_PREFIX/lib/node_modules/npm"
	mapfile -t npm_files < <(node . pack --ignore-scripts --dry-run --json | \
		jq --raw-output '.[].files.[].path')
	cp --parents -a "${npm_files[@]}" "$TERMUX_PREFIX/lib/node_modules/npm"

	# Install npm and npx binaries
	ln -srf "$TERMUX_PREFIX/lib/node_modules/npm/bin/npm-cli.js" "$TERMUX_PREFIX/bin/npm"
	ln -srf "$TERMUX_PREFIX/lib/node_modules/npm/bin/npx-cli.js" "$TERMUX_PREFIX/bin/npx"
	# Remove broken npm and npx binaries
	rm "$TERMUX_PREFIX/lib/node_modules/npm/bin/"{npm,npx}{,.ps1,.cmd}

	# Install bash completion script
	mkdir -p "$TERMUX_PREFIX/etc/bash_completion.d"
	node . completion >> "$TERMUX_PREFIX/etc/bash_completion.d/npm"

	#	Install the manpages. Stolen from Arch Linux's PKGBUILD
	cd $TERMUX_PREFIX/lib/node_modules/npm/man
	# Workaround for https://github.com/npm/cli/issues/780
	local name page sec title
	for page in man5/folders.5 man5/install.5 man7/*.7; do
		sec=${page##*.}
		name=$(basename "$page" ."$sec")
		title=${name@U}

		sed -Ei "s/^\.TH \"$title\"/.TH \"NPM-$title\"/" "$page"
		sed -Ei 's/^(\.TH "NPM-'"$title"'" "[^"]+") "[^"]+"/\1 ""/' "$page"

		mv "$page" "${page/\///npm-}"
	done
	gzip --no-name man?/*
	local dest sec_dir
	for sec_dir in man?; do
		dest="$TERMUX_PREFIX/share/man/$sec_dir"
		install -d "$dest"
		ln -srf "$sec_dir"/* "$dest"
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "Earlier versions of npm bundled with nodejs and nodejs-lts used to set npm config foreground-scripts to true."
	echo "This is no longer the case. If you had set this config, you might want to unset it now."
	echo "You can do this by running: npm config delete foreground-scripts"
	EOF
}
