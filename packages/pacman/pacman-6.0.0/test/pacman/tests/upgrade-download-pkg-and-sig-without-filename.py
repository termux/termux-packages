self.description = 'download remote packages with -U without a URL filename'
self.require_capability("gpg")
self.require_capability("curl")

url = self.add_simple_http_server({
    # simple
    '/simple.pkg/': 'simple',
    '/simple.pkg/.sig': 'simple.sig',

    # content-disposition filename
    '/cd.pkg/': {
        'headers': { 'Content-Disposition': 'attachment; filename="cd-alt.pkg"' },
        'body': 'cd'
    },
    '/cd.pkg/.sig': {
        'headers': { 'Content-Disposition': 'attachment; filename="cd-alt-bad.pkg.sig"' },
        'body': 'cd.sig'
    },

    # redirect
    '/redir.pkg/': { 'code': 303, 'headers': { 'Location': '/redir-dest.pkg' } },
    '/redir-dest.pkg': 'redir-dest',
    '/redir-dest.pkg.sig': 'redir-dest.sig',

    # content-disposition and redirect
    '/cd-redir.pkg/': { 'code': 303, 'headers': { 'Location': '/cd-redir-dest.pkg' } },
    '/cd-redir-dest.pkg': {
        'headers': { 'Content-Disposition': 'attachment; filename="cd-redir-dest-alt.pkg"' },
        'body': 'cd-redir-dest'
    },
    '/cd-redir-dest.pkg.sig': 'cd-redir-dest.sig',

    # TODO: absolutely terrible hack to prevent pacman from attempting to
    # validate packages, which causes failure under --valgrind thanks to
    # a memory leak in gpgme that is too general for inclusion in valgrind.supp
    '/404': { 'code': 404 },

    '': 'fallback',
})

self.args = '-Uw {url}/simple.pkg/ {url}/cd.pkg/ {url}/redir.pkg/ {url}/cd-redir.pkg/ {url}/404'.format(url=url)

# packages/sigs are not valid, error is expected
self.addrule('!PACMAN_RETCODE=0')

# TODO: use a predictable file name
#self.addrule('CACHE_FCONTENTS=simple.pkg|simple')
#self.addrule('CACHE_FCONTENTS=simple.pkg.sig|simple.sig')

self.addrule('!CACHE_FEXISTS=cd.pkg')
self.addrule('CACHE_FCONTENTS=cd-alt.pkg|cd')
self.addrule('CACHE_FCONTENTS=cd-alt.pkg.sig|cd.sig')

self.addrule('!CACHE_FEXISTS=redir.pkg')
self.addrule('CACHE_FCONTENTS=redir-dest.pkg|redir-dest')
self.addrule('CACHE_FCONTENTS=redir-dest.pkg.sig|redir-dest.sig')

self.addrule('!CACHE_FEXISTS=cd-redir.pkg')
self.addrule('!CACHE_FEXISTS=cd-redir-dest.pkg')
self.addrule('CACHE_FCONTENTS=cd-redir-dest-alt.pkg|cd-redir-dest')
self.addrule('CACHE_FCONTENTS=cd-redir-dest-alt.pkg.sig|cd-redir-dest.sig')

self.addrule('!CACHE_FEXISTS=.sig')
