TERMUX_PKG_HOMEPAGE="https://helix-editor.com/"
TERMUX_PKG_DESCRIPTION="A post-modern modal text editor written in rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="MrAdityaAlok <dev.aditya.alok@gmail.com>"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/helix-editor/helix.git"
TERMUX_PKG_GIT_BRANCH="v$TERMUX_PKG_VERSION"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust

	sed -i "s%\@TERMUX_CC\@%${CC}%g" ./helix-syntax/build.rs

	cargo build --jobs "${TERMUX_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

	cat > "hx" <<- EOF
	#!${TERMUX_PREFIX}/bin/sh

	HELIX_RUNTIME=${TERMUX_PREFIX}/lib/helix/runtime \\
	exec ${TERMUX_PREFIX}/lib/helix/hx "\$@"
	EOF
	install -Dm755 ./hx "${TERMUX_PREFIX}/bin/hx"

	mkdir -p "${TERMUX_PREFIX}/lib/helix"

	cp -r runtime "${TERMUX_PREFIX}/lib/helix"

	install -Dm755 -t "${TERMUX_PREFIX}/lib/helix" "target/${CARGO_TARGET_NAME}/release/hx"
	install -Dm666 -t "${TERMUX_PREFIX}/lib/helix" languages.toml
}

termux_step_create_debscripts() {
	cat > postinst <<- EOF
	#!${TERMUX_PREFIX}/bin/bash

	if ! test -f "${TERMUX_ANDROID_HOME}/.config/helix/languages.toml"; then
		mkdir -p "${TERMUX_ANDROID_HOME}/.config/helix"
		cp "${TERMUX_PREFIX}/lib/helix/languages.toml" "${TERMUX_ANDROID_HOME}/.config/helix"
		echo -e "User modifiable \e[36mlanguages.toml\e[39m file is at ${TERMUX_ANDROID_HOME}/.config/helix"
	fi
	EOF
}
