@echo off
SET TEST_SUITE=%1
SET CURRENT_FOLDER=%cd%
SET ROOT_FOLDER=%~dp0

:: we add /lib folder to the PYTHONPATH
:: this way libraries can be imported using
:: their name and not only the absolute path


SET PYTHONPATH=%PYTHONPATH%;%ROOT_FOLDER%/lib

:: we add chrome webdriver to the system path 
:: so that selenium can control chrome browser
SET PATH=%PATH%;%ROOT_FOLDER%/chrome_driver;

cd %ROOT_FOLDER%
cd %CURRENT_FOLDER%

CALL robot --debugfile debug.txt --outputdir log --loglevel TRACE %TEST_SUITE%
cd %CURRENT_FOLDER%










