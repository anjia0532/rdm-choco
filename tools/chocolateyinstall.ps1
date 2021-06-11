$ErrorActionPreference = 'Stop';

$softwareName = 'win-rdm*'
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
    Invoke-Expression -Command $PSScriptRoot\chocolateyUninstall.ps1
}

$url = 'https://github.com/lework/RedisDesktopManager-Windows/releases/download/2021.5/rdm-2021.5.zip'
$sha256sum = '7074ef7dde9d70becfc549997afec495e971fbc23e2099af0721293365511db0'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
if ([System.Environment]::Is64BitOperatingSystem) {
    $programFiles = $env:ProgramFiles
}
else {
    $programFiles = ${env:ProgramFiles(x86)}
}
$installDir = "$programFiles\win-rdm"

$pp = Get-PackageParameters
if ($pp.InstallDir) {
    $installDir = $pp.InstallDir
}

$silentArgs = "/S /D=$installDir"

New-Item -ItemType Directory -Force -Path $installDir

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    url64bit       = $url

    softwareName   = $softwareName

    checksum       = $sha256sum
    checksumType   = 'sha256'
    checksum64     = $sha256sum
    checksumType64 = 'sha256'

    silentArgs     = $silentArgs
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyZipPackage @packageArgs