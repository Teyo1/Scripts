# Set the input file name
$inputFile = "*.gt"

# Check if the input file exists
if (-not (Test-Path $inputFile)) {
    Write-Host "Virhe: $inputFile tiedostoa ei ole."
    exit 1
}

# Get the output file name from the user
$outputFile = Read-Host "Anna tiedostolle nimi ja tiedostopääte (esim .txt)"

# Read the input file and process it line by line
$lines = Get-Content $inputFile
$outputLines = @()

foreach ($line in $lines) {
    # Remove leading spaces
    $line = $line.TrimStart()

    # Replace the first character '0' with '9' if it exists
    if ($line.StartsWith('0')) {
        $line = '9' + $line.Substring(1)
    }

    # Replace multiple spaces with a single space
    $line = $line -replace '\s+', ' '

    # Remove any trailing spaces
    $line = $line.TrimEnd()

    # Add the processed line to the output array
    $outputLines += $line
}

# Write the output lines to the output file
$outputLines | Set-Content $outputFile

Write-Host "Korjattu onnistuneesti. Tiedosto on nimetty '$outputFile' ja löytyy samasta kansiosta kuin alkuperäinen tiedosto."
