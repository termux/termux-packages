TERMUX_PKG_HOMEPAGE=https://flutter.dev
TERMUX_PKG_DESCRIPTION="Google's UI toolkit for building apps for mobile, web and desktop from a single codebase"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="3.47.8"
TERMUX_PKG_SRCURL="https://github.com/flutter/flutter/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7037a766eb079f41493a75af3a22ccb73bcd0f79b0f598484d77f0a8e3875985
TERMUX_PKG_DEPENDS="bash, dart, git, glibc-repo, unzip, which"
TERMUX_PKG_RECOMMENDS="chromium, glibc-runner, gradle, openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true
# Flutter tool has no 32-bit host support.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^\d+\.\d+\.\d+$'

termux_step_make_install() {
	local flutter_home="${TERMUX_PREFIX}/opt/flutter"

	# The engine monorepo sources are not needed to run the tool.
	rm -rf "${TERMUX_PKG_SRCDIR}/engine" "${TERMUX_PKG_SRCDIR}/docs"

	mkdir -p "$(dirname "${flutter_home}")"
	rm -rf "${flutter_home}"
	cp -a "${TERMUX_PKG_SRCDIR}" "${flutter_home}"

	# bin/flutter requires a git checkout, so create a minimal one with the release tag.
	cd "${flutter_home}"
	git init --quiet --initial-branch=stable
	git remote add origin https://github.com/flutter/flutter.git
	git add --force bin/internal/engine.version
	# File mtimes in the release tarball are the tag's commit time.
	local commit_date
	commit_date="$(date -u -d "@$(stat -c %Y bin/internal/engine.version)" +%Y-%m-%dT%H:%M:%SZ)"
	GIT_AUTHOR_DATE="${commit_date}" GIT_COMMITTER_DATE="${commit_date}" \
		git -c user.name=termux -c user.email=termux@localhost \
		commit --quiet -m "Flutter ${TERMUX_PKG_VERSION}"
	git tag "${TERMUX_PKG_VERSION}"
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
