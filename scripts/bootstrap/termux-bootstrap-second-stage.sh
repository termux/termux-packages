#!@TERMUX_PREFIX@/bin/bash
# shellcheck shell=bash

export TERMUX_PREFIX="@TERMUX_PREFIX@"
export TERMUX_PACKAGE_MANAGER="@TERMUX_PACKAGE_MANAGER@"
export TERMUX_PACKAGE_ARCH="@TERMUX_PACKAGE_ARCH@"

function log() { echo "[*]" "$@"; }
function log_error() { echo "[*]" "$@" 1>&2; }

show_help() {

	cat <<'HELP_EOF'
termux-bootstrap-second-stage.sh runs the second stage of Termux
bootstrap installation.


Usage:
  termux-bootstrap-second-stage.sh


Available command_options:
  [ -h | --help ]    Display this help screen.



The Termux app runs the bootstrap installion first stage by extracting
the bootstrap packages manually to the Termux rootfs directory under
private app data directory `/data/data/<package_name>` without using
the package managers like (`apt`/`dpkg` or `pacman`) to install
packages, as they are also part of the bootstrap.
Due to manual extraction, package configuration may not be properly
done, like running of maintainers sciprts like `preinst` and
`postinst`. Therefore, `termux-bootstrap-second-stage.sh` is run after
extraction to finish package configuration. The output of second stage
will get logged to Android `logcat` by the app.

Currently, only `postinst` scripts are run.
Running `preinst` scripts is not possible without an actual rootfs,
and support for running special scripts after extraction would need to
be written to handle packages that do require it.

If maintainer scripts of all packages are executed successfully,
`termux-bootstrap-second-stage.sh` will exit with exit code `0`,
otherwise with the exit code returned by the last failed script or
that of any other failure.

The second stage can only be run once in the complete lifetime of the
rootfs and running it again may put the rootfs in an inconsistent
state, so it is not allowed by default. This is done by creating the
`termux-bootstrap-second-stage.sh.lock` file as a symlink in the
same directory as `termux-bootstrap-second-stage.sh` file as that is
an atomic operation and only the first instance of
`termux-bootstrap-second-stage.sh` that creates it will be able to run
the second stage and other instances will fail. The lock file is never
deleted under normall operation. If rootfs directory is ever wiped,
then lock file will be deleted along with it as it exists under it,
and when bootstrap is setup again, second stage will be able to run
again. The `$TMPDIR` is not used for the lock file as that is often
deleted in the lifetime of the rootfs. If for some reason, second
stage must be force run again (not recommended), like in case of
previous failure and it must be re-run again for testing, then delete
the lock file manually and run `termux-bootstrap-second-stage.sh`
again.

**See Also:**
- https://github.com/termux/termux-packages/wiki/For-maintainers#bootstraps
HELP_EOF

}

main() {

	local return_value

	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		show_help || return $?
		return 0
	else
		run_bootstrap_second_stage "$@"
		return_value=$?
		if [ $return_value -eq 64 ]; then # EX__USAGE
			echo ""
			show_help
		fi
		return $return_value
	fi

}

run_bootstrap_second_stage() {

	local return_value

	if ! ln -s "termux-bootstrap-second-stage.sh" \
		"@TERMUX_BOOTSTRAP_CONFIG_DIR_PATH@/termux-bootstrap-second-stage.sh.lock" 2>/dev/null; then
		log "The termux bootstrap second stage has already been run before and cannot be run again."
		log "If you still want to force run it again (not recommended), \
like in case of previous failure and it must be re-run again for testing, \
then delete the '@TERMUX_BOOTSTRAP_CONFIG_DIR_PATH@/termux-bootstrap-second-stage.sh.lock' \
file manually and run 'termux-bootstrap-second-stage.sh' again."
		return 0
	fi

	log "Running termux bootstrap second stage"
	run_bootstrap_second_stage_inner
	return_value=$?
	if [ $return_value -ne 0 ]; then
		log_error "Failed to run termux bootstrap second stage"
		return $return_value
	fi

	log "The termux bootstrap second stage completed successfully"

	return 0

}

run_bootstrap_second_stage_inner() {

	local return_value

	log "Running postinst maintainer scripts"
	run_package_postinst_maintainer_scripts
	return_value=$?
	if [ $return_value -ne 0 ]; then
		log_error "Failed to run postinst maintainer scripts"
		return $return_value
	fi

	return 0

}

