#!/usr/bin/env python
"""Wraps and indents long lines in XML files.

This takes your terminal size into account, so you must rerun this script if
you change its size.
"""
import os
import sys

if (len(sys.argv) < 2):
    print 'usage: ' + sys.argv[0] + ' <xml_file>'
    exit()

report = open(sys.argv[1])
r, columns = os.popen('stty size', 'r').read().split()
char_width = int(columns) - 7 # leave room for vi line numbers when viewing

for elem in report:

    if len(elem) > char_width:
        row_start = elem.find('<')
        elem_list = elem.strip().split()
        length = row_start

        rows = [(' ' * row_start)]

        for attr in elem_list:
            length += len(attr) + 1

            if (length > char_width):
                rows[-1].rstrip()
                rows.append(' ' * (row_start + 1))
                length = row_start + 1 + len(attr) + 1
            rows[-1] += attr + ' '

        rows[-1].rstrip()

        for r in rows:
            print r

    else:
        print elem.rstrip('\n')

report.close()
