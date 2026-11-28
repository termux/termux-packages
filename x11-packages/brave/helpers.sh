# shellcheck shell=bash

# Variable name and destination path (key in brave-core's DEPS) of every
# commit pinned in build.sh.
__BRAVE_DEPS_PINS=(
	"_TWEETNACL_COMMIT:vendor/bat-native-tweetnacl"
	"_WDP_COMMIT:vendor/web-discovery-project"
	"_BIP39_COMMIT:third_party/bip39wally-core-native"
	"_ETHASH_COMMIT:third_party/ethash/src"
	"_BITCOIN_COMMIT:third_party/bitcoin-core/src"
	"_ARGON2_COMMIT:third_party/argon2/src"
	"_PLAYLIST_COMMIT:third_party/playlist_component/src"
	"_FUTURES_RETRY_COMMIT:third_party/rust/futures_retry/v0_5/crate"
	"_LIBRUSTZCASH_COMMIT:components/brave_wallet/browser/zcash/rust/librustzcash/src"
)

# Latest stable brave version. brave-core has no releases and also carries
# nightly/beta tags, so ask brave-browser, which only marks stable ones as latest.
__brave_get_latest_version() {
	local TERMUX_PKG_SRCURL="https://github.com/brave/brave-browser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
	local TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
	termux_github_api_get_tag
}

# Read the pins of brave-core $1 from its DEPS and EXTRA_DEPS into _NEW_* vars.
__brave_resolve_source_pins() {
	local version="$1"
	local raw="https://raw.githubusercontent.com/brave/brave-core/v${version}"
	local tmp deps extra_deps package_json
	tmp="$(mktemp -d)"
	deps="${tmp}/DEPS"
	extra_deps="${tmp}/EXTRA_DEPS"
	package_json="${tmp}/package.json"

	local f
	for f in DEPS EXTRA_DEPS package.json; do
		curl -fsSL "${raw}/${f}" -o "${tmp}/${f}" ||
			{ rm -rf "${tmp}"; termux_error_exit "Could not download ${f} of brave-core v${version}"; }
	done

	# The chromium milestone must match chromium-host-tools, which is bumped by hand.
	local pinned
	pinned="$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['config']['projects']['chrome']['tag'])" "${package_json}")"
	if [[ "${pinned%%.*}" != "${_CHROMIUM_VERSION%%.*}" ]]; then
		rm -rf "${tmp}"
		termux_error_exit "brave ${version} needs chromium ${pinned}, but chromium-host-tools is ${_CHROMIUM_VERSION}. Update chromium-host-tools first."
	fi

	# DEPS: "<dest>": "https://host/org/repo.git@<40 hex commit>"
	local entry var dest commit
	for entry in "${__BRAVE_DEPS_PINS[@]}"; do
		var="${entry%%:*}"
		dest="${entry#*:}"
		commit="$(grep -F "\"${dest}\":" "${deps}" | head -n 1 | grep -oE '@[0-9a-f]{40}' | tr -d '@' || true)"
		[[ -n "${commit}" ]] ||
			{ rm -rf "${tmp}"; termux_error_exit "Pin of '${dest}' not found in DEPS of brave-core v${version}"; }
		printf -v "_NEW${var}" '%s' "${commit}"
	done

	# EXTRA_DEPS is a python dict literal; print the linux-x64 objects we use.
	local out
	out="$(python3 - "${extra_deps}" "${_BRAVE_BUCKET}" <<'PY'
import re, sys
ns = {}
exec(open(sys.argv[1]).read(), ns)
deps, bucket = ns['extra_deps'], sys.argv[2]

def obj(key, pick=lambda o: True):
    d = deps[key]
    assert d['bucket'].rstrip('/').startswith(bucket), f"{key}: unexpected bucket {d['bucket']}"
    return next(o for o in d['objects'] if pick(o))

node = obj('src/brave/third_party/node/node-linux-x64')
mods = obj('src/brave/third_party/node/node_modules')
rust = obj('src/third_party/rust-toolchain', lambda o: o['object_name'].startswith('linux-x64-'))
print('NODE_VERSION=' + re.fullmatch(r'node-v(.+)-linux-x64\.tar\.gz', node['object_name']).group(1))
print('NODE_SHA256=' + node['sha256sum'])
print('NODE_MODULES=' + mods['object_name'])
print('NODE_MODULES_SHA256=' + mods['sha256sum'])
print('RUST_OVERLAY=' + rust['object_name'])
print('RUST_OVERLAY_SHA256=' + rust['sha256sum'])
PY
	)" || { rm -rf "${tmp}"; termux_error_exit "Could not parse EXTRA_DEPS of brave-core v${version}"; }
	rm -rf "${tmp}"

	local line
	while IFS='=' read -r var commit; do
		[[ -n "${commit}" ]] || termux_error_exit "Empty ${var} in EXTRA_DEPS of brave-core v${version}"
		printf -v "_NEW_BRAVE_${var}" '%s' "${commit}"
	done <<< "${out}"
	# Rust overlay vars have no _BRAVE_ prefix in build.sh.
	_NEW_RUST_OVERLAY="${_NEW_BRAVE_RUST_OVERLAY}"
	_NEW_RUST_OVERLAY_SHA256="${_NEW_BRAVE_RUST_OVERLAY_SHA256}"
}

