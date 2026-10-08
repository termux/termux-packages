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
	df -h .
	sudo apt purge -yq --allow-remove-essential $(
		dpkg -l |
			grep '^ii' |
			awk '{ print $2 }' |
			grep -P '(ant|aspnetcore|cabal-|clang|cpp-|dotnet-|g\+\+-|gcc-12|gcc-13|gcc-14|gcc-15|gfortran-|ghc-|google-cloud-cli|grub-|grub2-|liblldb-|liblua|libmono|llvm|mecab|mesa-|mongodb-|mysql-|netstandard-|postgresql-|python3|ruby-|shim-signed|temurin-)'
	)

	sudo apt purge -yq \
		azure-cli \
		buildah \
		firefox \
		git-lfs \
		kubectl \
		mercurial-common \
		podman \
		shellcheck \
		skopeo \
		snapd \
		vim
		# google-chrome-stable
		# microsoft-edge-stable already removed by the deps in the above apt purge

	# Directories
	sudo rm -rf /opt/ghc /opt/az /opt/hostedtoolcache /opt/actionarchivecache /opt/runner-cache
	sudo rm -rf /opt/pipx /usr/share/dotnet /usr/share/swift /usr/share/miniconda /usr/share/az_* /usr/share/gradle-* /usr/share/java /home/runner/.rustup
	sudo rm -rf /etc/skel /home/packer /home/linuxbrew
	sudo rm -rf /usr/local /usr/src/

	# https://github.com/actions/runner-images/issues/709#issuecomment-612569242
	sudo rm -rf "$AGENT_TOOLSDIRECTORY"

	# Clean compressed docker images
	# Docker has already deflated them before free-space.sh was called in CI, so
	# the compressed parts are just collecting junk on the disk
	sudo rm -rf /var/lib/containerd/io.containerd.content.v1.content/

	sudo apt autoremove -yq
	sudo apt clean
	df -h .
fi
