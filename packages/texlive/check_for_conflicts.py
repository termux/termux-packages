#!/usr/bin/python3
##
##  Tiny script to check if all texlive's subpackages contain conflicting files
##
##  Copyright (C) 2019 Henrik Grimler
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <https://www.gnu.org/licenses/>.


with open("collections.txt", "r") as f:
    pkgs = f.read().split("\n")

files = {}
for pkg in pkgs:
    if pkg:
        with open("collection-"+pkg+".txt", "r") as f:
            files[pkg] = f.readlines()

l = len(pkgs)-1
for i in range(0,l):
    for k in range(i+1,l):
        Diff = set(files[pkgs[i]]).intersection(files[pkgs[k]])
        if Diff:
            print("\n"+pkgs[i]+" "+pkgs[k])
            print(Diff)
