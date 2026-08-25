#!/usr/bin/env bash

# Created using AI (Anthropic Claude, Opus 5); no copyright or license asserted.

set -e
set -o pipefail
set -x
set -u

SOURCE="$1"
DESTINATION="$2"

WORKING_DIRECTORY=`mktemp -d`
trap "rm -rf \"$WORKING_DIRECTORY\"" EXIT

# Drop vertex attributes and nodes nothing references.
gltf-transform prune \
    "$SOURCE" \
    "$WORKING_DIRECTORY/pruned.glb" \
    --keep-attributes false

# Collapse duplicated geometry.
gltf-transform dedup \
    "$WORKING_DIRECTORY/pruned.glb" \
    "$WORKING_DIRECTORY/deduped.glb"

# Quantize and compress using Draco (which model-viewer supports).
gltf-transform draco \
    "$WORKING_DIRECTORY/deduped.glb" \
    "$DESTINATION"