# Copy the files below $1 into $2, keeping the relative layout. README.md is skipped as brave does.
__brave_copy_tree() {
	local from="$1" to="$2"
	[[ -d "${from}" ]] || return 0
	mkdir -p "${to}"
	(cd "${from}" && find . -type f ! -name README.md -exec cp --parents -f -t "${to}" {} +)
}

# Copy the single file $1 to $2, creating the parent directory.
__brave_copy_file() {
	[[ -f "$1" ]] || return 0
	install -Dm644 "$1" "$2"
}

# Port of update() in brave-core's build/commands/lib/branding.js (stable channel).
# brave's own tooling (npm run sync/build) overlays the branded resources, strings and
# BRANDING files from brave/ onto chromium's tree. This package doesn't run that tooling,
# so do the same here. gn needs e.g. chrome/app/theme/brave/BRANDING.
__brave_update_branding() {
	local src="${TERMUX_PKG_SRCDIR}"
	local brave="${TERMUX_PKG_SRCDIR}/brave"
	local branding scale f name

	for branding in brave brave_origin; do
		# Branded theme, strings, icons.
		__brave_copy_tree "${brave}/app/theme/${branding}" "${src}/chrome/app/theme/${branding}"
		for scale in default_100_percent default_200_percent; do
			__brave_copy_tree "${brave}/app/theme/${scale}/${branding}" \
				"${src}/chrome/app/theme/${scale}/${branding}"
		done
		__brave_copy_file "${brave}/app/${branding}_strings.grd" "${src}/chrome/app/${branding}_strings.grd"
		__brave_copy_file "${brave}/components/components_${branding}_strings.grd" \
			"${src}/components/components_${branding}_strings.grd"
		__brave_copy_tree "${brave}/components/vector_icons/${branding}" \
			"${src}/components/vector_icons/${branding}"
		__brave_copy_file "${brave}/chromium_src/chrome/installer/setup/${branding}_behaviors.cc" \
			"${src}/chrome/installer/setup/${branding}_behaviors.cc"
	done
	__brave_copy_file "${brave}/app/settings_brave_strings.grdp" "${src}/chrome/app/settings_brave_strings.grdp"

	# Translations, and brave's versions of chromium's grd/grdp files.
	__brave_copy_tree "${brave}/app/resources" "${src}/chrome/app/resources"
	__brave_copy_tree "${brave}/components/strings" "${src}/components/strings"
	for f in "${brave}"/app/*.grd "${brave}"/app/*.grdp; do
		name="$(basename "${f}")"
		[[ -f "${src}/chrome/app/${name}" ]] && cp -f "${f}" "${src}/chrome/app/${name}"
	done
	for f in "${brave}"/components/*.grd; do
		name="$(basename "${f}")"
		[[ -f "${src}/components/${name}" ]] && cp -f "${f}" "${src}/components/${name}"
	done

	# Files that replace chromium's ones in-place.
	__brave_copy_tree "${brave}/build/chromium/resources" "${src}"

	# Product logos for the about:version page.
	for scale in default_100_percent default_200_percent; do
		local logos="${brave}/app/theme/${scale}/brave"
		local dest="${src}/components/resources/${scale}/chromium"
		__brave_copy_file "${logos}/product_logo_name_48.png" "${dest}/product_logo.png"
		__brave_copy_file "${logos}/product_logo_white.png" "${dest}/product_logo_white.png"
		__brave_copy_file "${logos}/product_logo_16.png" "${dest}/favicon_product.png"
	done

	# Omnibox product icons.
	local omnibox="${brave}/components/omnibox/browser/vector_icons/brave"
	local omnibox_dest="${src}/components/omnibox/browser/vector_icons"
	__brave_copy_file "${omnibox}/product.icon" "${omnibox_dest}/product_old.icon"
	__brave_copy_file "${omnibox}/product.icon" "${omnibox_dest}/chrome_product.icon"
	__brave_copy_file "${omnibox}/product_chrome_refresh.icon" "${omnibox_dest}/product_chrome_refresh_old.icon"

	# WebUI fonts, logo and bookmark icon (the latter two come from @brave/leo in node_modules).
	local leo="${brave}/node_modules/@brave/leo/icons"
	__brave_copy_file "${brave}/ui/webui/resources/css/text_defaults_md.css" \
		"${src}/ui/webui/resources/css/text_defaults_md.css"
	__brave_copy_file "${leo}/brave-icon-release-color.svg" "${src}/ui/webui/resources/images/chrome_logo_dark.svg"
	__brave_copy_file "${leo}/browser-bookmark-normal.svg" "${src}/ui/webui/resources/images/icon_bookmark.svg"

	[[ -f "${src}/chrome/app/theme/brave/BRANDING" ]] ||
		termux_error_exit "Brave branding update failed: chrome/app/theme/brave/BRANDING is missing."
}
