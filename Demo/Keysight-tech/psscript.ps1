Param (
    [Parameter(Mandatory = $true)]
    [string]
    $AzureUserName,

    [string]
    $AzurePassword,

    [string]
    $AzureTenantID,

    [string]
    $AzureSubscriptionID,

    [string]
    $ODLID,

    [string]
    $DeploymentID,

    [string]
    $vmAdminUsername,

    [string]
    $adminPassword,

    [string]
    $trainerUserName,

    [string]
    $trainerUserPassword
)

Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 
Write-Host "Adding .env variables"
[System.Environment]::SetEnvironmentVariable('AzureTenantID', $AzureTenantID,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('AzureSubscriptionID', $AzureSubscriptionID,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('DeploymentID', $DeploymentID,[System.EnvironmentVariableTarget]::Machine)

#Import Common Functions
$path = pwd
$path=$path.Path
$commonscriptpath = "$path" + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

# Run Imported functions from cloudlabs-windows-functions.ps1
WindowsServerCommon

Enable-CloudLabsEmbeddedShadow $vmAdminUsername $trainerUserName $trainerUserPassword

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f

Remove-Item -Path "C:\Users\Public\Desktop\Azure Portal.lnk" -Force -ErrorAction SilentlyContinue

$WshShell = New-Object -ComObject WScript.Shell
$adsShortcut = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Advanced Design System 2027" -Filter *.lnk -Recurse |
    Where-Object { $WshShell.CreateShortcut($_.FullName).TargetPath -like "*\ads.exe" } |
    Select-Object -First 1
if ($adsShortcut) {
    Copy-Item -Path $adsShortcut.FullName -Destination "C:\Users\Public\Desktop\" -Force
}

$shadowScript = @'
$ErrorActionPreference = "SilentlyContinue"
Get-Process mstsc | Stop-Process

$user = "vmAdminUsernameValue"
$Session = $null
$SessionState = $null
foreach ($line in (qwinsta | Select-Object -Skip 1)) {
    $tokens = @($line.TrimStart('>').Trim() -split '\s+')
    $lower = @($tokens | ForEach-Object { $_.ToLower() })
    $i = [array]::IndexOf($lower, $user.ToLower())
    if ($i -ge 0) {
        $Session = $tokens[$i + 1]
        $SessionState = $tokens[$i + 2]
        if ($SessionState -eq 'Active') { break }
    }
}

if ($Session -eq $null)
{
$wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
$wshell.Popup("Learner has not connected to this VM yet. Please ask learner to launch their session. Shadowing will start automatically once learner starts their session.",48+5)
}
elseif ($SessionState -ne 'Active')
{
$wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
$wshell.Popup("Learner has not connected to this VM at moment. Please ask learner to launch their session. Shadowing will start automatically once learner starts their session.",48+5)
}
else
{
mstsc /shadow:$Session /noConsentPrompt /control
}
'@
$shadowScript.Replace("vmAdminUsernameValue", $vmAdminUsername) | Set-Content -Path "C:\Users\Public\Documents\Shadow.ps1"

Stop-Transcript