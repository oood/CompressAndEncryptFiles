# Compress And Encrypt Files version 2.1

## Description
This batch script compresses and encrypts files located in a specified directory and its subdirectories using a RAM disk. Each file is archived individually, allowing for either in-place replacement in the original directory or saving to a custom output directory. The script uses 7-Zip for compression and AES-256 encryption, ensuring that your files are securely stored.

## Prerequisites
1. **Windows Operating System**: This script is designed to run on Windows environments.
2. **7-Zip**: You need to have 7-Zip installed on your system. Make sure the path to `7z.exe` is correctly specified in the script.
3. **RAM Disk**: A RAM disk must be mounted and accessible at the specified drive letter in the script. A RAM disk uses system memory to create a virtual drive, allowing for faster read and write operations compared to traditional hard drives.

## How It Works
1. **Setup**: The script defines the required paths and parameters, including:
    - `sevenZipPath`: The path to the 7-Zip executable.
    - `password`: The password for AES encryption.
    - `rootDir`: The root directory that contains the files to be processed.
    - `ramDisk`: The drive letter assigned to your RAM disk.
    - `customOutputDir`: An optional custom output directory. If left empty, files will be processed in place.

2. **Directory and File Checks**: The script checks for the existence of the RAM disk and the 7-Zip executable. If either is missing, the script exits with an error message.

3. **File Processing**:
    - The script loops through all files in the specified directory and its subdirectories.
    - It skips any files that already have a `.7z` extension (indicating they have already been compressed).
    - Each file is copied to the RAM disk for faster processing.
    - The script compresses and encrypts the copied file into a 7z archive on the RAM disk.
    - It calculates the SHA256 hash of the compressed archive, which will be used to name the archive file.

4. **Output Handling**:
    - If a custom output directory is specified, the script creates the necessary directory structure and moves the compressed archive to the custom output location, renaming it with the SHA256 hash.
    - If no custom output directory is specified, the compressed archive is moved back to the original directory, again renamed with the SHA256 hash.

5. **Cleanup**: After processing, the script deletes the original file and the temporary copy in the RAM disk to save space.

## Debug Mode
Version 2.1 introduces a debug mode that can be activated by passing the `--debug` parameter when running the script. This will enable verbose output, providing information about each major action being performed, which can be helpful for troubleshooting.

To run the script with debug output, use:

```bash
CompressAndEncryptFiles.bat --debug
````

## Changes Summary
- **Version 1.0 to 2.0**:
  - Added error handling for missing RAM disk and 7-Zip executable.
  - Implemented in-place file processing.
  - Each file is archived individually, allowing for more efficient processing.

- **Version 2.0 to 2.1**:
  - Added functionality to ensure the original file is only deleted after successful processing.
  - Implemented `--debug` mode to output debug information.
  - Improved output handling for custom directories.


## Usage Instructions
1. Open the script in a text editor.
2. Modify the following variables as needed:
    - Set the `sevenZipPath` variable to the location of the `7z.exe` executable.
    - Specify the `password` for encryption.
    - Set the `rootDir` to the directory containing the files you want to compress.
    - Change the `ramDisk` variable to the letter corresponding to your mounted RAM disk.
    - Optionally, set `customOutputDir` to a desired output path; leave it empty for in-place replacement.
3. Save the script and run it.

## License
This script is licensed under the MIT License.


## Author
Created by ChatGPT (OpenAI)
