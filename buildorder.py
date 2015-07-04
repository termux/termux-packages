#!/usr/bin/env python3
# buildorder.py - script to generate a build order respecting package dependencies

import os, sys

def die(msg):
	print('ERROR: ' + msg)
	sys.exit(1)

if len(sys.argv) != 1: die('buildorder.py takes no arguments')
packages_dir = 'packages'

class DebianPackage:
	def __init__(self, name):
		self.name = name
		self.remaining_dependencies = set() 	# String
		self.sub_packages = set()		# String
		self.prerequisite_for = set() 		# Packages that needs this package

all_packages = [] # List of all DebianPackage:s
packages_map = {} # Mapping from package name to DebianPackage (if subpackage, mapping from subpackage name to parent package)

for subdir_name in sorted(os.listdir(packages_dir)):
	subdir_path = packages_dir + '/' + subdir_name
	if os.path.exists(subdir_path + '/BROKEN.txt'): continue
	build_sh_path = subdir_path + '/build.sh'

	this_package = DebianPackage(subdir_name)
	all_packages.append(this_package)
	packages_map[this_package.name] = this_package

	if not os.path.isfile(build_sh_path): die('The directory ' + subdir_name + ' does not contain build.sh')
	with open(build_sh_path) as build_sh_file:
		for line in build_sh_file:
			if line.startswith('TERMUX_PKG_DEPENDS='):
				deps_comma_separated = line[(line.index('=')+2):(len(line)-2)]
				for dep in deps_comma_separated.split(','):
					dep = dep.strip()
					this_package.remaining_dependencies.add(dep)
	for file_in_subdir_name in sorted(os.listdir(subdir_path)):
		if file_in_subdir_name.endswith('.subpackage.sh'):
			subpackage_name = file_in_subdir_name[0:-len(".subpackage.sh"):]
			this_package.sub_packages.add(subpackage_name)
			packages_map[subpackage_name] = this_package
			with open(subdir_path + '/' + file_in_subdir_name) as subpackage_sh_file:
				for line in subpackage_sh_file:
					if line.startswith('TERMUX_SUBPKG_DEPENDS='):
						deps_comma_separated = line[(line.index('=')+2):(len(line)-2)]
						for dep in deps_comma_separated.split(','):
							dep = dep.strip()
							this_package.remaining_dependencies.add(dep)
	this_package.remaining_dependencies.discard(this_package.name) # Do not depend on itself
	this_package.remaining_dependencies.difference_update(this_package.sub_packages) # Do not depend on any sub package

for package in all_packages:
	for remaining in package.remaining_dependencies:
		if not remaining in packages_map: die('Package ' + package.name + ' depends on non-existing package "' + remaining + '"')
		packages_map[remaining].prerequisite_for.add(package)

# List of all DebianPackage:s without dependencies
packages_without_deps = [p for p in all_packages if not p.remaining_dependencies]
if not packages_without_deps: die('No package without dependency - where to start?')

# Sort alphabetically, but with libandroid-support first (since dependency on libandroid-support
# does not need to be declared explicitly, so anything might in theory depend on it to build):
packages_without_deps.sort(key=lambda p: 'aaaa' if p.name == 'libandroid-support' else p.name, reverse=True)

# Topological sorting
build_order = []
while packages_without_deps:
	pkg = packages_without_deps.pop()
	build_order.append(pkg)
	for other_package in pkg.prerequisite_for:
		other_package.remaining_dependencies.discard(pkg.name) 				# Remove this package
		other_package.remaining_dependencies.difference_update(pkg.sub_packages)	# .. and all its subpackages
		if not other_package.remaining_dependencies:
 			# Check if the other package is ready to build now
			packages_without_deps.append(other_package)

if len(all_packages) != len(build_order):
	print("ERROR: Cycle exists. Remaining: ");
	for pkg in all_packages:
		if pkg not in build_order: print(pkg.name)
	sys.exit(1)

for pkg in build_order: print(pkg.name)

