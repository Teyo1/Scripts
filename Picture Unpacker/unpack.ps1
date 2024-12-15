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
