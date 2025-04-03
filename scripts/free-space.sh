#!/bin/sh

# This script clears about ~22G of space. It also sets up a swapfile to account
# for packages requiring large memory.

# Test:
# echo "Listing 100 largest packages after"
# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
# exit 0

create_swapfile() {
	sudo fallocate -l 4G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
}

if [ "${CI-false}" != "true" ]; then
	echo "ERROR: not running on CI, not deleting system files to free space!"
	exit 1
else
	# shellcheck disable=SC2046
	sudo apt purge -yq $(
		dpkg -l |
			grep '^ii' |
			awk '{ print $2 }' |
			grep -P '(mecab|linux-azure-tools-|aspnetcore|liblldb-|netstandard-|clang-tidy|clang-format|gfortran-|mysql-|google-cloud-cli|postgresql-|cabal-|dotnet-|ghc-|mongodb-|libmono|llvm-16|llvm-17)'
	)

	sudo apt purge -yq \
		snapd \
		kubectl \
		podman \
		ruby3.2-doc \
		mercurial-common \
		git-lfs \
		skopeo \
		buildah \
		vim \
		python3-botocore \
		azure-cli \
		powershell \
		shellcheck \
		firefox \
		google-chrome-stable \
		microsoft-edge-stable

	# Directories
	sudo rm -fr /opt/ghc /opt/hostedtoolcache /usr/share/dotnet /usr/share/swift
	sudo rm -rf /usr/local/graalvm/
	sudo rm -rf /usr/local/.ghcup/
	sudo rm -rf /usr/local/share/powershell
	sudo rm -rf /usr/local/share/chromium
	sudo rm -rf /usr/local/lib/node_modules
	# sudo rm -rf /usr/local/lib/android

	# https://github.com/actions/runner-images/issues/709#issuecomment-612569242
	sudo rm -rf "/usr/local/share/boost"
	sudo rm -rf "$AGENT_TOOLSDIRECTORY"

	# We shouldn't remove docker & it's images when running from `package_updates` workflow.
	if [ "${CLEAN_DOCKER_IMAGES-true}" = "true" ]; then
		sudo docker image prune --all --force
		sudo docker builder prune -a
		sudo apt purge -yq containerd.io
	fi

	sudo apt autoremove -yq
	sudo apt clean

	create_swapfile
fi
