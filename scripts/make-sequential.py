#!/usr/bin/env python3

import argparse
import os
import re


parser = argparse.ArgumentParser()
parser.add_argument("file", nargs="+")
options = parser.parse_args()

for i, f in enumerate(sorted(options.file)):
    print(f"Renaming '{f}'...")
    name = "little-luggable-%03d.jpg" % (i, )
    os.rename(f, name)
