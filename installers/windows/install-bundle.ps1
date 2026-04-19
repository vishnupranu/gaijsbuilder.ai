# GSBUILDER.AI — Windows install from a flat extracted folder (same dir as gsbuilder-ai).
$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot
$Dest = Join-Path $env:LOCALAPPDATA "Programs\GSBuilder.AI"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
Copy-Item (Join-Path $Root "gsbuilder-ai") $Dest -Force
Copy-Item (Join-Path $Root "gsbuilder-ai.cmd") $Dest -Force
if (Test-Path (Join-Path $Root "gsbuilder.ai")) { Copy-Item (Join-Path $Root "gsbuilder.ai") $Dest -Force }
Copy-Item (Join-Path $Root "brand") (Join-Path $Dest "brand") -Recurse -Force
if (Test-Path (Join-Path $Root "app.ico")) {
  Copy-Item (Join-Path $Root "app.ico") $Dest -Force
}
$Bin = $Dest
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$Bin*") {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$Bin", "User")
  Write-Host "Added to user PATH: $Bin"
}
Write-Host "Installed to $Dest — open a new terminal, then: gsbuilder-ai.cmd version"
