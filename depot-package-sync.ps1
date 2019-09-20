$env:HAB_NOCOLORING='true'

if(-not [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) {
  write-host "Must be run as Administrator"
  exit 1
}

param (
    [Parameter(Mandatory=$true)][string]$onprem-token,
    [Parameter(Mandatory=$true)][string]$onprem-url,
    [Parameter(Mandatory=$true)][string]$package
)

write-host "Setting Public Env Vars"
$env:HAB_BLDR_URL='https://bldr.habitat.sh'
$env:HAB_ORIGIN='core'
remove-item env:HAB_AUTH_TOKEN

write-host "Downloading $PACKAGE"
hab pkg install $PACKAGE | Tee-Object -Variable OUTPUT
$p_ident = $OUTPUT | Select-String -Pattern 'Install of (.*?) ' -AllMatches | % { $_.matches.groups[1].value }
if ($p_ident -eq $null) {
  write-host "Package download failed."
  exit 1
}

$P_ORIGIN=$p_ident.split('/')[0]
$P_PACKAGE=$p_ident.split('/')[1]
$P_VERSION=$p_ident.split('/')[2]
$P_STAMP=$p_ident.split('/')[3] 
$P_FN="$P_ORIGIN-$P_PACKAGE-$P_VERSION-$P_STAMP*"

cd c:\hab\cache\artifacts

$P_PATH=resolve-path $P_FN

write-host "Setting Private Env Vars"
$env:HAB_BLDR_URL="$URL"
$env:HAB_ORIGIN='core'
$env:HAB_AUTH_TOKEN="$TOKEN"

write-host "Uploading $P_PATH"
hab pkg upload "$P_PATH" 
