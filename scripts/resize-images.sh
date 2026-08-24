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
set -u

SCRIPTS_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

ROOT_DIRECTORY="$SCRIPTS_DIRECTORY/.."
SOURCE_DIRECTORY="$ROOT_DIRECTORY/images/gallery"
DESTINATION_DIRECTORY="$ROOT_DIRECTORY/docs/gallery"

WIDTHS=(400 800 1600)
CANONICAL_WIDTH=2400
QUALITY=82

slug() {
    basename "$1" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\{1,\}/-/g; s/^-//; s/-$//'
}

resize() {
    local source="$1"
    local destination="$2"
    local width="$3"
    local metadata="$4"

    if [ "$metadata" = "keep" ] ; then
        sharp --input "$source" --output "$destination" \
            --format jpeg --quality "$QUALITY" \
            --withMetadata --autoOrient \
            resize "$width" --fit inside --withoutEnlargement > /dev/null
    else
        sharp --input "$source" --output "$destination" \
            --format jpeg --quality "$QUALITY" \
            --autoOrient \
            resize "$width" --fit inside --withoutEnlargement > /dev/null
    fi
}

resize_imaegs() {
    source_directory="$1"
    destination_directory="$2"

    for source in "$source_directory"/*.jpg "$source_directory"/*.jpeg ; do
        [ -e "$source" ] || continue
        name=`slug "$source"`

        for width in "${WIDTHS[@]}" ; do
            destination="$destination_directory/$name@${width}w.jpg"
            echo "$name@${width}w.jpg"
            resize "$source" "$destination" "$width" strip
        done

        destination="$destination_directory/$name.jpg"
        echo "$name.jpg"
        resize "$source" "$destination" "$CANONICAL_WIDTH" keep
    done
}

mkdir -p "$DESTINATION_DIRECTORY"
rm "$DESTINATION_DIRECTORY"/*.{jpg,jpeg} || true
resize_imaegs "$SOURCE_DIRECTORY" "$DESTINATION_DIRECTORY"
