# Getting started

<!-- Golly I'm excited about this project hehe -->

**Requirements**

- Python 3.10+
- LaTeX

## 01 Install GatPack

Run the following command to install globally:

```bash
python3 -m pip install gatpack
```

## 02 Initialize your project

cd into the directory you would like to create your project and run

```bash
gatpack init
```

Follow the set up steps to name your project.

## 03 Examine the Example Workflow

Open the example workflow located in `YOUR_PROJECT/example/build.sh`. You will see a number of commands outlining the workflow. These are fairly self explanatory.

```bash
#!/bin/bash

# Build Cover Page
gatpack render cover.jinja.tex cover.tex --context=config.gatpack.yaml
gatpack build cover.tex cover.pdf

# Build Further Readings Page
gatpack render further_readings.jinja.tex further_readings.tex --context=config.gatpack.yaml
gatpack build further_readings.tex further_readings.pdf

# Combine all readings into "packet.pdf"
gatpack combine cover.pdf further_readings.pdf packet.pdf

# Add footer to the readings
gatpack footer packet.pdf "Page { n } of { N }" packet-final.pdf
```

Then you can run this with `YOUR_PROJECT/example/build.sh`.

You should see everything rendered as expected in `packet-final.pdf`.

# What is GatPack

GatPack is an extensible CLI tool offering many utilities for packet creation. These can be strung together in a BASH script or via the Python API for some very powerful workflows. Some features GatPack offers:

```
 Usage: gatpack [OPTIONS] COMMAND [ARGS]...                                                                                                                                              
╭─ Options ──────────────────────────────────────────────────────────────────────────────────────╮
│ --help          Show this message and exit.                                                    │
╰────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands ─────────────────────────────────────────────────────────────────────────────────────╮
│ init      Initialize a new GatPack project in your specified directory.                        │
│ render    Render a specified LaTeX document with Jinja placeholders with provided context.     │
│ combine   Combine any number of PDFs into a single PDF.                                        │
│ build     Build a LaTeX document into a PDF.                                                   │
│ footer    Add a footer to every page of a PDF (Currently Not-Implemented).                     │
╰────────────────────────────────────────────────────────────────────────────────────────────────╯


```
