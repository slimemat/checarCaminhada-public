# SETUP VARs
$url = "https://xxxxxxxx.blogspot.com/" # this code was made with this blog and theme in mind
$ntfyTopic = "caminhada-matheus-secret"
$gistId = $env:GIST_ID 
$gistFileName = "caminhada_hash.txt" 

$headers = @{
    "Authorization" = "Bearer $($env:GIST_PAT)" 
    "Accept" = "application/vnd.github.v3+json"
}

# WILL CHECK FOR THE DATE ELEMENT IN THE BLOG URL
Write-Host "Checando website Caminhada Bragança: $url"
try {
    Write-Host "Fetching last known date from Gist..."
    $gist = Invoke-RestMethod -Uri "https://api.github.com/gists/$gistId" -Headers $headers
    $lastDateString = $gist.files.$gistFileName.content
    Write-Host "Last date found: $lastDateString"

    Write-Host "Getting raw website content..."
    $rawContent = (Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop).Content
    
    # REGEX CORRIGIDO E FINAL
    # Alterado para aceitar tanto aspas simples como duplas na classe.
    $regex = "<h2 class=['""]date-header['""]><span>(.+?)</span></h2>"

    $currentDateString = $null

    if ($rawContent -match $regex) {
        $currentDateString = $Matches[1].Trim()
    } else {
        throw "Não foi possível encontrar o padrão da data (h2 class='date-header') no conteúdo do site."
    }
    # ---------------------

    Write-Host "Most recent date found on page: $currentDateString"

    if ($currentDateString -ne $lastDateString) {
        Write-Host ". ݁₊ ⊹ . ݁˖ . ݁ CHANGE DETECTED! A new post date was found. Sending notification... . ݁₊ ⊹ . ݁˖ . ݁" -ForegroundColor Yellow

        $alertMessage = "Nova data de post no site da caminhada: '$($currentDateString)'. Link: $url"
        Invoke-RestMethod -Method Post -Uri "https://ntfy.sh/$ntfyTopic" -Body $alertMessage
        Write-Host "Notification sent."

        Write-Host "Updating Gist with new date string..."
        $updateBody = @{
            files = @{
                "$gistFileName" = @{
                    content = $currentDateString
                }
            }
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri "https://api.github.com/gists/$gistId" -Method PATCH -Headers $headers -Body $updateBody
        Write-Host "Gist updated successfully."
    } else {
        Write-Host "No changes detected. The most recent post date is still the same."
    }
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    $errorMessage = "Failed to check $url at $(Get-Date). Error: $($_.Exception.Message)"
    Invoke-RestMethod -Method Post -Uri "https://ntfy.sh/$ntfyTopic" -Body $errorMessage
}
