#!/usr/bin/env -S uv run --with fonttools[woff] --script
#
# Created using AI (Anthropic Claude, Opus 5); no copyright or license asserted.
#
# Bakes one of Nabla's CPAL palettes into its OT-SVG build's artwork.
#
# Safari can't read Nabla's COLRv1 build and falls back to the OT-SVG one, which has
# no CPAL table to select a palette from. That artwork spells its colours as
# `var(--colorN, #RRGGBB)`; an OT-SVG glyph has no stylesheet to resolve them against,
# so Safari rejects the value outright and paints the glyph black. Substituting a
# literal colour per index fixes the palette and the black together.
#
# The palette must come from the *latin* subset: Google drops CPAL entries a subset
# doesn't use.
#
#   scripts/recolor-nabla.py resources/fonts/nabla-latin-svg.woff <destination.woff> \
#       --palette-from resources/fonts/nabla-latin.woff2
#
# `head.modified` is inherited from the source rather than stamped at save time so builds
# are reproducible; --modified overrides it.

# pyright: reportMissingImports=false

import argparse
import datetime
import pathlib
import re

from fontTools.misc.timeTools import timestampSinceEpoch, timestampToString
from fontTools.ttLib import TTFont

# The fallback isn't always a hex triplet—index 9 is spelled `white`—so match whatever
# sits between the comma and the closing paren rather than assuming a format.
COLOUR = re.compile(r"var\(--color(\d+)\s*,\s*[^)]*\)")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=pathlib.Path)
    parser.add_argument("destination", type=pathlib.Path)
    parser.add_argument("--palette", type=int, default=1)
    parser.add_argument(
        "--palette-from",
        type=pathlib.Path,
        help="font whose CPAL supplies the palette; defaults to the source",
    )
    parser.add_argument(
        "--modified",
        help="ISO 8601 date to stamp into head.modified, interpreted as UTC; "
        "defaults to the source font's own value",
    )
    options = parser.parse_args()

    palettes = TTFont(options.palette_from or options.source)["CPAL"].palettes
    colours = [
        "#%02X%02X%02X" % (c.red, c.green, c.blue) for c in palettes[options.palette]
    ]

    # fontTools stamps `head.modified` with the current time on save unless told not
    # to, which would make every run produce a different binary from identical inputs.
    font = TTFont(options.source, recalcTimestamp=False)

    if options.modified:
        when = datetime.datetime.fromisoformat(options.modified)
        if when.tzinfo is None:
            # Anchor a bare date to UTC rather than the build machine's zone, so the
            # output doesn't depend on where it was built.
            when = when.replace(tzinfo=datetime.timezone.utc)
        font["head"].modified = timestampSinceEpoch(when.timestamp())

    documents = font["SVG "].docList

    # A short palette would substitute silently wrong colours rather than fail, so
    # check the artwork's indices against it before touching anything.
    referenced = max(
        (int(match.group(1)) for document in documents for match in COLOUR.finditer(document.data)),
        default=-1,
    )
    if referenced >= len(colours):
        raise SystemExit(
            f"artwork references colour {referenced} but the palette has only "
            f"{len(colours)} entries—read it from the latin subset"
        )

    for document in documents:
        document.data = COLOUR.sub(lambda match: colours[int(match.group(1))], document.data)

    font.flavor = "woff"
    font.save(options.destination)

    print(f"{options.source} -> {options.destination}")
    print(f"  palette {options.palette}: {' '.join(colours)}")
    print(f"  modified: {timestampToString(font['head'].modified)}")


if __name__ == "__main__":
    main()
