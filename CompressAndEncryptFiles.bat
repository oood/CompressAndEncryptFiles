@echo off
setlocal enabledelayedexpansion

:: CompressAndEncryptFiles version 2.1
:: A batch script to compress and encrypt files in a directory and its subdirectories using a RAM disk.
:: Each file is archived individually in the specified output directory or the original directory.
:: This script uses 7-Zip for compression and encryption with AES-256.
:: Author: ChatGPT (OpenAI)
:: License: MIT License

:: Set the path to 7z if it's not in the system's PATH
set "sevenZipPath=C:\Program Files\7-Zip\7z.exe"

:: Set the password for AES encryption
set "password=YourSecurePasswordHere"

:: Define the root directory you want to process
set "rootDir=C:\path"

:: Define the RAM disk letter (change this to your RAM disk letter)
set "ramDisk=R:\Temp"

:: Define custom output directory (leave empty for in-place replacement)
set "customOutputDir="

:: Check if DEBUG mode is enabled
set "debugMode=0"
if "%~1"=="--debug" (
    set "debugMode=1"
)

:: Check if the RAM disk directory exists; if not, exit
if not exist "%ramDisk%" (
    echo RAM disk not found. Please make sure it is mounted.
    exit /b 1
)

:: Check if 7z.exe exists in the defined path
if not exist "%sevenZipPath%" (
    echo 7z executable not found at "%sevenZipPath!".
    exit /b 1
)

:: Loop through all files in the root directory and subdirectories
for /r "%rootDir%" %%f in (*) do (
    :: Skip any existing .7z files
    if /i not "%%~xf"==".7z" (
        :: Copy the file directly to the RAM disk
        if !debugMode! == 1 echo [DEBUG] Copying "%%f" to "%ramDisk%\%%~nxf"
        copy "%%f" "%ramDisk%\%%~nxf" >nul
        
        :: Compress the copied file from RAM to a 7z archive in RAM
        if !debugMode! == 1 echo [DEBUG] Compressing "%ramDisk%\%%~nxf" to "%ramDisk%\%%~nxf.7z"
        "%sevenZipPath%" a -t7z -mx=0 -p"%password%" -mhe=on "%ramDisk%\%%~nxf.7z" "%ramDisk%\%%~nxf"
        
        :: Calculate the SHA256 hash of the compressed archive
        for /f "delims=" %%h in ('certutil -hashfile "%ramDisk%\%%~nxf.7z" SHA256 ^| findstr /v "hash"') do set "hash=%%h"
        
        :: Determine output path based on custom output directory
        if defined customOutputDir (
            set "relativePath=%%~dpf"
            set "relativePath=!relativePath:%rootDir%=!"
            set "outputPath=!customOutputDir!!relativePath!"
            
            :: Create the output directory if it doesn't exist
            if not exist "!outputPath!" (
                mkdir "!outputPath!" >nul 2>&1
                if errorlevel 1 (
                    echo [ERROR] Failed to create directory: "!outputPath!"
                )
            )

            :: Move the archive to the custom output directory with the SHA256 name
            if !debugMode! == 1 echo [DEBUG] Moving archive to custom output directory: "!outputPath!\!hash!.7z"
            move /Y "%ramDisk%\%%~nxf.7z" "!outputPath!\!hash!.7z" >nul
        ) else (
            :: Move the archive from RAM to the original directory, renaming it with the SHA256 hash
            if !debugMode! == 1 echo [DEBUG] Moving archive to original directory: "%%~dpf!hash!.7z"
            move /Y "%ramDisk%\%%~nxf.7z" "%%~dpf!hash!.7z" >nul
        )
        
        :: Delete the original file
        if !debugMode! == 1 echo [DEBUG] Deleting original file: "%%f"
        del "%%f"
        
        :: Delete the copy in RAM
        if !debugMode! == 1 echo [DEBUG] Deleting copy in RAM: "%ramDisk%\%%~nxf"
        del "%ramDisk%\%%~nxf"
    )
)

echo Process complete!
pause
