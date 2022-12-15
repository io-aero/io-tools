@echo off

rem ----------------------------------------------------------------------------
rem
rem run_io_template_dev.bat: Process test data for IO-TEMPLATE.
rem
rem ----------------------------------------------------------------------------

setlocal EnableDelayedExpansion

set ENV_FOR_DYNACONF=dev
set PYTHONPATH=

echo.
echo Script %0 is now running

if exist logging_io_template.log (
    del /f /q logging_io_template.log
)

echo =======================================================================
echo Start %0
echo -----------------------------------------------------------------------
echo IO_TEMPLATE - Template Library.
echo -----------------------------------------------------------------------
echo ENVIRONMENT_TYPE : %ENV_FOR_DYNACONF%
echo INPUT_SOURCE     : %DCR_CORE_INPUT_SOURCE%
echo PYTHONPATH       : %PYTHONPATH%
echo -----------------------------------------------------------------------
echo:| TIME
echo =======================================================================

pipenv run python src\launcher.py
if ERRORLEVEL 1 (
    echo Processing of the script: %0 - step: 'python src\launcher.py was aborted
)

echo.
echo -----------------------------------------------------------------------
echo:| TIME
echo -----------------------------------------------------------------------
echo End   %0
echo =======================================================================
