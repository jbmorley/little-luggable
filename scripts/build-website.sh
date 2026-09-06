#!/usr/bin/env bash

# Copyright (c) 2023-2026 Jason Morley
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e
set -o pipefail
set -x
set -u

ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
SCRIPTS_DIRECTORY="$ROOT_DIRECTORY/scripts"
FONTS_DIRECTORY="$ROOT_DIRECTORY/resources/fonts"
WEBSITE_DIRECTORY="$ROOT_DIRECTORY/docs"
WEBSITE_DATA_DIRECTORY="$WEBSITE_DIRECTORY/_data"
WEBSITE_FONTS_DIRECTORY="$WEBSITE_DIRECTORY/assets/fonts"
RELEASES_PATH="$WEBSITE_DATA_DIRECTORY/releases.json"


# Process the command line arguments.
POSITIONAL=()
SERVE=false
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -s|--serve)
        SERVE=true
        shift
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done

# Update the release notes.

mkdir -p "$WEBSITE_DATA_DIRECTORY"
build-tools \
    github-releases jbmorley little-luggable \
    --synthesize-manifests "$SCRIPTS_DIRECTORY/release-manifest-definition.json" > "$RELEASES_PATH"

# Generate fonts.

mkdir -p "$WEBSITE_FONTS_DIRECTORY"
rm "$WEBSITE_FONTS_DIRECTORY"/*.{woff,woff2,txt} || true

PALETTE=1
PALETTE_SOURCE="$FONTS_DIRECTORY/nabla-latin.woff2"
for subset in latin latin-ext ; do
    cp "$FONTS_DIRECTORY/nabla-$subset.woff2" "$WEBSITE_FONTS_DIRECTORY/nabla-$subset.woff2"
    "$SCRIPTS_DIRECTORY/recolor-nabla.py" \
        "$FONTS_DIRECTORY/nabla-$subset-svg.woff" \
        "$WEBSITE_FONTS_DIRECTORY/nabla-$subset-svg-recolor-palette-$PALETTE.woff" \
        --palette "$PALETTE" \
        --palette-from "$PALETTE_SOURCE"
done

# Generate derived assets.
"$SCRIPTS_DIRECTORY/resize-images.sh"

# Install the Jekyll dependencies.
cd "$WEBSITE_DIRECTORY"
bundle install

# Determine the version.
VERSION_NUMBER=`changes version`
export VERSION_NUMBER

# Build the website.
cd "$WEBSITE_DIRECTORY"
if $SERVE ; then
    bundle exec jekyll serve --watch
else
    bundle exec jekyll build
fi
