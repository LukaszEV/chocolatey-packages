$ErrorActionPreference = 'Stop';

$packageName= 'metricbeat'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.5.2-windows-x86_64.zip'
$url64      = 'https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.5.2-windows-x86_64.zip'

$installationPath = $toolsDir

$folder = if(Get-ProcessorBits 64) { [io.path]::GetFileNameWithoutExtension($url64) } else { [io.path]::GetFileNameWithoutExtension($url) }

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installationPath
  url           = $url
  url64bit      = $url64
  checksum      = 'F65C9F127938070C2856FE1F21BC2D774B2CF465D36615B793C7D44D59561F8C7C312EF8F6E20C12CA9F1ECBA5EC56EE6C6F0FD48EBA64F42DDCE54FB9830356'
  checksumType  = 'sha512'
  checksum64    = 'F65C9F127938070C2856FE1F21BC2D774B2CF465D36615B793C7D44D59561F8C7C312EF8F6E20C12CA9F1ECBA5EC56EE6C6F0FD48EBA64F42DDCE54FB9830356'
  checksumType64= 'sha512'
  specificFolder = $folder
}

Install-ChocolateyZipPackage @packageArgs

# Move everything from the subfolder to the main tools directory
$subFolder = Join-Path $installationPath (Get-ChildItem $installationPath $folder | ?{ $_.PSIsContainer })
Get-ChildItem $subFolder -Recurse | ?{$_.PSIsContainer } | Move-Item -Destination $installationPath
Get-ChildItem $subFolder | ?{$_.PSIsContainer -eq $false } | Move-Item -Destination $installationPath
Remove-Item "$subFolder"

Invoke-Expression $(Join-Path $installationPath "install-service-$($packageName).ps1")
