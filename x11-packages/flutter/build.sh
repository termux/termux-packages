TERMUX_PKG_HOMEPAGE=https://flutter.dev
TERMUX_PKG_DESCRIPTION="Google's UI toolkit for building apps for mobile, web and desktop from a single codebase"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.47.8"
TERMUX_PKG_SRCURL="git+https://github.com/flutter/flutter"
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="bash, dart, git, glibc-repo, unzip, which"
TERMUX_PKG_RECOMMENDS="chromium, glibc-runner, gradle, openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true
# Flutter tool has no 32-bit host support.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-regex
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+\.\d+$'

termux_step_make_install() {
	local flutter_home="${TERMUX_PREFIX}/opt/flutter"

	# The engine monorepo sources are not needed to run the tool.
	rm -rf "${TERMUX_PKG_SRCDIR}/engine" "${TERMUX_PKG_SRCDIR}/docs"

	mkdir -p "$(dirname "${flutter_home}")"
	rm -rf "${flutter_home}"
	cp -a "${TERMUX_PKG_SRCDIR}" "${flutter_home}"

	# The clone is detached at the release tag, flutter expects the stable channel branch.
	cd "${flutter_home}"
	git checkout --quiet -B stable
	# Flutter only accepts the .git form of the upstream URL.
	git remote set-url origin https://github.com/flutter/flutter.git
	# The tag-only clone has no refspec for branches, needed to track origin/stable.
	git config remote.origin.fetch "+refs/heads/stable:refs/remotes/origin/stable"
	git update-ref refs/remotes/origin/stable HEAD
	git branch --set-upstream-to=origin/stable stable

	# Dart for the build machine; the target dart cannot be executed here.
	termux_setup_dart

	# Fail early if this flutter pins a different dart than the one termux_setup_dart provides.
	local dart_version dart_revision
	dart_version="$(dart --version 2>&1 | grep -oP '\d+\.\d+\.\d+' | head -n 1)"
	dart_revision="$(sed -nE "s/.*'dart_revision': '([0-9a-f]+)'.*/\1/p" "${flutter_home}/DEPS")"
	if [[ "$(git ls-remote https://github.com/dart-lang/sdk.git "refs/tags/${dart_version}^{}" | cut -f1)" != "${dart_revision}" ]]; then
		termux_error_exit "Flutter ${TERMUX_PKG_VERSION} pins dart revision ${dart_revision}, not dart ${dart_version}."
	fi

	# Resolve pub packages into the install dir so package_config.json paths are valid on device.
	cd "${flutter_home}/packages/flutter_tools"
	export PUB_CACHE="${flutter_home}/.pub-cache"
	dart pub upgrade --suppress-analytics --no-precompile

	# A kernel file is architecture independent, unlike an app-jit snapshot.
	mkdir -p "${flutter_home}/bin/cache"
	dart compile kernel \
		--packages=.dart_tool/package_config.json \
		--output="${flutter_home}/bin/cache/flutter_tools.snapshot" \
		bin/flutter_tools.dart

	# Stamps make bin/internal/shared.sh skip pub upgrade and snapshot compilation on device.
	cd "${flutter_home}"
	echo "$(git rev-parse HEAD):" > bin/cache/flutter_tools.stamp
	touch packages/flutter_tools/pubspec.lock
	ln -sfn "${TERMUX_PREFIX}/lib/dart-sdk" bin/cache/dart-sdk
	cp bin/internal/engine.version bin/cache/engine-dart-sdk.stamp

	ln -sf ../opt/flutter/bin/flutter "${TERMUX_PREFIX}/bin/flutter"
}

termux_step_create_debscripts() {
	# Remove the runtime state (cache, downloaded engine artifacts) created after install.
	cat <<- EOF2 > ./postrm
		#!${TERMUX_PREFIX}/bin/sh
		if [ "\$1" = "remove" ] || [ "\$1" = "purge" ]; then
			rm -rf "${TERMUX_PREFIX}/opt/flutter"
		fi
	EOF2
	chmod 0755 ./postrm
}
