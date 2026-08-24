#!/usr/bin/env python3

import argparse
import glob
import os
import re


ROOT_DIRECTORY = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GALLERY_DIRECTORY = os.path.join(ROOT_DIRECTORY, "images", "gallery")


def main():
    os.chdir(GALLERY_DIRECTORY)
    for i, f in enumerate(sorted(glob.glob("*.jpg"))):
        print(f"Renaming '{f}'...")
        name = "little-luggable-%03d.jpg" % (i, )
        os.rename(f, name)


if __name__:
    main()
