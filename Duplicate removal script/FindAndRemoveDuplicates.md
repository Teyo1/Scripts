# Duplicate Image Finder and Remover Script

This PowerShell script scans a specified directory (and its subdirectories), calculates the SHA256 hash of each image file, and deletes any duplicate images based on the hash comparison.

## Features
- **Directory Scanning**: Scans the directory where the script is located (`$PSScriptRoot`) for image files in formats like `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.tiff`, `.heic`, and `.webp`.
- **SHA256 Hash Calculation**: Computes the SHA256 hash of each image to uniquely identify its contents.
- **Duplicate Detection**: Detects duplicate files by comparing the hash values.
- **File Deletion**: Deletes duplicate files and outputs their names in the console.

## Requirements
- PowerShell 3.0 or higher.
- The script should be placed in the directory you want to scan for duplicate images.

## How It Works
1. The script scans the current directory (and all subdirectories) for image files.
2. It calculates the SHA256 hash of each image.
3. It stores the hash values in a hashtable.
4. If a duplicate file is found (i.e., a file with the same hash), the script deletes the duplicate.
5. After the scan, the script outputs a message stating that the duplicate check is complete.

## Script Code

```powershell
# Define the directory to scan (set to the current script directory)
$Directory = $PSScriptRoot

# Function to calculate the SHA256 hash of a file
function Get-FileHashValue {
    param([string]$FilePath)
    $Hash = Get-FileHash -Path $FilePath -Algorithm SHA256
    return $Hash.Hash
}

# Initialize an empty hash table to store file hashes
$FileHashes = @{}

# Get all image files (you can add more extensions if needed)
$Files = Get-ChildItem -Path $Directory -Recurse -File | Where-Object { $_.Extension -match "jpg|jpeg|png|gif|bmp|tiff|heic|webp" }

# Iterate over each file in the directory
foreach ($File in $Files) {
    # Calculate the file's hash
    $FileHash = Get-FileHashValue -FilePath $File.FullName
    
    # Check if the hash is already in the hash table
    if ($FileHashes.ContainsKey($FileHash)) {
        # Duplicate found, delete the file
        Remove-Item -Path $File.FullName -Force
        Write-Output "Deleted duplicate file: $($File.Name)"
    } else {
        # Store the hash in the hash table
        $FileHashes[$FileHash] = $File.FullName
    }
}

Write-Output "Duplicate check complete."
