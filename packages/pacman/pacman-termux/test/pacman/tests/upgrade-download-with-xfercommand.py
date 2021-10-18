self.description = "--upgrade remote packages with XferCommand"

self.option['XferCommand'] = ['/usr/bin/curl %u -o %o']

p1 = pmpkg('pkg1', '1.0-1')
self.addpkg(p1)

p2 = pmpkg('pkg2', '2.0-2')
self.addpkg(p2)

url = self.add_simple_http_server({
    '/{}'.format(p1.filename()): p1.makepkg_bytes(),
    '/{}'.format(p2.filename()): p2.makepkg_bytes(),
})

self.args = '-U {url}/{} {url}/{}'.format(p1.filename(), p2.filename(), url=url)

self.addrule("PACMAN_RETCODE=0")
self.addrule("PKG_EXIST=pkg1")
self.addrule("PKG_EXIST=pkg2")
self.addrule("CACHE_EXISTS=pkg1|1.0-1")
self.addrule("CACHE_EXISTS=pkg2|2.0-2")

# --upgrade fails hard with XferCommand because the fetch callback has no way
# to return the file path to alpm
self.expectfailure = True
