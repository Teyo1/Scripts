# Photo Organizer Script

This PowerShell script automatically organizes photos in a directory by moving them into subfolders based on the year and month of the photo's creation date. It handles the extraction of the creation date from the photo's EXIF metadata or falls back to the `LastWriteTime` if EXIF metadata is unavailable. It also removes any empty folders left behind after moving the photos.

## Features

- **Automatic Folder Creation**: It creates subfolders based on the year and month (e.g., `2024-12`) within the directory where the script is located.
- **EXIF Metadata Parsing**: The script tries to read the `DateTimeOriginal` EXIF tag to determine the creation date of the photo. If EXIF data is unavailable, it uses the `LastWriteTime` of the file.
- **Universal Directory Support**: Works in any directory where the script is placed. No need to manually define destination directories.
- **Duplicate Handling**: If files already exist in the destination folder, the script will move and overwrite them. (Optional logic to handle duplicate files can be added).
- **Empty Folder Cleanup**: After the photos are moved, any empty subfolders will be deleted automatically.

## Prerequisites

- PowerShell (the script is written for Windows PowerShell).
- The photos should be in one directory (can be mixed formats like `.jpg`, `.jpeg`, `.png`, `.bmp`, etc.).

## How to Use

1. **Download** or **create a script** named `organize-photos.ps1`.
2. **Place the script** in the folder where your photos are located.
3. **Run the script**:
   - Open PowerShell and navigate to the folder containing the script.
   - Run the script using the command:
     ```powershell
     .\organize-photos.ps1
     ```

4. The script will:
   - Automatically organize photos into subfolders by year and month.
   - Example folder structure after running the script:
     ```
     /YourPhotosFolder/
         ├── 2024-12/
         │   ├── photo1.jpg
         │   ├── photo2.jpg
         ├── 2024-11/
         │   ├── photo3.jpg
         ├── 2024-10/
         │   ├── photo4.jpg
     ```

5. **Empty folders** created during the process (if any) will be removed.

## Script Overview

```powershell
# PowerShell script to organize photos by year and month

# Get the current directory where the script is located
$ScriptDirectory = $PSScriptRoot

# Define the parent directory where images will be moved (this is the directory the script is in)
$DestinationDirectory = $ScriptDirectory

# Function to get the creation date of the photo (or use the LastWriteTime if needed)
function Get-ImageDate {
    param([string]$FilePath)
    
    # Attempt to get the date from EXIF metadata, fallback to LastWriteTime if unavailable
    try {
        $Image = [System.Drawing.Image]::FromFile($FilePath)
        $PropertyItem = $Image.GetPropertyItem(0x9003)  # EXIF tag for DateTimeOriginal
        $ExifDate = [System.Text.Encoding]::ASCII.GetString($PropertyItem.Value).Trim()
        $Image.Dispose()
        return [datetime]::ParseExact($ExifDate, "yyyy:MM:dd HH:mm:ss", $null)
    } catch {
        return (Get-Item $FilePath).LastWriteTime
    }
}

# Get all image files (you can adjust extensions as needed)
$Files = Get-ChildItem -Path $ScriptDirectory -File | Where-Object { $_.Extension -match "jpg|jpeg|png|gif|bmp|tiff|heic|webp" }

foreach ($File in $Files) {
    # Get the image's creation date (month and year)
    $ImageDate = Get-ImageDate -FilePath $File.FullName
    $YearMonth = $ImageDate.ToString("yyyy-MM")
    
    # Create the folder path based on the year and month within the same directory as the script
    $YearMonthFolder = Join-Path -Path $DestinationDirectory -ChildPath $YearMonth
    
    # Create the folder if it doesn't exist
    if (-not (Test-Path -Path $YearMonthFolder)) {
        New-Item -Path $YearMonthFolder -ItemType Directory
    }

    # Define the destination path for the image
    $DestinationPath = Join-Path -Path $YearMonthFolder -ChildPath $File.Name
    
    # Move the image to the new folder
    Move-Item -Path $File.FullName -Destination $DestinationPath -Force
    Write-Output "Moved image: $($File.Name) to $DestinationPath"
}

# Optionally, remove any empty folders in the script's directory
$SubFolders = Get-ChildItem -Path $ScriptDirectory -Directory
foreach ($SubFolder in $SubFolders) {
    if ((Get-ChildItem -Path $SubFolder.FullName -Recurse).Count -eq 0) {
        Remove-Item -Path $SubFolder.FullName -Force
        Write-Output "Deleted empty folder: $($SubFolder.FullName)"
    }
}
