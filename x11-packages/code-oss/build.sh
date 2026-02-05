TERMUX_PKG_HOMEPAGE=https://github.com/microsoft/vscode
TERMUX_PKG_DESCRIPTION="Visual Studio Code - OSS"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="1.109.0"
TERMUX_PKG_SRCURL=git+https://github.com/microsoft/vscode
TERMUX_PKG_GIT_BRANCH="$TERMUX_PKG_VERSION"
TERMUX_PKG_DEPENDS="electron-for-code-oss, libx11, libxkbfile, libsecret, ripgrep"
TERMUX_PKG_BUILD_DEPENDS="electron-headers-for-code-oss"
TERMUX_PKG_ANTI_BUILD_DEPENDS="electron-for-code-oss"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_NO_STRIP=true
TERMUX_PKG_HOSTBUILD=true
# Chromium doesn't support i686 on Linux.
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

_setup_nodejs_22() {
	local NODEJS_VERSION=22.21.1
	local NODEJS_FOLDER=${TERMUX_PKG_CACHEDIR}/build-tools/nodejs-${NODEJS_VERSION}

	if [ ! -x "$NODEJS_FOLDER/bin/node" ]; then
		mkdir -p "$NODEJS_FOLDER"
		local NODEJS_TAR_FILE=$TERMUX_PKG_TMPDIR/nodejs-$NODEJS_VERSION.tar.xz
		termux_download https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.xz \
			"$NODEJS_TAR_FILE" \
			680d3f30b24a7ff24b98db5e96f294c0070f8f9078df658da1bce1b9c9873c88
		tar -xf "$NODEJS_TAR_FILE" -C "$NODEJS_FOLDER" --strip-components=1
	fi
	export PATH="$NODEJS_FOLDER/bin:$PATH"
}

termux_step_post_get_source() {
	# Ensure that code-oss supports node 22
	local _node_version=$(cat .nvmrc | cut -d. -f1 -)
	if [ "$_node_version" != 22 ]; then
		termux_error_exit "Version mismatch: Expected 22, got $_node_version."
	fi

	# Check whether the prebuilt electron version matches the electron version from package.json
	local _electron_verion="$(jq -r '.devDependencies.electron' $TERMUX_PKG_SRCDIR/package.json)"
	local _header_version="$(. $TERMUX_SCRIPTDIR/x11-packages/electron-host-tools-for-code-oss/build.sh; echo $TERMUX_PKG_VERSION)"
	if [ "$_electron_verion" != "$_header_version" ]; then
		termux_error_exit "Version mismatch: version in package.json is $_electron_verion, prebuilt electron version $_header_version."
	fi

	# Use custom node-native-keymap
	local _native_keymap_verion="$(jq -r ".dependencies.\"native-keymap\"" package.json | cut -d'^' -f2)"
	local _native_keymap_src_url="https://registry.npmjs.org/native-keymap/-/native-keymap-$_native_keymap_verion.tgz"
	local _native_keymap_sha256sum="SKIP_CHECKSUM"
	local _native_keymap_path="$TERMUX_PKG_CACHEDIR/$(basename $_native_keymap_src_url)"
	termux_download $_native_keymap_src_url $_native_keymap_path $_native_keymap_sha256sum
	mkdir -p $TERMUX_PKG_SRCDIR/node-native-keymap-src
	tar -xf $_native_keymap_path -C $TERMUX_PKG_SRCDIR/node-native-keymap-src --strip-components=1

	# Replace package.json
	jq ".dependencies.\"native-keymap\" = \"file:./node-native-keymap-src\"" package.json > package.json.tmp && mv package.json.tmp package.json
}

