#!/bin/bash

# Exit on any error
set -e
# Exit on any undefined variable
set -u
# Exit if any command in a pipe fails
set -o pipefail

COVER_LATEX_TEMPLATE=cover/cover.jinja.tex
COVER_PDF=cover/cover.pdf

DEVICE_READINGS_LATEX_TEMPLATE=device_readings/device_readings.jinja.tex
DEVICE_READINGS_PDF=device_readings/device_readings.pdf

READINGS_PDFS=readings/*.pdf

FURTHER_READINGS_LATEX_TEMPLATE=further_readings/further_readings.jinja.tex
FURTHER_READINGS_PDF=further_readings/further_readings.pdf

OUTPUT_PDF=output/packet.pdf

# Build Cover Page
gatpack \
    --from $COVER_LATEX_TEMPLATE \
    --to $COVER_PDF \
    --overwrite

# Build Device Readings Page
gatpack \
    --from $DEVICE_READINGS_LATEX_TEMPLATE \
    --to $DEVICE_READINGS_PDF \
    --overwrite

# Build Further Readings Page
gatpack \
    --from $FURTHER_READINGS_LATEX_TEMPLATE \
    --to $FURTHER_READINGS_PDF \
    --overwrite

# Combine all readings into "packet.pdf"
gatpack combine \
    $COVER_PDF \
    $DEVICE_READINGS_PDF\
    $FURTHER_READINGS_PDF \
    $OUTPUT_PDF \
    --overwrite
    # $READINGS_PDFS \

open $OUTPUT_PDF || xdg-open $OUTPUT_PDF || echo "Failed to automatically open file at $OUTPUT_PDF"
