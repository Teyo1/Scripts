# Hash Checker Script

This batch script calculates and verifies the MD5 and SHA256 hashes of the latest downloaded file in a specified directory. It provides color-coded feedback based on whether the calculated hashes match the expected values.

## Features

- Automatically finds the latest downloaded file in the specified directory.
- Prompts the user to enter expected MD5 and SHA256 hashes.
- Displays the calculated hashes and compares them to the expected values.
- Color-coded output to indicate matching status:
  - Green: Both hashes match or only SHA256 matches.
  - Yellow (Orange): MD5 matches but SHA256 does not match.
  - Red: Neither hash matches.

## Usage

1. **Download the Script**: Ensure you have the batch script saved as `hash_checker.bat`.

2. **Open the Script**:
   - Right-click on `hash_checker.bat` and select **Edit** to view or modify it.

3. **Set the Download Directory**:
   - By default, the script is set to check the `C:\Users\%USERNAME%\Downloads` directory. 
   - To change the directory to `XYZ:\YourDownloadLocation`, find the following line in the script:
     ```bat
     set "download_dir=C:\Users\%USERNAME%\Downloads"
     ```
   - Change it to:
     ```bat
     set "download_dir=XYZ:\YourDownloadLocation"
     ```

4. **Run the Script**:
   - Double-click `hash_checker.bat` to execute it.
   - Follow the prompts to enter the expected MD5 and SHA256 hashes.
  
## Expected Hashes

- **MD5 Hash**: `3A37312509712D4E12D27240137FF377`
- **SHA256 Hash**: `B029393EA7B7CF644FB1C9F984F57C1980077562EE2E15D0FFD049C4C48098D3`

## Requirements

- This script requires PowerShell to calculate file hashes. It is compatible with Windows systems that have PowerShell installed.

## Troubleshooting

- If you receive an error stating that no files were found, ensure that there are files in the specified download directory.
- Ensure that the expected hash values are entered correctly to receive accurate comparisons.


