TERMUX_PKG_HOMEPAGE=https://crosvm.dev/book/
TERMUX_PKG_DESCRIPTION="ChromeOS Virtual Machine Monitor"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ef97559e74d91b83c636895da46bf9d4fba80f07
_COMMIT_DATE=20260508
_COMMIT_TIME=184306
TERMUX_PKG_VERSION="0.1.0.20260508.184306"
TERMUX_PKG_SRCURL=git+https://github.com/google/crosvm
TERMUX_PKG_GIT_BRANCH="main"
TERMUX_PKG_DEPENDS="libandroid-fexecve, libandroid-shmem, libcap, libwayland, libx11, libxext, virglrenderer"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# missing arch specific policies in jail/seccomp
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/google/crosvm/commits"
	local latest_commit=$(curl -s "${api_url}"| jq .[].sha | head -n1 | sed -e 's|\"||g')
	if [[ -z "${latest_commit}" ]]; then
		echo "WARN: Unable to get latest commit from upstream" >&2
		return
	fi
	if [[ "${latest_commit}" == "${_COMMIT}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi

	local latest_commit_date_tz=$(curl -s "${api_url}/${latest_commit}" | jq .commit.committer.date | sed -e 's|\"||g')
	if [[ -z "${latest_commit_date_tz}" ]]; then
		termux_error_exit "Unable to get latest commit date info"
	fi

	local latest_commit_date=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\1|' -e 's|\-||g')
	local latest_commit_time=$(echo "${latest_commit_date_tz}" | sed -e 's|\(.*\)T\(.*\)Z|\2|' -e 's|\:||g')
	local latest_crosvm_version=$(curl -s https://raw.githubusercontent.com/google/crosvm/${latest_commit}/Cargo.toml | grep ^version | sed "s|.*\"\(.*\)\"|\1|")

	# https://github.com/termux/termux-packages/issues/11827
	local latest_version="${latest_crosvm_version}.${latest_commit_date}.${latest_commit_time}"

	local current_date_epoch=$(date "+%s")
	local _COMMIT_DATE_epoch=$(date -d "${_COMMIT_DATE}" "+%s")
	local current_date_diff=$(((current_date_epoch-_COMMIT_DATE_epoch)/(60*60*24)))
	local cooldown_days=14
	if [[ "${current_date_diff}" -lt "${cooldown_days}" ]]; then
		cat <<- EOL
		INFO: Queuing updates since last push
		Cooldown (days) = ${cooldown_days}
		Days since      = ${current_date_diff}
		EOL
		return
	fi

	if ! dpkg --compare-versions "${latest_version}" gt "${TERMUX_PKG_VERSION}"; then
		termux_error_exit "
		ERROR: Resulting latest version is not counted as an update!
		Latest version  = ${latest_version}
		Current version = ${TERMUX_PKG_VERSION}
		"
	fi

	# unlikely to happen
	if [[ "${latest_commit_date}" -lt "${_COMMIT_DATE}" || \
		"${latest_commit_date}" -eq "${_COMMIT_DATE}" && "${latest_commit_time}" -lt "${_COMMIT_TIME}" ]]; then
		termux_error_exit "
		ERROR: Upstream is older than current package version!
		ERROR: Please report to upstream!
		"
	fi

	if [[ "${BUILD_PACKAGES}" == "false" ]]; then
		echo "INFO: package needs to be updated to ${latest_version}."
		return
	fi

	sed \
		-e "s|^_COMMIT=.*|_COMMIT=${latest_commit}|" \
		-e "s|^_COMMIT_DATE=.*|_COMMIT_DATE=${latest_commit_date}|" \
		-e "s|^_COMMIT_TIME=.*|_COMMIT_TIME=${latest_commit_time}|" \
		-i "${TERMUX_PKG_BUILDER_DIR}/build.sh"

	termux_pkg_upgrade_version "${latest_version}" --skip-version-check
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "${_COMMIT}"
	git submodule update --init --recursive --depth=1
	git clean -ffxd
}

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make() {
	local env_host=$(printf ${CARGO_TARGET_NAME} | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS="-L${TERMUX_PKG_BUILDDIR} -L${TERMUX_PREFIX}/lib"
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-Wl,-rpath=${TERMUX_PREFIX}/lib"
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-Wl,--enable-new-dtags"
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-Wl,--as-needed"

	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}/mlock2.c"
	"${AR}" rcu "${TERMUX_PKG_BUILDDIR}/libmlock2.a" mlock2.o
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-l:libmlock2.a"

	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-landroid-fexecve"
	export LDFLAGS+=" -landroid-fexecve"

	local extra_opt="--release"
	[[ "${TERMUX_DEBUG_BUILD}" == "true" ]] && extra_opt=""

	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--features geniezone,gunyah,halla,gpu,x,virgl_renderer \
		${extra_opt}
}

termux_step_make_install() {
	local profile="release"
	[[ "${TERMUX_DEBUG_BUILD}" == "true" ]] && profile="debug"

	echo "INFO: READELF = ${READELF} ... $(command -v ${READELF})"
	local crosvm_readelf=$(${READELF} -d target/${CARGO_TARGET_NAME}/${profile}/crosvm)
	local crosvm_runpath=$(echo "${crosvm_readelf}" | sed -ne "s|.*RUNPATH.*\[\(.*\)\].*|\1|p")
	if [[ "${crosvm_runpath}" != "${TERMUX_PREFIX}/lib" ]]; then
		termux_error_exit "
		Unexpected RUNPATH found. Check readelf output below:
		${crosvm_readelf}
		"
	fi

	install -Dm700 -t "${TERMUX_PREFIX}/bin" \
		"target/${CARGO_TARGET_NAME}/${profile}/crosvm"
}
