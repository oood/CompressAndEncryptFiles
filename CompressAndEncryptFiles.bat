@echo off
:: 
:: CompressAndEncryptFiles.bat
:: 
:: A batch script to compress and encrypt files in a directory and its subdirectories.
:: Each file is archived individually in the same directory, and original files are deleted.
:: This script uses 7-Zip for compression and encryption with AES-256.
:: 
:: Author: ChatGPT (OpenAI)
:: License: MIT License
:: 
:: Permission is hereby granted, free of charge, to any person obtaining a copy of this software
:: and associated documentation files (the "Software"), to deal in the Software without restriction,
:: including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
:: and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
:: subject to the following conditions:
:: 
:: - The above copyright notice and this permission notice shall be included in all copies or substantial
::   portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
:: LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
:: IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
:: WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
:: SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

setlocal enabledelayedexpansion

:: Set the path to 7z if it's not in the system's PATH
set "sevenZipPath=C:\Program Files\7-Zip\7z.exe"

:: Set the password for AES encryption
set "password=YourSecurePasswordHere"

:: Define the root directory you want to process
set "rootDir=C:\path"

:: Change directory to the root folder
cd /d "%rootDir%"

:: Check if 7z.exe exists in the defined path
if not exist "%sevenZipPath%" (
    echo 7z executable not found at "%sevenZipPath%"!
    exit /b 1
)

:: Loop through all non-7z files in the root directory and subdirectories
for /r %%f in (*) do (
    :: Check if the file already has a .7z extension, skip those
    if /i not "%%~xf"==".7z" (
        :: Extract the full directory path where the file is located
        set "fileDir=%%~dpf"
        
        :: Extract the file name without the extension
        set "filename=%%~nf"

        :: Compress the file with no compression and encrypt it, saving to the same directory
        "%sevenZipPath%" a -t7z -mx=0 -p"%password%" -mhe=on "%%~dpf!filename!.7z" "%%f"

        :: Check if compression was successful
        if not exist "%%~dpf!filename!.7z" (
            echo Archiving of %%f failed!
            exit /b 1
        )

        :: Calculate the SHA256 hash of the archived file
        for /f "delims=" %%h in ('certutil -hashfile "%%~dpf!filename!.7z" SHA256 ^| findstr /v "hash"') do set "hash=%%h"

        :: Rename the archived file using the SHA256 hash
        ren "%%~dpf!filename!.7z" "!hash!.7z"

        :: Delete the original file
        del "%%f"
    )
)

echo Process complete!
pause
