
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
yaml2md – A Simple Tool for Documenting YML Files
"""
#
# Copyright 2015-2019 by Hartmut Goebel <h.goebel@crazy-compilers.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

from __future__ import print_function

__author__ = "Hartmut Goebel <h.goebel@crazy-compilers.com>"
__copyright__ = ("Copyright 2015-2019 by Hartmut Goebel "
                 "<h.goebel@crazy-compilers.com>")
__licence__ = "GNU General Public License version 3 (GPL v3)"

import argparse
import sys

from . import convert


def main(infilename, outfilename, strip_regex, yaml_strip_regex):
    if infilename == '-':
        infh = sys.stdin
    else:
        infh = open(infilename)
    if outfilename == '-':
        outfh = sys.stdout
    else:
        outfh = open(outfilename, "w")
    for l in convert(infh.readlines(), strip_regex, yaml_strip_regex):
        print(l.rstrip(), file=outfh)


def run():
    parser = argparse.ArgumentParser()
    parser.add_argument('infilename', metavar='infile',
                        help="YAML-file to read (`-` for stdin)")
    parser.add_argument('outfilename', metavar='outfile',
                        help="rst-file to write (`-` for stdout)")
    parser.add_argument('--strip-regex', metavar='regex',
                        help=("Regex which will remove everything it matches. "
                              "Can be used e.g. to remove fold markers from "
                              "headings. "
                              "Example to strip out [[[,]]] fold markers use: "
                              r"'\s*(:?\[{3}|\]{3})\d?$'. "
                              "Check the README for more details."))
    parser.add_argument('--yaml-strip-regex', metavar='regex',
                        help=("Same usage as --strip-regex except that this "
                              "regex substitution is preformed on the YAMl "
                              "part of the file as opposed RST part."))
    args = parser.parse_args()
    main(**vars(args))


if __name__ == "__main__":
    run()
