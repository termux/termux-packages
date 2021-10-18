self.description = "Recursively remove a package with cyclical dependencies"

lpkg1 = pmpkg('pkg1')
self.addpkg2db('local', lpkg1)
lpkg1.depends = [ 'dep1' ]

lpkg2 = pmpkg('pkg2')
self.addpkg2db('local', lpkg2)
lpkg2.depends = [ 'dep3' ]

# cyclic dependency 1
ldep1 = pmpkg('dep1')
self.addpkg2db('local', ldep1)
ldep1.depends = [ 'dep2', 'dep3', 'dep4' ]
ldep1.reason = 1

# cyclic dependency 2
ldep2 = pmpkg('dep2')
self.addpkg2db('local', ldep2)
ldep2.depends = [ 'dep1' ]
ldep2.reason = 1

# dependency required by another package
ldep3 = pmpkg('dep3')
self.addpkg2db('local', ldep3)
ldep3.reason = 1

# explicitly installed dependency
ldep4 = pmpkg('dep4')
self.addpkg2db('local', ldep4)
ldep4.reason = 0

self.args = "-Rs pkg1"

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg2")
self.addrule("PKG_EXIST=dep3")
self.addrule("PKG_EXIST=dep4")
self.addrule("!PKG_EXIST=pkg1")
self.addrule("!PKG_EXIST=dep1")
self.addrule("!PKG_EXIST=dep2")
