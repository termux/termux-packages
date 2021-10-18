self.description = "Sysupgrade with sync packages having absurd epochs"

versions = (
	"1234327518932650063289125782697890:1.0-1",
	"1234327518932650063289125782697891:0.9-1",
	"1234327518932650063289125782697891:1.0-1",
	"1234327518932650063289125782697891:1.1-1",
	"1234327518932650063289125782697892:1.0-1",
)

pkgvers = [(n, versions[n]) for n in range(len(versions))]
for k, v in pkgvers:
	sp = pmpkg("pkg_%d" % k, v)
	self.addpkg2db("sync", sp)

for k, v in pkgvers:
	lp = pmpkg("pkg_%d" % k, versions[2])
	self.addpkg2db("local", lp)

self.args = "-Su"

self.addrule("PACMAN_RETCODE=0")
for k, v in pkgvers:
	right_ver = versions[max(k, 2)]
	self.addrule("PKG_VERSION=pkg_%d|%s" % (k, right_ver))
