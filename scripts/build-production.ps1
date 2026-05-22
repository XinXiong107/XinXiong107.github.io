param(
  [string]$OutputDir = "dist"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$out = Join-Path $root $OutputDir

if (Test-Path -LiteralPath $out) {
  Remove-Item -LiteralPath $out -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $out | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $out "assets") | Out-Null

Copy-Item -LiteralPath (Join-Path $root "index.html") -Destination (Join-Path $out "index.html") -Force
Copy-Item -LiteralPath (Join-Path $root "sw.js") -Destination (Join-Path $out "sw.js") -Force
Copy-Item -LiteralPath (Join-Path $root "assets\audio") -Destination (Join-Path $out "assets\audio") -Recurse -Force

$files = Get-ChildItem -LiteralPath $out -Recurse -File
$bytes = ($files | Measure-Object -Property Length -Sum).Sum

Write-Host "Production package created: $out"
Write-Host ("Files: {0}" -f $files.Count)
Write-Host ("Size: {0:N2} MB" -f ($bytes / 1MB))
Write-Host "Upload the contents of this folder to OSS/COS/CDN origin."

