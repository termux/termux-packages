TERMUX_PKG_HOMEPAGE=https://github.com/marin-m/SongRec
TERMUX_PKG_DESCRIPTION="Open-source, unofficial Shazam client"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.9"
TERMUX_PKG_SRCURL="https://github.com/marin-m/SongRec/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=11acaf4e8bfc296d4ea95245b3e9bc76139956e725f89d8a64b1db7e5a87535f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="gtk4, alsa-lib, openssl, ffmpeg, libc++, gettext, glib, pango, libcairo, dbus, hicolor-icon-theme, gdk-pixbuf, libadwaita, pulseaudio, libsoup3"

termux_step_make() {
	termux_setup_rust

	export GETTEXT_DIR="$PREFIX"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		local libintl_h="$TERMUX_PREFIX/include/libintl.h"
	else
		local libintl_h="$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/libintl.h"
	fi

	# compiles the libintl.h into a libintl.a that -lintl works on
	sed -e 's/__inline__//g' -e 's/^static//g' "$libintl_h" | "$CC" -O0 -x c -c -o libintl.o -
	ar cru libintl.a libintl.o
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	export RUSTFLAGS=$(env | grep "CARGO_TARGET_${env_host}_RUSTFLAGS" | cut -d'=' -f2-)
	RUSTFLAGS+=" -L${TERMUX_PKG_BUILDDIR} -C link-arg=-l:libintl.a"

	HOST_TRIPLET="$(gcc -dumpmachine)"
	PKG_CONFIG_PATH_x86_64_unknown_linux_gnu="$(grep 'DefaultSearchPaths:' "/usr/share/pkgconfig/personality.d/${HOST_TRIPLET}.personality" | cut -d ' ' -f 2)"
	export PKG_CONFIG_PATH_x86_64_unknown_linux_gnu

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/pulseaudio \
		-exec rm -rf '{}' \;

	git clone https://github.com/RustAudio/cpal.git vendor/cpal-git
	# remove eventually whenever a commit is no longer hardcoded in upstream's code
	git -C vendor/cpal-git checkout 0b2f18f

	find . vendor/{cpal-git,pulseaudio} -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e 's|"linux"|"android"|g'

	cat >> Cargo.toml <<-'EOF'

	[patch.crates-io]
	pulseaudio = { path = "./vendor/pulseaudio" }

	[patch."git+https://github.com/RustAudio/cpal.git"]
	cpal = { path = "./vendor/cpal-git" }
EOF

	local _release='--release'
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		_release=''
	fi

	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		$_release
}

termux_step_make_install() {
	local _dir='release'
	if [[ "$TERMUX_DEBUG_BUILD" == "true" ]]; then
		_dir='debug'
	fi
	install -Dm 755 "target/${CARGO_TARGET_NAME}/$_dir/songrec" "$TERMUX_PREFIX/bin/songrec"

	install -Dm 644 packaging/rootfs/usr/share/applications/re.fossplant.songrec.desktop \
					"$TERMUX_PREFIX/share/applications/re.fossplant.songrec.desktop"

	install -Dm 644 packaging/rootfs/usr/share/icons/hicolor/scalable/apps/re.fossplant.songrec.svg \
					"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/re.fossplant.songrec.svg"

	install -Dm 644 packaging/rootfs/usr/share/metainfo/re.fossplant.songrec.metainfo.xml \
					"$TERMUX_PREFIX/share/metainfo/re.fossplant.songrec.metainfo.xml"

	cp -r translations/locale -t "$TERMUX_PREFIX/share/"

	cp -r packaging/rootfs/usr/share/man -t "$TERMUX_PREFIX/share/"

	install -Dm 644 README.md -t "$TERMUX_PREFIX/share/doc/songrec"
}
