# GSBUILDER.AI — Windows install when run from a git clone (paths use repo root).
# For a flat zip bundle, use install-bundle.ps1 (shipped as install.ps1 inside the zip).
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Dest = Join-Path $env:LOCALAPPDATA "Programs\GSBuilder.AI"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item (Join-Path $Root "gsbuilder-ai") $Dest -Force
Copy-Item (Join-Path $Root "installers\windows\gsbuilder-ai.cmd") $Dest -Force
if (Test-Path (Join-Path $Root "gsbuilder.ai")) { Copy-Item (Join-Path $Root "gsbuilder.ai") $Dest -Force }
Copy-Item (Join-Path $Root "brand") (Join-Path $Dest "brand") -Recurse -Force
if (Test-Path (Join-Path $Root "dist\windows\app.ico")) {
  Copy-Item (Join-Path $Root "dist\windows\app.ico") $Dest -Force
}
$Bin = $Dest
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$Bin*") {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$Bin", "User")
  Write-Host "Added to user PATH: $Bin"
}
Write-Host "Installed to $Dest"
Write-Host "Run: gsbuilder-ai.cmd version   (open a new terminal after PATH update)"
Write-Host "Or:  & `"$Dest\gsbuilder-ai.cmd`" version"
