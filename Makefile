#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = cookiecutter-gatpack
PYTHON_VERSION = 3.12
PYTHON_INTERPRETER = python
DOCS_PORT ?= 8000

.PHONY: activate-env
activate-env: ## Activate the gatpack environment from another project
	source ~/maia/gatpack/.venv/bin/activate


#################################################################################
# UTILITIES                                                                     #
#################################################################################

_prep: ## Clean up .DS_Store files
	rm -f **/*/.DS_store

_welcome: ## Print a Welcome screen
	curl -s https://raw.githubusercontent.com/GatlenCulp/gatlens-opinionated-template/vscode-customization/welcome.txt

#################################################################################
# PACKAGE COMMANDS                                                              #
#################################################################################

.PHONY: create_environment
create_environment: ## Set up python interpreter environment
	uv venv
	@echo ">>> New virtualenv with uv created. Activate with:\nsource '.venv/bin/activate'"

.PHONY: requirements
requirements: ## Install Python Dep
	uv sync

.PHONY: publish-all
publish-all: format lint publish docs-publish ## Run format, lint, publish package and docs

#################################################################################
# CLEAN COMMANDS                                                                #
#################################################################################

.PHONY: clean-latex
clean-latex: ## Clean all LaTeX helper files
	find . -type f -name "*.aux" -delete
	find . -type f -name "*.bbl" -delete
	find . -type f -name "*.bcf" -delete
	find . -type f -name "*.blg" -delete
	find . -type f -name "*.fdb_latexmk" -delete
	find . -type f -name "*.fls" -delete
	find . -type f -name "*.lof" -delete
	find . -type f -name "*.log" -delete
	find . -type f -name "*.lot" -delete
	find . -type f -name "*.out" -delete
	find . -type f -name "*.synctex.gz*" -delete
	find . -type f -name "*.toc" -delete
	find . -type d -name "_minted*" -delete

.PHONY: clean-python
clean-python: ## Clean all compiled Python files
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

.PHONY: clean
clean: clean-latex clean-python ## Delete all compiled Python files and LaTeX build artifacts
	cd './{{ cookiecutter.repo_name }}/reading-packet-example' && \
	find . -type f -name "*.jinja.pdf" -delete && \
	find ./01_cover ./02_device-readings ./04_further-readings ./output -type f -name "*.pdf" -delete && \
	find ./01_cover ./02_device-readings ./04_further-readings -type f -name "*.tex" -not -name "*.jinja.tex" -delete

.PHONY: lint ## Lint using ruff (use `make format` to do formatting)
lint:
	ruff check --config pyproject.toml cookiecutter_gatpack

.PHONY: format ## Format source code with black
format:
	ruff --config pyproject.toml cookiecutter_gatpack

#################################################################################
# DOCS COMMANDS                                                                 #
#################################################################################

# Switched to using uv
docs-serve: ## Serve documentation locally on port $(DOCS_PORT)
	cd docs && \
	mkdocs serve -a localhost:$(DOCS_PORT) || \
	echo "\n\nInstance found running on $(DOCS_PORT), try killing process and rerun."

# Makes sure docs can be served prior to actually deploying
docs-publish: ## Build and deploy documentation to GitHub Pages
	cd docs && \
	mkdocs build && \
	mkdocs gh-deploy --clean

#################################################################################
# DATA COMMANDS                                                                 #
#################################################################################

#################################################################################
# TEST COMMANDS                                                                 #
#################################################################################

.PHONY: test
test: _prep ## Run all tests
	pytest -vvv --durations=0

.PHONY: test-fastest
test-fastest: _prep ## Run tests with fail-fast option
	pytest -vvv -FFF

# Requires pytest-watcher (Continuous Testing for Fast Tests)
.PHONY: test-continuous
test-continuous: _prep ## Run tests in watch mode using pytest-watcher
	ptw . --now --runner pytest --config-file pyproject.toml -vvv -FFF

.PHONY: test-debug-last
test-debug-last: ## Debug last failed test with pdb
	pytest --lf --pdb

.PHONY: manual_test
manual_test:
	rm -rf manual_test
	mkdir -p manual_test && cd manual_test && \
	cookiecutter .. --checkout "dev"
	# gatpack init

.PHONY: _clean_manual_test
_clean_manual_test:
	rm -rf manual_test

#################################################################################
# PROJECT RULES                                                                 #
#################################################################################

.PHONY: data ## Make Dataset
data: requirements
	$(PYTHON_INTERPRETER) cookiecutter_gatpack/dataset.py

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.PHONY: _print-logo
_print-logo: ## Prints the GOTem logo
	@echo "\033[38;5;39m   ____  ___ _____"
	@echo "  / ___|/ _ \_   _|__ _ __ ___"
	@echo " | |  _| | | || |/ _ \ '_ \` _ \\"
	@echo " | |_| | |_| || |  __/ | | | | |"
	@echo "  \____|\___/ |_|\___|_| |_| |_|\033[0m"


.PHONY: help
help: _print-logo  ## Show this help message
	@echo "\n\033[1m~ Available rules: ~\033[0m\n"
	@echo "For VSCode/Cursor, try: ⇧ ⌘ P, Tasks: Run Task\n"
	@grep -E '^[a-zA-Z][a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[38;5;222m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: help

.DEFAULT_GOAL := all