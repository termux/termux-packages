self.description = "Query info on a package (overflow long values)"

p = pmpkg("overflow")
p.desc = "Overflow size and date values if possible"
p.url = "http://www.archlinux.org"
p.license = "GPL2"
p.arch = "i686"
p.packager = "Arch Linux"
# size is greater than 4294967295, aka UINT_MAX
p.size = "10000000000"
# build date is greater than 2147483647, aka INT_MAX
p.builddate = "3000000000"
# install date is greater than UINT_MAX
p.installdate = "10000000000"

self.addpkg2db("local", p)

self.args = "-Qi %s" % p.name

self.addrule("PACMAN_RETCODE=0")
self.addrule("PACMAN_OUTPUT=^Name.*%s" % p.name)
self.addrule("PACMAN_OUTPUT=^Description.*%s" % p.desc)
self.addrule("PACMAN_OUTPUT=^Installed Size.*9.31 GiB")
self.addrule("PACMAN_OUTPUT=^Build Date.* 2065")
self.addrule("PACMAN_OUTPUT=^Install Date.* 2286")

# expect failure on 32bit systems
import sys
if sys.maxsize <= 2**32:
    self.expectfailure = True
