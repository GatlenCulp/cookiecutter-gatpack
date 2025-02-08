#!/bin/bash

# Exit on any error
set -e
# Exit on any undefined variable
set -u
# Exit if any command in a pipe fails
set -o pipefail

COMPOSE=compose.gatpack.json

COVER_LATEX_TEMPLATE=cover/cover.jinja.tex
COVER_LATEX=cover/cover.tex
COVER_PDF=cover/cover.pdf

DEVICE_READINGS_LATEX_TEMPLATE=device_readings/device_readings.jinja.tex
DEVICE_READINGS_LATEX=device_readings/device_readings.tex
DEVICE_READINGS_PDF=device_readings/device_readings.pdf

READINGS_PDFS=readings/*.pdf

FURTHER_READINGS_LATEX_TEMPLATE=further_readings/further_readings.jinja.tex
FURTHER_READINGS_LATEX=further_readings/further_readings.tex
FURTHER_READINGS_PDF=further_readings/further_readings.pdf

OUTPUT_PDF=output/packet.pdf

# Build Cover Page
rm -f $COVER_LATEX
rm -f $COVER_PDF
gatpack render \
    $COVER_LATEX_TEMPLATE \
    $COVER_LATEX \
    $COMPOSE \
    --no-use-standard-jinja
gatpack build \
    $COVER_LATEX \
    $COVER_PDF

# Build Device Readings Page
rm -f $DEVICE_READINGS_LATEX
rm -f $DEVICE_READINGS_PDF
gatpack render \
    $DEVICE_READINGS_LATEX_TEMPLATE \
    $DEVICE_READINGS_LATEX \
    $COMPOSE
gatpack build \
    $DEVICE_READINGS_LATEX \
    $DEVICE_READINGS_PDF

# Build Further Readings Page
rm -f $FURTHER_READINGS_LATEX
rm -f $FURTHER_READINGS_PDF
gatpack render \
    $FURTHER_READINGS_LATEX_TEMPLATE \
    $FURTHER_READINGS_LATEX \
    $COMPOSE
gatpack build \
    $FURTHER_READINGS_LATEX \
    $FURTHER_READINGS_PDF

# Combine all readings into "packet.pdf"
rm -f $OUTPUT_PDF
gatpack combine \
    $COVER_PDF \
    $DEVICE_READINGS_PDF\
    $FURTHER_READINGS_PDF \
    $OUTPUT_PDF
    # $READINGS_PDFS \

open $OUTPUT_PDF
