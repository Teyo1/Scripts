# Määritä sisääntulotiedoston nimi
$inputFile = "*.gt"

# Tarkista, onko sisääntulotiedostoa olemassa
if (-not (Test-Path $inputFile)) {
    Write-Host "Virhe: $inputFile tiedostoa ei ole."
    exit 1
}

# Pyydä käyttäjältä ulostulotiedoston nimi
$outputFile = "muunnettu.gt"

# Lue sisääntulotiedoston sisältö ja käsittele se rivi kerrallaan
$lines = Get-Content $inputFile
$outputLines = @()

foreach ($line in $lines) {
    # Poista johtavat ja perässä olevat välilyönnit
    $line = $line.Trim()

    # Tarkista, alkaako rivi merkillä '0' ja korvaa se '1':llä, jos kyllä
    if ($line.StartsWith('0')) {
        $line = '1' + $line.Substring(1)
    }

    # Jaa rivi osiin välilyöntien kohdalta
    $fields = $line -split '\s+'

    # Tarkista, että rivillä on odotettu määrä kenttiä
    if ($fields.Count -ge 7) {
        # Muotoile rivi täsmällisesti haluttujen kenttien ja välilyöntimäärien mukaan
        $formattedLine = "{0, -8}{1, -8}{2, -8}{3, -8}" -f $fields[0], $fields[1], $fields[2], $fields[3]
        
        # Lisää kentät 4, 5 ja 6, tarkista 0.000
        for ($i = 4; $i -le 6; $i++) {
            $fieldValue = $fields[$i]

            # Tarkista, onko kenttä "0.000"
            if ($fieldValue -eq "0.000") {
                # Lisää ylimääräinen välilyönti
                $formattedLine += " {0,-16}" -f $fieldValue
            } else {
                # Muotoile normaaliin muotoon
                $formattedLine += "{0,-16}" -f $fieldValue
            }
        }
    } else {
        # Jos kenttiä on vähemmän kuin odotettu, käytetään alkuperäistä riviä varotoimenpiteenä
        $formattedLine = $line
    }

    # Poista ylimääräiset välilyönnit rivin lopusta
    $formattedLine = $formattedLine.TrimEnd()

    # Lisää muokattu rivi tulostukseen
    $outputLines += $formattedLine
}

# Kirjoita muokatut rivit ulostulotiedostoon
$outputLines | Set-Content $outputFile

Write-Host "Rivit muotoiltu onnistuneesti ja tallennettu tiedostoon '$outputFile'."