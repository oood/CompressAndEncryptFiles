# CompressAndEncryptFiles

`CompressAndEncryptFiles.bat` is a batch script designed to compress and encrypt files in a specified directory and its subdirectories. Each file is archived individually in its original location, with the original files deleted after compression. This script utilizes 7-Zip for compression and AES-256 encryption to secure the contents.

## Features

- Compresses individual files in the specified directory and all subdirectories.
- Uses AES-256 encryption for secure archiving.
- Renames the compressed files to their SHA256 hash for better identification.
- Deletes original files after successful compression.

## Requirements

- Windows operating system.
- [7-Zip](https://www.7-zip.org/) installed on your system. Make sure the `7z.exe` path is correctly set in the script.

## Usage

1. **Download the Script**: Save the `CompressAndEncryptFiles.bat` file to your computer.
2. **Set Parameters**:
   - Modify the `sevenZipPath` variable in the script to point to your 7-Zip installation path.
   - Set the `password` variable to your desired encryption password.
   - Change the `rootDir` variable to the directory you want to process.

3. **Run the Script**: Double-click the script or run it from the command prompt. It will process all files in the specified directory and its subdirectories.

## License

This script is licensed under the MIT License. See the included license information in the script for details.

## Author

Created by ChatGPT (OpenAI)
