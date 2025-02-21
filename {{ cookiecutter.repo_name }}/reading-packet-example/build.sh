#!/bin/bash

# Exit on any error
set -e
# Exit on any undefined variable
set -u
# Exit if any command in a pipe fails
set -o pipefail

export OUTPUT_PDF="./output/packet-with-footers.pdf"
gatpack compose reading-packet --overwrite

open $OUTPUT_PDF || xdg-open $OUTPUT_PDF || echo "Failed to automatically open file at $OUTPUT_PDF"
