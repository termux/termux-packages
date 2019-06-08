#!/usr/bin/env python3

import urllib.request
from subprocess import Popen, PIPE

version_map = {}
any_error = False

pipe = Popen('./scripts/list-versions.sh', stdout=PIPE)
for line in pipe.stdout:
    (name, version) = line.decode().strip().split('=')
    version_map[name] = version

def check_manifest(arch, manifest):
    current_package = {}
    for line in manifest:
        if line.isspace():
            package_name = current_package['Package']
            package_version = current_package['Version']
            if not package_name in version_map:
                # Skip sub-package
                continue
            latest_version = version_map[package_name]
            if package_version != latest_version:
                print(f'{package_name}@{arch}: Expected {latest_version}, but was {package_version}')
            current_package.clear()
        elif not line.decode().startswith(' '):
            parts = line.decode().split(':', 1)
            current_package[parts[0].strip()] = parts[1].strip()

for arch in ['all', 'aarch64', 'arm', 'i686', 'x86_64']:
    manifest_url = f'https://dl.bintray.com/termux/termux-packages-24/dists/stable/main/binary-{arch}/Packages'
    with urllib.request.urlopen(manifest_url) as manifest:
        check_manifest(arch, manifest)
