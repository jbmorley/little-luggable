#!/usr/bin/env bash

# Created using AI (Anthropic Claude, Opus 5); no copyright or license asserted.

set -e
set -o pipefail
set -u

ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
SCRIPTS_DIRECTORY="$ROOT_DIRECTORY/scripts"
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
