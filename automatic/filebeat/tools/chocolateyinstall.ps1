$ErrorActionPreference = 'Stop';

$packageName= 'filebeat'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.2-windows-x86_64.zip'
$url64      = 'https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.2-windows-x86_64.zip'

$installationPath = $toolsDir

$folder = if(Get-ProcessorBits 64) { [io.path]::GetFileNameWithoutExtension($url64) } else { [io.path]::GetFileNameWithoutExtension($url) }

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $installationPath
  url           = $url
  url64bit      = $url64
  checksum      = 'b11b495c21d30368866d805b3d94f0a55fe3ab3d8862b50eb2ad81dc0e32cdf057830efb4474f2a300a5784343c20cbed54caf8a6fa40f96aae0934dabc1bac1'
  checksumType  = 'sha512'
  checksum64    = 'b11b495c21d30368866d805b3d94f0a55fe3ab3d8862b50eb2ad81dc0e32cdf057830efb4474f2a300a5784343c20cbed54caf8a6fa40f96aae0934dabc1bac1'
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
