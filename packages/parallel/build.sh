TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/parallel/
TERMUX_PKG_DESCRIPTION="GNU Parallel is a shell tool for executing jobs in parallel using one or more machines"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240522"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/parallel/parallel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=67ed9fad31bf3e25f09d500e7e8ca7df9e3ac380fe4ebd16c6f014448a346928
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_pkg_auto_update() {
	local e=0
	local api_url="https://mirrors.kernel.org/gnu/parallel"
	local api_url_r=$(curl -s "${api_url}/")
	local r1=$(echo "${api_url_r}" | sed -nE 's|<.*>parallel-(.*).tar.bz2<.*>.*|\1|p')
	local latest_version=$(echo "${r1}" | sed -nE 's|([0-9]+)|\1|p' | tail -n1)
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		return
	fi
	[[ -z "${api_url_r}" ]] && e=1
	[[ -z "${r1}" ]] && e=1
	[[ -z "${latest_version}" ]] && e=1

	if [[ "${e}" != 0 ]]; then
		cat <<- EOL >&2
		WARN: Auto update failure!
		api_url_r=${api_url_r}
		r1=${r1}
		latest_version=${latest_version}
		EOL
		return
	fi

	local latest_tbz="${api_url}/parallel-latest.tar.bz2"
	local tmpdir=$(mktemp -d)
	curl -so "${tmpdir}/parallel-latest.tar.bz2" "${latest_tbz}"
	tar -xf "${tmpdir}/parallel-latest.tar.bz2" -C "${tmpdir}"
	if [[ ! -d "${tmpdir}/parallel-${latest_version}" ]]; then
		termux_error_exit "
		ERROR: Latest archive does not contain latest version
		$(ls -l "${tmpdir}")
		"
	fi

	rm -fr "${tmpdir}"

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_post_make_install() {
	install -Dm644 /dev/null "${TERMUX_PREFIX}"/share/bash-completion/completions/parallel

	mkdir -p "${TERMUX_PREFIX}"/share/zsh/site-functions
	cat <<- EOF > "${TERMUX_PREFIX}"/share/zsh/site-functions/_parallel
	#compdef parallel
	(( $+functions[_comp_parallel] )) ||
	eval "\$(parallel --shell-completion auto)" &&
	comp_parallel
	EOF
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
	#!${TERMUX_PREFIX}/bin/sh
	parallel --shell-completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/parallel
	EOF
}
