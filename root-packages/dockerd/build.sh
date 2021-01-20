TERMUX_PKG_HOMEPAGE=https://docs.docker.com/engine/
TERMUX_PKG_DESCRIPTION="Server daemon process for building and containerizing applications."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# remember to update DOCKER_GITCOMMIT inside termux_step_make()
# bellow when upgrading to a new version
TERMUX_PKG_VERSION=20.10.2
TERMUX_PKG_SRCURL=https://github.com/moby/moby/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc4818f0cba2ded2f6f7420a1fda027ddbf6c6c9fe319f84d1311bfe610447ca
TERMUX_PKG_DEPENDS="containerd"
TERMUX_PKG_CONFFILES="etc/docker/daemon.json"
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_make() {
	files="api/server/middleware/version.go
		api/server/router/build/build_routes.go
		builder/builder-next/adapters/containerimage/pull.go
		builder/builder-next/worker/worker.go
		builder/dockerfile/copy.go
		builder/dockerfile/dispatchers.go
		builder/dockerfile/evaluator.go
		builder/dockerfile/imagecontext.go
		builder/dockerfile/internals.go
		builder/remotecontext/detect.go
		cmd/dockerd/config.go
		cmd/dockerd/daemon.go
		container/container.go
		daemon/cluster/cluster.go
		daemon/commit.go
		daemon/container.go
		daemon/create.go
		daemon/daemon_unix.go
		daemon/exec.go
		daemon/exec/exec.go
		daemon/health.go
		daemon/images/image_builder.go
		daemon/images/image_unix.go
		daemon/images/service.go
		daemon/kill.go
		daemon/logger/awslogs/cloudwatchlogs.go
		daemon/logger/loggerutils/logfile.go
		daemon/start.go
		daemon/stats.go
		daemon/stats_collector.go
		distribution/config.go
		distribution/push_v2.go
		distribution/xfer/download.go
		image/rootfs.go
		image/tarexport/load.go
		image/tarexport/save.go
		layer/filestore_unix.go
		libcontainerd/remote/client.go
		oci/defaults.go
		pkg/archive/archive.go
		pkg/archive/diff.go
		pkg/platform/platform.go
		pkg/system/lcow_unsupported.go
		pkg/system/path.go
		pkg/tarsum/fileinfosums.go
		plugin/v2/plugin_linux.go
		runconfig/hostconfig_unix.go
		vendor/archive/tar/stat_unix.go
		vendor/cloud.google.com/go/compute/metadata/metadata.go
		vendor/github.com/aws/aws-sdk-go/aws/credentials/processcreds/provider.go
		vendor/github.com/aws/aws-sdk-go/internal/shareddefaults/shared_config.go
		vendor/github.com/containerd/containerd/archive/tar.go
		vendor/github.com/containerd/containerd/client.go
		vendor/github.com/containerd/containerd/content/local/writer.go
		vendor/github.com/containerd/containerd/install.go
		vendor/github.com/containerd/containerd/oci/spec.go
		vendor/github.com/containerd/containerd/platforms/database.go
		vendor/github.com/containerd/go-runc/io_unix.go
		vendor/github.com/docker/go-connections/tlsconfig/certpool_go17.go
		vendor/github.com/docker/libnetwork/controller.go
		vendor/github.com/docker/swarmkit/manager/manager.go
		vendor/github.com/google/certificate-transparency-go/x509/cert_pool.go
		vendor/github.com/google/certificate-transparency-go/x509/verify.go
		vendor/github.com/mistifyio/go-zfs/utils.go
		vendor/github.com/moby/buildkit/solver/llbsolver/ops/file.go
		vendor/github.com/moby/buildkit/util/resolver/resolver.go
		vendor/github.com/moby/buildkit/util/winlayers/applier.go
		vendor/github.com/tonistiigi/fsutil/copy/copy.go
		vendor/github.com/tonistiigi/fsutil/followlinks.go
		vendor/github.com/tonistiigi/fsutil/stat.go
		vendor/github.com/tonistiigi/fsutil/validator.go
		vendor/github.com/vbatts/tar-split/archive/tar/stat_unix.go
		vendor/go.etcd.io/bbolt/db.go
		vendor/golang.org/x/net/internal/socket/sys_posix.go
		vendor/golang.org/x/net/ipv4/batch.go
		vendor/golang.org/x/net/ipv4/header.go
		vendor/golang.org/x/net/ipv6/batch.go
		vendor/golang.org/x/net/ipv6/sockopt_posix.go
		vendor/golang.org/x/oauth2/google/default.go
		vendor/golang.org/x/oauth2/google/sdk.go
		vendor/google.golang.org/grpc/credentials/alts/utils.go
		vendor/gotest.tools/v3/fs/file.go
		vendor/gotest.tools/v3/fs/report.go
		volume/mounts/parser.go
		volume/mounts/windows_parser.go
		volume/service/store.go"

	# setup go build environment
	termux_setup_golang

	# apply some patches in a batch
	xargs sed -i "s_\(/etc/docker\)_$PREFIX\1_g" < <(grep -R /etc/docker | cut -d':' -f1 | sort | uniq)
	xargs sed -i 's/[a-zA-Z0-9]*\.GOOS/"linux"/g' < <(grep -R '[a-zA-Z0-9]*\.GOOS' | cut -d':' -f1 | sort | uniq)
	for file in $files; do
		sed -i 's/\("runtime"\)/_ \1/' $file
	done

	# issue the build command
	export DOCKER_GITCOMMIT=8891c58a43
	export DOCKER_BUILDTAGS='exclude_graphdriver_btrfs exclude_graphdriver_devicemapper exclude_graphdriver_quota selinux exclude_graphdriver_aufs'
	AUTO_GOPATH=1 PREFIX='' hack/make.sh dynbinary
}

termux_step_make_install() {
	install -Dm 0700 bundles/dynbinary-daemon/dockerd-dev ${TERMUX_PREFIX}/bin/dockerd-dev
	install -Dm 0700 ${TERMUX_PKG_BUILDER_DIR}/dockerd ${TERMUX_PREFIX}/bin/dockerd
	install -Dm 0700 ${TERMUX_PKG_BUILDER_DIR}/daemon.json ${TERMUX_PREFIX}/etc/docker/daemon.json
}