termux_step_host_build() {
	_setup_nodejs_22
	export DISABLE_V8_COMPILE_CACHE=1
	(unset PREFIX prefix
	npm install node-gyp)
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_configure() {
	_setup_nodejs_22
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/node_modules/.bin:$PATH"
}

termux_step_make() {
	unset PREFIX prefix

	if [ $TERMUX_ARCH = "arm" ]; then
		export NPM_CONFIG_ARCH=arm
		CODE_ARCH=armhf
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		export NPM_CONFIG_ARCH=x64
		CODE_ARCH=x64
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		export NPM_CONFIG_ARCH=arm64
		CODE_ARCH=arm64
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi
	export npm_config_arch=$NPM_CONFIG_ARCH
	export npm_config_nodedir=$TERMUX_PREFIX/lib/code-oss/node_headers

	export CXX="$CXX -v -L$TERMUX_PREFIX/lib"
	export CXXFLAGS="$CXXFLAGS -DSPDLOG_USE_STD_FORMAT=1"

	export DISABLE_V8_COMPILE_CACHE=1
	npm install
	npm run gulp vscode-linux-$CODE_ARCH-min
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/code-oss

	# Copy resources
	rm -rf $TERMUX_PREFIX/lib/code-oss/resources/
	mkdir -p $TERMUX_PREFIX/lib/code-oss/resources/
	cp -r --no-preserve=ownership --preserve=mode package-build-root/VSCode-linux-$CODE_ARCH/resources/* $TERMUX_PREFIX/lib/code-oss/resources/

	# Install the start script
	mkdir -p $TERMUX_PREFIX/lib/code-oss/bin
	cp package-build-root/VSCode-linux-$CODE_ARCH/bin/code-oss $TERMUX_PREFIX/lib/code-oss/bin/code-oss
	sed -i "s|/usr/bin|$TERMUX_PREFIX/bin|g
			s|/usr/share/code-oss|$TERMUX_PREFIX/lib/code-oss|g
			s|/proc/version|/dev/null|g" $TERMUX_PREFIX/lib/code-oss/bin/code-oss
	chmod +x $TERMUX_PREFIX/lib/code-oss/bin/code-oss

	# Replace ripgrep
	ln -sfr $TERMUX_PREFIX/bin/rg $TERMUX_PREFIX/lib/code-oss/resources/app/node_modules/@vscode/ripgrep/bin/rg

	# Install appdata and desktop file
	sed -i "s|@@NAME_SHORT@@|Code|g
			s|@@NAME_LONG@@|Code - OSS|g
			s|@@NAME@@|code-oss|g
			s|@@ICON@@|com.visualstudio.code.oss|g
			s|@@EXEC@@|$TERMUX_PREFIX/bin/code-oss|g
			s|@@LICENSE@@|MIT|g" resources/linux/code{.appdata.xml,-workspace.xml,.desktop,-url-handler.desktop}
	install -Dm600 resources/linux/code.appdata.xml $TERMUX_PREFIX/share/metainfo/code-oss.appdata.xml
	install -Dm600 resources/linux/code-workspace.xml $TERMUX_PREFIX/share/mime/packages/code-oss.workspace.xml
	install -Dm600 resources/linux/code.desktop $TERMUX_PREFIX/share/applications/code-oss.desktop
	install -Dm600 resources/linux/code-url-handler.desktop $TERMUX_PREFIX/share/applications/code-oss-url-handler.desktop
	install -Dm600 package-build-root/VSCode-linux-$CODE_ARCH/resources/app/resources/linux/code.png $TERMUX_PREFIX/share/pixmaps/com.visualstudio.code.oss.png

	# Install binaries to $PREFIX/bin
	ln -sfr $TERMUX_PREFIX/lib/code-oss/bin/code-oss $TERMUX_PREFIX/bin/code-oss
	ln -sfr $TERMUX_PREFIX/bin/code-oss $TERMUX_PREFIX/bin/code
	ln -sfr $TERMUX_PREFIX/bin/code-oss $TERMUX_PREFIX/bin/vscode

	# Install shell completions
	cp resources/completions/bash/code resources/completions/bash/code-oss
	cp resources/completions/bash/code resources/completions/bash/vscode
	cp resources/completions/zsh/_code resources/completions/zsh/_code-oss
	cp resources/completions/zsh/_code resources/completions/zsh/_vscode
	sed -i 's|@@APPNAME@@|code|g' resources/completions/{bash/code,zsh/_code}
	sed -i 's|@@APPNAME@@|vscode|g' resources/completions/{bash/vscode,zsh/_vscode}
	sed -i 's|@@APPNAME@@|code-oss|g' resources/completions/{bash/code-oss,zsh/_code-oss}
	install -Dm600 resources/completions/bash/code $TERMUX_PREFIX/share/bash-completion/completions/code
	install -Dm600 resources/completions/zsh/_code $TERMUX_PREFIX/share/zsh/site-functions/_code
	install -Dm600 resources/completions/bash/vscode $TERMUX_PREFIX/share/bash-completion/completions/vscode
	install -Dm600 resources/completions/zsh/_vscode $TERMUX_PREFIX/share/zsh/site-functions/_vscode
	install -Dm600 resources/completions/bash/code-oss $TERMUX_PREFIX/share/bash-completion/completions/code-oss
	install -Dm600 resources/completions/zsh/_code-oss $TERMUX_PREFIX/share/zsh/site-functions/_code-oss

	# Install license files
	mkdir -p $TERMUX_PREFIX/share/doc/code-oss
	cp package-build-root/VSCode-linux-$CODE_ARCH/resources/app/LICENSE.txt $TERMUX_PREFIX/share/doc/code-oss/LICENSE
	cp package-build-root/VSCode-linux-$CODE_ARCH/resources/app/ThirdPartyNotices.txt $TERMUX_PREFIX/share/doc/code-oss/ThirdPartyNotices.txt
}
