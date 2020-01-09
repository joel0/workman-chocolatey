# Created by Joel May (https://github.com/Joel0) on 2020-01-09.

$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$localizedFile = 'workman-us\wm-us_i386.msi'
$localizedFile64 = 'workman-us\wm-us_amd64.msi'

# If the user is using using en-GB keyboard, install the UK variant of Workman.
if ($(Get-WinUserLanguageList)[0].LanguageTag -eq 'en-GB') {
    Write-Output "en-GB language detected. Installing UK variant of Workman. US variant is also available."
    $localizedFile = 'workman-uk\wm-uk_i386.msi'
    $localizedFile64 = 'workman-uk\wm-uk_amd64.msi'
} else {
    Write-Output "Installing default US variant of Workman. UK variant is also available."
}

$fileLocation = Join-Path $toolsDir $localizedFile
$file64Location = Join-Path $toolsDir $localizedFile64

Write-Debug "MSI log file will be at `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  file         = $fileLocation
  file64       = $file64Location

  softwareName  = 'Workman (*)'

  silentArgs    = "/qn /norestart /l+ `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
