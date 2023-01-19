TERMUX_PKG_HOMEPAGE=https://neovim.io
TERMUX_PKG_DESCRIPTION="Ambitious Vim-fork focused on extensibility and agility (nvim-nightly)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Aditya Alok <alok@termux.org>"
# Upstream now has version number like "0.8.0-dev-698-ga5920e98f", but actually
# "0.8.0-dev-698-g1ef84547a" < "0.8.0-dev-nightly-10-g1a07044c1", we need to bump
# the epoch of the package version.
TERMUX_PKG_VERSION="1:0.9.0-dev-746+g42e9a09a4"
TERMUX_PKG_SRCURL="https://github.com/neovim/neovim/archive/nightly.tar.gz"
TERMUX_PKG_SHA256=1df6e8124021f81fdfb713fa50431f2db7d1ed9b395968df3b684ed629edd6c6
TERMUX_PKG_DEPENDS="libiconv, libuv, luv, libmsgpack, libandroid-support, libvterm, libtermkey, libluajit, libunibilium, libtreesitter"
TERMUX_PKG_HOSTBUILD=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=RelWithDebInfo
-DENABLE_JEMALLOC=OFF
-DGETTEXT_MSGFMT_EXECUTABLE=$(command -v msgfmt)
-DGETTEXT_MSGMERGE_EXECUTABLE=$(command -v msgmerge)
-DGPERF_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/gperf
-DLUA_PRG=$TERMUX_PKG_HOSTBUILD_DIR/deps/usr/bin/luajit
-DPKG_CONFIG_EXECUTABLE=$(command -v pkg-config)
-DXGETTEXT_PRG=$(command -v xgettext)
-DLUAJIT_INCLUDE_DIR=$TERMUX_PREFIX/include/luajit-2.1
-DCOMPILE_LUA=OFF
"
TERMUX_PKG_CONFFILES="share/nvim/sysinit.vim"
TERMUX_PKG_CONFLICTS="neovim"

TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	# Scrap and parse github release page to get version of nightly build.
	# Neovim just uses 'nightly' tag for release, not version, therefore cannot use github api.
	local curl_response
	curl_response=$(
		curl \
			--silent \
			"https://github.com/neovim/neovim/releases/tag/nightly" \
			--write-out '|%{http_code}'
	) || {
		local http_code="${curl_response##*|}"
		if [[ "${http_code}" != "200" ]]; then
			echo "Error: failed to get latest neovim-nightly tag page."
			echo -e "http code: ${http_code}\ncurl response: ${curl_response}"
			exit 1
		fi
	}

	# this outputs in the following format: "0.8.0-dev-698-ga5920e98f"
	local remote_nvim_version
	remote_nvim_version=$(
		echo "$curl_response" \
			| cut -d"|" -f1 | grep -oP '<pre class="notranslate"><code>NVIM v\K.*'
	)

	if [ -z "$remote_nvim_version" ]; then
		echo "ERROR: No version found in nightly page."
		return 1
	fi

	remote_nvim_version="$(grep -oP '^\d+\.\d+\.\d+-dev-\d+\+g[0-9a-f]+' <<< "$remote_nvim_version" || true)"

	if [ -z "$remote_nvim_version" ]; then
		echo "WARNING: Version in nightly page is not in expected format. Skipping auto-update."
		echo "remote_nvim_version: $remote_nvim_version"
		return 0
	fi

	# since we are using a nightly build, therefore no need to check for version increment/decrement.
	if [ "${TERMUX_PKG_VERSION#*:}" != "${remote_nvim_version}" ]; then
		termux_pkg_upgrade_version "${remote_nvim_version}" --skip-version-check
	else
		echo "INFO: No update available."
	fi
}

_patch_luv() {
	# git submodule update --init deps/lua-compat-5.3 failed
	cp -r $1/build/src/lua-compat-5.3/* $1/build/src/luv/deps/lua-compat-5.3/
	cp -r $1/build/src/luajit/* $1/build/src/luv/deps/luajit/
	cp -r $1/build/src/libuv/* $1/build/src/luv/deps/libuv/
}

termux_step_host_build() {
	termux_setup_cmake

	TERMUX_ORIGINAL_CMAKE=$(command -v cmake)
	if [ ! -f "$TERMUX_ORIGINAL_CMAKE.orig" ]; then
		mv "$TERMUX_ORIGINAL_CMAKE" "$TERMUX_ORIGINAL_CMAKE.orig"
	fi
	cp "$TERMUX_PKG_BUILDER_DIR/custom-bin/cmake" "$TERMUX_ORIGINAL_CMAKE"
	chmod +x "$TERMUX_ORIGINAL_CMAKE"
	export TERMUX_ORIGINAL_CMAKE="$TERMUX_ORIGINAL_CMAKE.orig"

	mkdir -p $TERMUX_PKG_HOSTBUILD_DIR/deps
	cd $TERMUX_PKG_HOSTBUILD_DIR/deps
	cmake $TERMUX_PKG_SRCDIR/cmake.deps

	make -j 1 \
		|| (_patch_luv $TERMUX_PKG_HOSTBUILD_DIR/deps && make -j 1)

	cd $TERMUX_PKG_SRCDIR

	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install \
		|| (_patch_luv $TERMUX_PKG_SRCDIR/.deps && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$TERMUX_PKG_HOSTBUILD_DIR -DUSE_BUNDLED_LUAROCKS=ON" install)

	make distclean
	rm -Rf build/

	cd $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLUA_MATH_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$TERMUX_HOST_PLATFORM/$TERMUX_PKG_API_LEVEL/libm.so"
}

termux_step_post_make_install() {
	local _CONFIG_DIR=$TERMUX_PREFIX/share/nvim
	mkdir -p $_CONFIG_DIR
	cp $TERMUX_PKG_BUILDER_DIR/sysinit.vim $_CONFIG_DIR/
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				update-alternatives --install \
					$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/nvim 40
				update-alternatives --install \
					$TERMUX_PREFIX/bin/vi vi $TERMUX_PREFIX/bin/nvim 15
			fi
		fi
	EOF

	cat <<- EOF > ./prerm
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				update-alternatives --remove editor $TERMUX_PREFIX/bin/nvim
				update-alternatives --remove vi $TERMUX_PREFIX/bin/nvim
			fi
		fi
	EOF
}
