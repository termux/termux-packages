TERMUX_PKG_HOMEPAGE=https://gitlab.com/volian/nala
TERMUX_PKG_DESCRIPTION="Commandline frontend for the apt package manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.2"
TERMUX_PKG_SRCURL=https://gitlab.com/volian/nala/-/archive/v${TERMUX_PKG_VERSION}/nala-v${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=df7c5f7c6722277a2430cf086ae758dd822b09ac92786dcd63e669a13245206b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="apt, ca-certificates"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="var/log"

termux_step_pre_configure() {
	termux_setup_rust

	export CXXFLAGS_${CARGO_TARGET_NAME//-/_}="${CPPFLAGS} ${CXXFLAGS}"
	export CXXFLAGS+=" ${CPPFLAGS}"

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/rustls-platform-verifier \
		-exec rm -rf '{}' \;

	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'rustls-platform-verifier = { path = "./vendor/rustls-platform-verifier" }' >> Cargo.toml
}

termux_step_make() {
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX"/bin "target/${CARGO_TARGET_NAME}/release/nala"
}

termux_step_post_make_install() {
	find target -path '*/out/*.8' -exec install -Dm644 -t "$TERMUX_PREFIX"/share/man/man8/ {} +

	install -Dm644 -t "$TERMUX_PREFIX"/etc/nala nala.conf
	install -Dm644 debian/nala.fish "$TERMUX_PREFIX"/share/fish/vendor_completions.d/nala.fish
	install -Dm644 debian/nala.bash-completion "$TERMUX_PREFIX"/share/bash-completion/completions/nala
	install -Dm644 debian/_nala "$TERMUX_PREFIX"/share/zsh/site-functions/_nala
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/var/lib/nala
	mkdir -p $TERMUX_PREFIX/var/log/nala
	mkdir -p $TERMUX_PREFIX/var/lock
	EOF
}
