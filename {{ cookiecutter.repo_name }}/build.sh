#!/bin/bash

# Build Cover Page
gatpack render cover.jinja.tex cover.tex config.gatpack.yaml
gatpack build cover.tex cover.pdf

# Build Further Readings Page
gatpack render further_readings.jinja.tex further_readings.tex config.gatpack.yaml
gatpack build further_readings.tex further_readings.pdf

# Combine all readings into "packet.pdf"
gatpack combine cover.pdf further_readings.pdf packet.pdf

# Add footer to the readings
# gatpack footer packet.pdf "Page {{ n }} of {{ N }}" packet-final.pdf