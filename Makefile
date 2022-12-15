.DEFAULT_GOAL := help

ifeq ($(OS),Windows_NT)
	export CREATE_DIST=if not exist dist mkdir dist
	export DELETE_DIST_BUILD=if exist build rd /s /q build
	export DELETE_DIST_WHEEL=del /f /q dist\\*.whl
	export ENV_FOR_DYNACONF=test
	export MYPYPATH=
	export OPTION_NUITKA=--clang
	export PIPENV=python -m pipenv
	export PYTHON=python
	export PYTHONPATH=src
	export PYTHONPATH_DEV=src
	export SETUP=${PYTHON} src\\setup.py
else
	export CREATE_DIST=mkdir -p dist
	export DELETE_DIST_BUILD=rm -rf build
	export DELETE_DIST_WHEEL=rm -rf dist/*.whl
	export ENV_FOR_DYNACONF=test
	export MYPYPATH=
	export OPTION_NUITKA=--disable-ccache
	export PIPENV=python3 -m pipenv
	export PYTHON=python3
	export PYTHONPATH=src
	export PYTHONPATH_DEV=src
	export SETUP=${PYTHON} src/setup.py
endif

##                                                                            .
## =============================================================================
## IO-TEMPLATE - Template Library - make Documentation.
##             -------------------------------------------------------------
##             The purpose of this Makefile is to support the whole software
##             development process for io-tools. It contains also the
##             necessary tools for the CI activities.
##             -------------------------------------------------------------
##             The available make commands are:
## ------------------------------------------------------------------------------
## help:               Show this help.
## -----------------------------------------------------------------------------
## app-dev:			   Setup the enviornment for developing apps
app-dev: vscode
## dev:                Format, lint and test the code.
dev: format lint tests
## docs:               Check the API documentation, create and upload the user documentation.
docs: pydocstyle mkdocs
## final:              Format, lint and test the code, create a ddl, the documentation and a wheel.
final: format lint docs tests wheel nuitka
## format:             Format the code with isort, Black and docformatter.
format: isort black docformatter
## lint:               Lint the code with Bandit, Flake8, Pylint and Mypy.
lint: bandit flake8 pylint mypy
## tests:              Run all tests with pytest.
tests: pytest
## -----------------------------------------------------------------------------

help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

export ENV_FOR_DYNACONF=test

# Bandit is a tool designed to find common security issues in Python code.
# https://github.com/PyCQA/bandit
# Configuration file: none
bandit:             ## Find common security issues with Bandit.
	@echo Info **********  Start: Bandit ***************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run bandit --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run bandit -c pyproject.toml -r ${PYTHONPATH_DEV}
	@echo Info **********  End:   Bandit **************************************

# The Uncompromising Code Formatter
# https://github.com/psf/black
# Configuration file: pyproject.toml
black:              ## Format the code with Black.
	@echo Info **********  Start: black ***************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run black --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run black ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   black ***************************************

# VS Code
# Setup the enviornment to develop apps using the io-tools library
# Configuration file: none
vscode:
	@echo Info **********  Start: Setup Code Enviornment **********************
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON    =${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	${PYTHON} --version
	@echo ---------------------------------------------------------------------
	${VSCODE} .
# Byte-compile Python libraries
# https://docs.python.org/3/library/compileall.html
# Configuration file: none
compileall:         ## Byte-compile the Python libraries.
	@echo Info **********  Start: Compile All Python Scripts ******************
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON    =${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	${PYTHON} --version
	@echo ---------------------------------------------------------------------
	${PYTHON} -m compileall
	@echo Info **********  End:   Compile All Python Scripts ******************

# Python interface to coveralls.io API
# https://github.com/TheKevJames/coveralls-python
# Configuration file: none
coveralls:          ## Run all the tests and upload the coverage data to coveralls.
	@echo Info **********  Start: coveralls ***********************************
	${PIPENV} run pytest --cov=${PYTHONPATH} --cov-report=xml tests
	@echo ----------------------------------------------------------------------
	${PIPENV} run coveralls --service=github
	@echo Info **********  End:   coveralls ***********************************

# Formats docstrings to follow PEP 257
# https://github.com/PyCQA/docformatter
# Configuration file: none
docformatter:       ## Format the docstrings with docformatter.
	@echo Info **********  Start: docformatter ********************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run docformatter --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run docformatter --in-place -r ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   docformatter ********************************

# Flake8: Your Tool For Style Guide Enforcement.
# https://github.com/pycqa/flake8
# Configuration file: cfg.cfg
flake8:             ## Enforce the Python Style Guides with Flake8.
	@echo Info **********  Start: Flake8 **************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run flake8 --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run flake8 ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   Flake8 **************************************

# isort your imports, so you don't have to.
# https://github.com/PyCQA/isort
# Configuration file: pyproject.toml
isort:              ## Edit and sort the imports with isort.
	@echo Info **********  Start: isort ***************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run isort --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run isort ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   isort ***************************************

# Project documentation with Markdown.
# https://github.com/mkdocs/mkdocs/
# Configuration file: none
mkdocs:             ## Create and upload the user documentation with MkDocs.
	@echo Info **********  Start: MkDocs **************************************
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON    =${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	${PIPENV} run mkdocs --version
	@echo ---------------------------------------------------------------------
	${PIPENV} run mkdocs build
	@echo Info **********  End:   MkDocs **************************************

# Mypy: Static Typing for Python
# https://github.com/python/mypy
# Configuration file: pyproject.toml
mypy:               ## Find typing issues with Mypy.
	@echo Info **********  Start: Mypy ****************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run mypy --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run mypy ${PYTHONPATH_DEV}
	@echo Info **********  End:   Mypy ****************************************

# Nuitka: Python compiler written in Python
# https://github.com/Nuitka/Nuitka
nuitka:             ## Create a dynamic link library.
	@echo Info **********  Start: nuitka **************************************
	@echo CREATE_DIST=${CREATE_DIST}
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON    =${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	${PIPENV} run ${PYTHON} -m nuitka --version
	@echo ---------------------------------------------------------------------
	${CREATE_DIST}
	${PIPENV} run ${PYTHON} -m nuitka ${OPTION_NUITKA} --include-package=io_tools --module ${PYTHONPATH} --no-pyi-file --output-dir=dist --remove-output
	@echo Info **********  End:   nuitka **************************************

# pip is the package installer for Python.
# https://pypi.org/project/pip/
# Configuration file: none
# Pipenv: Python Development Workflow for Humans.
# https://github.com/pypa/pipenv
# Configuration file: Pipfile
pipenv-dev:         ## Install the package dependencies for development.
	@echo Info **********  Start: Installation of Development Packages ********
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON=${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	@echo ----------------------------------------------------------------------
	${PYTHON} -m pip install --upgrade pip
	${PYTHON} -m pip install --upgrade pipenv
	${PYTHON} -m pip uninstall -y virtualenv
	${PYTHON} -m pip install virtualenv
	${PIPENV} install --dev
	${PIPENV} update --dev
	@echo ----------------------------------------------------------------------
	${PIPENV} run pip freeze
	@echo ----------------------------------------------------------------------
	${PYTHON} --version
	${PYTHON} -m pip --version
	${PYTHON} -m pipenv --version
	@echo Info **********  End:   Installation of Development Packages ********
pipenv-prod:        ## Install the package dependencies for production.
	@echo Info **********  Start: Installation of Production Packages *********
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON=${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	@echo ----------------------------------------------------------------------
	${PYTHON} -m pip install --upgrade pip
	${PYTHON} -m pip install --upgrade pipenv
	${PYTHON} -m pip uninstall -y virtualenv
	${PYTHON} -m pip install virtualenv
	${PIPENV} install
	${PIPENV} update
	@echo ----------------------------------------------------------------------
	${PIPENV} run pip freeze
	@echo ----------------------------------------------------------------------
	${PYTHON} --version
	${PYTHON} -m pip --version
	${PYTHON} -m pipenv --version
	@echo Info **********  End:   Installation of Production Packages *********

# pydocstyle - docstring style checker.
# https://github.com/PyCQA/pydocstyle
# Configuration file: pyproject.toml
pydocstyle:         ## Check the API documentation with pydocstyle.
	@echo Info **********  Start: pydocstyle **********************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run pydocstyle --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pydocstyle --count --match='(?!PDFLIB\\)*\.py' ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   pydocstyle **********************************

# Pylint is a tool that checks for errors in Python code.
# https://github.com/PyCQA/pylint/
# Configuration file: .pylintrc
pylint:             ## Lint the code with Pylint.
	@echo Info **********  Start: Pylint **************************************
	@echo MYPYPATH      =${MYPYPATH}
	@echo PYTHON        =${PYTHON}
	@echo PYTHONPATH    =${PYTHONPATH}
	@echo PYTHONPATH_DEV=${PYTHONPATH_DEV}
	${PIPENV} run pylint --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pylint ${PYTHONPATH_DEV} tests
	@echo Info **********  End:   Pylint **************************************

# pytest: helps you write better programs.
# https://github.com/pytest-dev/pytest/
# Configuration file: pyproject.toml
pytest:             ## Run all tests with pytest.
	@echo Info **********  Start: pytest **************************************
	${PIPENV} run pytest --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --dead-fixtures tests
	${PIPENV} run pytest --cache-clear --cov=${PYTHONPATH} --cov-report term-missing:skip-covered --random-order -v tests
	@echo Info **********  End:   pytest **************************************
pytest-ci:          ## Run all tests with pytest after test tool installation.
	@echo Info **********  Start: pytest **************************************
	${PIPENV} install pytest
	${PIPENV} install pytest-cov
	${PIPENV} install pytest-deadfixtures
	${PIPENV} install pytest-helpers-namespace
	${PIPENV} install pytest-random-order
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --dead-fixtures tests
	${PIPENV} run pytest --cache-clear --cov=${PYTHONPATH} --cov-report term-missing:skip-covered --random-order -v tests
	@echo Info **********  End:   pytest **************************************
pytest-first-issue: ## Run all tests with pytest until the first issue occurs.
	@echo Info **********  Start: pytest **************************************
	@echo ENV_FOR_DYNACONF=${ENV_FOR_DYNACONF}
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --cache-clear --cov=${PYTHONPATH} --cov-report term-missing:skip-covered --random-order -rP -v -x tests
	@echo Info **********  End:   pytest **************************************
pytest-issue:       ## Run only the tests with pytest which are marked with 'issue'.
	@echo Info **********  Start: pytest **************************************
	@echo ENV_FOR_DYNACONF=${ENV_FOR_DYNACONF}
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --cache-clear --cov=${PYTHONPATH} --cov-report term-missing:skip-covered -m issue -rP -v -x tests
	@echo Info **********  End:   pytest **************************************
pytest-module:      ## Run tests of specific module(s) with pytest - test_all & test_cfg_cls_setup & test_db_cls.
	@echo Info **********  Start: pytest **************************************
	@echo ENV_FOR_DYNACONF=${ENV_FOR_DYNACONF}
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --version
	@echo ----------------------------------------------------------------------
	${PIPENV} run pytest --cache-clear --cov=${PYTHONPATH} --cov-report term-missing:skip-covered -v tests/test_db_cls_action.py
	@echo Info **********  End:   pytest **************************************

version:            ## Show the installed software versions.
	@echo Info **********  Start: version *************************************
	@echo MYPYPATH  =${MYPYPATH}
	@echo PYTHON    =${PYTHON}
	@echo PYTHONPATH=${PYTHONPATH}
	${PYTHON} -m pip --version
	${PYTHON} -m pipenv --version
	@echo Info **********  End:   version *************************************

# wheel: The official binary distribution format for Python
# https://github.com/pypa/setuptools
# https://github.com/pypa/wheel
# Configuration file: setup.cfg
wheel:              ## Create a distribution archive with a wheel.
	@echo Info **********  Start: wheel ***************************************
	@echo CREATE_DIST=${CREATE_DIST}
	@echo DELETE_DIST=${DELETE_DIST_WHEEL}
	@echo MYPYPATH   =${MYPYPATH}
	@echo PYTHON     =${PYTHON}
	@echo PYTHONPATH =${PYTHONPATH}
	@echo ---------------------------------------------------------------------
	${CREATE_DIST}
	${DELETE_DIST_BUILD}
	${DELETE_DIST_WHEEL}
	${PIPENV} run ${SETUP} bdist_wheel
	${PIPENV} run unzip -l dist/*.whl
	${PIPENV} run check-wheel-contents dist
	${PIPENV} run ${SETUP} build_ext --inplace
	@echo Info **********  End:   wheel ***************************************

## ============================================================================