run_package_postinst_maintainer_scripts() {

	local return_value

	local package_name
	local package_version
	local package_dir
	local package_dir_basename
	local script_path
	local script_basename

	if [ "${TERMUX_PACKAGE_MANAGER}" = "apt" ]; then
		# - https://www.debian.org/doc/debian-policy/ch-maintainerscripts
		# - https://manpages.debian.org/testing/dpkg-dev/deb-postinst.5.en.html

		# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/script.c#L178-L206
		# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/script.c#L107
		if [ -d "${TERMUX_PREFIX}/var/lib/dpkg/info" ]; then
			local dpkg_version

			dpkg_version=$(dpkg --version | head -n 1 | sed -E 's/.*version ([^ ]+) .*/\1/')
			if [[ ! "$dpkg_version" =~ ^[0-9].*$ ]]; then
				log_error "Failed to find the 'dpkg' version"
				log_error "$dpkg_version"
				return 1
			fi

			# Check `dpkg --force-help` for current defaults.
			# If they ever change, this will need to be updated.
			# Currently, we are not parsing command output.
			# - https://manpages.debian.org/testing/dpkg/dpkg.1.en.html#force~2
			local dpkg_force_things="security-mac,downgrade"

			# - https://manpages.debian.org/testing/dpkg/dpkg.1.en.html#D
			# - https://manpages.debian.org/unstable/dpkg/dpkg.1.en.html#DPKG_DEBUG
			# - https://manpages.debian.org/testing/dpkg/dpkg.1.en.html#DPKG_MAINTSCRIPT_DEBUG
			# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/script.c#L189
			# - https://github.com/guillemj/dpkg/blob/1.22.6/lib/dpkg/debug.c#L123
			# - https://github.com/guillemj/dpkg/blob/1.22.6/lib/dpkg/debug.h#L43
			local dbg_scripts=02
			local maintscript_debug=0
			if [[ "$DPKG_DEBUG" =~ ^0[0-7]{1,6}$ ]] && [[ "$(( DPKG_DEBUG & dbg_scripts ))" != "0" ]]; then
				maintscript_debug=1
			fi

			for script_path in "${TERMUX_PREFIX}/var/lib/dpkg/info/"*.postinst; do
				script_basename="${script_path##*/}"
				package_name="${script_basename::-9}"

				log "Running '$package_name' package postinst"

				# Execute permissions do not exist for maintainer
				# scripts in bootstrap zips and since files are
				# extracted manually by termux-app, they need to be
				# assigned here, like `dpkg` does.
				chmod u+x "$script_path" || return $?

				(
					# As per `dpkg` `script.c`:
					# >Switch to a known good directory to give the
					# >maintainer script a saner environment.
					# The current working directory is handled the
					# following way:
					# - By default rootfs `/` is used.
					# - If `$DPKG_ROOT` is set to an alternate rootfs
					#   path:
					#   - If `--force-script-chrootless` flag is not
					#     passed, then `$DPKG_ROOT` is chrooted into
					#     and then the current working directory is
					#     changed to `/`.
					#   - If flag is passed, then chroot is not done
					#     and only the current working directory is
					#     changed to `$DPKG_ROOT`.
					# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/script.c#L99-L130
					# - https://github.com/guillemj/dpkg/blob/1.22.6/lib/dpkg/fsys-dir.c#L86
					# - https://github.com/guillemj/dpkg/blob/1.22.6/lib/dpkg/fsys-dir.c#L33
					# - https://github.com/guillemj/dpkg/blob/1.22.6/src/common/force.c#L146-L149
					# - https://github.com/guillemj/dpkg/blob/1.22.6/src/common/force.c#L348
					# - https://manpages.debian.org/unstable/dpkg/dpkg.1.en.html#DPKG_FORCE
					# - https://wiki.debian.org/Teams/Dpkg/Spec/InstallBootstrap#Detached_chroot_handling
					# Termux by default does not set `$DPKG_ROOT` and
					# does not pass the `--force-script-chrootless`
					# flag, so only current working directory is
					# changed to the Android rootfs `/`.
					# Moreover, Android apps cannot run chroot
					# without root access, so `$DPKG_ROOT` cannot be
					# normally used without `--force-script-chrootless`
					# flag.
					# Note that Termux rootfs is under private app
					# data directory `/data/data/<package_name>,`
					# which may cause problems for packages which try
					# to use Android rootfs paths instead of Termux
					# rootfs paths.
					cd / || exit $?

					# Export internal environment variables that
					# `dpkg` exports for maintainer scripts.
					# - https://manpages.debian.org/testing/dpkg/dpkg.1.en.html#Internal_environment
					# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/main.c#L751-L759
					# - https://github.com/guillemj/dpkg/blob/1.22.6/src/main/script.c#L191-L197
					export DPKG_MAINTSCRIPT_PACKAGE="$package_name"
					export DPKG_MAINTSCRIPT_PACKAGE_REFCOUNT="1"
					export DPKG_MAINTSCRIPT_ARCH="$TERMUX_PACKAGE_ARCH"
					export DPKG_MAINTSCRIPT_NAME="postinst"
					export DPKG_MAINTSCRIPT_DEBUG="$maintscript_debug"
					export DPKG_RUNNING_VERSION="$dpkg_version"
					export DPKG_FORCE="$dpkg_force_things"
					export DPKG_ADMINDIR="${TERMUX_PREFIX}/var/lib/dpkg"
					export DPKG_ROOT=""

					# > The maintainer scripts must be proper executable
					# > files; if they are scripts (which is recommended),
					# > they must start with the usual `#!` convention.
					# Execute it directly instead of with a shell,
					# and exit with failure if it fails as that
					# implies that bootstrap setup failed.
					# The first argument is `configure`.
					# The package version is the second argument
					# if package is being upgraded, but not for first
					# installation, so don't pass it.
					# Check `deb-postinst(5)` for more info.
					"$script_path" configure
					return_value=$?
					if [ $return_value -ne 0 ]; then
						log_error "Failed to run '$package_name' package postinst"
						exit $return_value
					fi
				) || return $?

			done
		fi



	elif [ ${TERMUX_PACKAGE_MANAGER} = "pacman" ]; then
		# - https://wiki.archlinux.org/title/PKGBUILD#install
		# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/add.c#L638-L647
		if [ -d "${TERMUX_PREFIX}/var/lib/pacman/local" ]; then
			# Package install files exist at `/var/lib/pacman/local/package-version/install`
			for script_path in "${TERMUX_PREFIX}/var/lib/pacman/local/"*/install; do
				package_dir="${script_path::-8}"
				package_dir_basename="${package_dir##*/}"

				# Extract package `version` in the format `epoch:pkgver-pkgrel`
				# from the package_dir_basename in the format `package-version`.
				# Do not use external programs to parse as that would require
				# adding it as a dependency for second-stage.
				# - https://wiki.archlinux.org/title/PKGBUILD#Version
				# Set to anything after last dash "-"
				local package_version_pkgrel="${package_dir_basename##*-}"
				# Set to anything before and including last dash "-"
				local package_name_and_version_pkgver="${package_dir_basename%"$package_version_pkgrel"}"
				# Trim trailing dash "-"
				package_name_and_version_pkgver="${package_name_and_version_pkgver%?}"
				# Set to anything after last dash "-"
				local package_version_pkgver="${package_name_and_version_pkgver##*-}"
				# Combine pkgver and pkgrel
				package_version="$package_version_pkgver-$package_version_pkgrel"
				if [[ ! "$package_version" =~ ^([0-9]+:)?[^-]+-[^-]+$ ]]; then
					log_error "The package_version '$package_version' extracted from package_dir_basename '$package_dir_basename' is not valid"
					return 1
				fi

				log "Running '$package_dir_basename' package post_install"

				(
					# As per `pacman` install docs:
					# > Each function is run chrooted inside the pacman install directory. See this thread.
					# The `RootDir` is chrooted into and then the
					# current working directory is changed to `/`.
					# - https://bbs.archlinux.org/viewtopic.php?pid=913891
					# - https://man.archlinux.org/man/pacman.conf.5.en#OPTIONS
					# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/src/pacman/conf.c#L855
					# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/alpm.c#L47
					# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/alpm.h#L1663-L1676
					# - https://gitlab.archlinux.org/pacman/pacman/-/blob/v6.1.0/lib/libalpm/util.c#L657-L668
					# - https://man7.org/linux/man-pages/man2/chroot.2.html
					# But since Android apps cannot run chroot
					# without root access, chroot is disabled by
					# Termux pacman package and only current working
					# directory is changed to the Android rootfs `/`.
					# Note that Termux rootfs is under private app
					# data directory `/data/data/<package_name>,`
					# which may cause problems for packages which try
					# to use Android rootfs paths instead of Termux
					# rootfs paths.
					# - https://github.com/termux/termux-packages/blob/953b9f2aac0dc94f3b99b2df6af898e0a95d5460/packages/pacman/util.c.patch
					cd "/" || exit $?

					# Source the package `install` file and execute
					# `post_install` function if defined.

					# Unset function if already defined in the env
					unset -f post_install || exit $?

					# shellcheck disable=SC1090
					source "$script_path"
					return_value=$?
					if [ $return_value -ne 0 ]; then
						log_error "Failed to source '$package_dir_basename' package install install"
						exit $return_value
					fi

					if [[ "$(type -t post_install 2>/dev/null)" == "function" ]]; then
						# cd again in case install file sourced changed the directory.
						cd "/" || exit $?

						# Execute the post_install function and exit
						# with failure if it fails as that implies
						# that bootstrap setup failed.
						# The package version is the first argument.
						# Check `PKGBUILD#install` docs for more info.
						post_install "$package_version"
						return_value=$?
						if [ $return_value -ne 0 ]; then
							log_error "Failed to run '$package_dir_basename' package post_install"
							exit $return_value
						fi
					fi
				) || return $?
			done
		fi
	fi

	return 0

}

# If running in bash, run script logic, otherwise exit with usage error
if [ -n "${BASH_VERSION:-}" ]; then
	# If script is sourced, return with error, otherwise call main function
	# - https://stackoverflow.com/a/28776166/14686958
	# - https://stackoverflow.com/a/29835459/14686958
	if (return 0 2>/dev/null); then
		echo "${0##*/} cannot be sourced as \"\$0\" is required." 1>&2
		return 64 # EX__USAGE
	else
		main "$@"
		exit $?
	fi
else
	(echo "${0##*/} must be run with the bash shell."; exit 64) # EX__USAGE
fi
