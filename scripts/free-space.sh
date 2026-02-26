#!/bin/sh

# This script clears about ~36G of space.

# Test:
# echo "Listing 100 largest packages after"
# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
# exit 0

if [ "${CI-false}" != "true" ]; then
	echo "ERROR: not running on CI, not deleting system files to free space!"
	exit 1
else
	# shellcheck disable=SC2046
	sudo apt purge -yq --allow-remove-essential $(
		dpkg -l |
			grep '^ii' |
			awk '{ print $2 }' |
			grep -P '(mecab|linux-azure-tools-|aspnetcore|liblldb-|netstandard-|llvm|clang|gcc-12|gcc-13|cpp-|g\+\+-|temurin-|gfortran-|mysql-|google-cloud-cli|postgresql-|cabal-|dotnet-|ghc-|mongodb-|libmono|temurin-|mesa-|ant|liblua|python3|grub2-|grub-|shim-signed)'
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
		firefox
		# google-chrome-stable
		# microsoft-edge-stable already removed by the deps in the above apt purge

	# Directories
	sudo rm -rf /opt/ghc /opt/az /opt/hostedtoolcache /opt/actionarchivecache /opt/runner-cache
	sudo rm -rf /opt/pipx /usr/share/dotnet /usr/share/swift /usr/share/miniconda /usr/share/az_* /usr/share/gradle-* /usr/share/java /home/runner/.rustup
	sudo rm -rf /etc/skel /home/packer /home/linuxbrew
	sudo rm -rf /usr/local /usr/src/

	# https://github.com/actions/runner-images/issues/709#issuecomment-612569242
	sudo rm -rf "$AGENT_TOOLSDIRECTORY"

	sudo apt autoremove -yq
	sudo apt clean
	sudo rm -rf /var/lib/{apt,dpkg}
fi
