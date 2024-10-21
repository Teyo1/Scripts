@echo off
setlocal enabledelayedexpansion

:: Set the input file name
set "input_file=kartoitus.txt"

:: Check if the input file exists
if not exist "%input_file%" (
    echo Virhe: %input_file% tiedostoa ei ole.
    exit /b 1
)

:: Get the output file name from the user
set /p "output_file=Anna muokatun tiedoston nimi ja tiedostomuoto esimerkiksi (.txt, .jpg, .mp3): "

:: Open the input file and process it line by line
(
    for /f "usebackq delims=" %%i in ("%input_file%") do (
        set "line=%%i"

        :: Remove the leading space if it exists before the first '0'
        if "!line:~0,1!"==" " (
            set "line=!line:~1!"
        )

        :: Replace the first character '0' with '9' if it exists
        if "!line:~0,1!"=="0" (
            set "line=9!line:~1!"
        )

        :: Replace multiple spaces with a single space
        for /l %%j in (1,1,20) do (
            set "line=!line:  = !"
        )

        echo !line!
    )
) > "%output_file%"

echo Korjattu onnistuneesti. Tiedosto on nimetty: '%output_file%' ja löytyy samasta kansiosta kuin alkuperäinen tiedosto.

endlocal
pause
