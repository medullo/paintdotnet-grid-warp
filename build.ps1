param([string]$PaintNetDir = 'C:\Program Files\paint.net')

$ErrorActionPreference = 'Stop'
$version = '0.3.0'
$release = Join-Path $PSScriptRoot "artifacts\releases\medullo-$version"

function Build-Project([string]$project) {
    dotnet build (Join-Path $PSScriptRoot $project) -c Release --nologo "-p:PaintNetDir=$PaintNetDir"
    if ($LASTEXITCODE -ne 0) { throw "Build failed: $project" }
}

function Complete-Package([string]$name, [string]$guide, [string[]]$instructions) {
    $folder = Join-Path $release $name
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot $guide) -Destination $folder -Force
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'LICENSE') -Destination $folder -Force
    [IO.File]::WriteAllLines((Join-Path $folder 'INSTALL.txt'), $instructions)
    $zip = Join-Path $release "$name-$version.zip"
    Compress-Archive -Path (Join-Path $folder '*') -DestinationPath $zip -Force
    Write-Output "Ready: $zip"
}

Build-Project 'src\NativeLab\NativeLab.csproj'
Build-Project 'src\Menu\Menu.csproj'
$effects = Join-Path $release 'medullo-grid-warp\Effects'
$support = Join-Path $effects 'medullo.GridWarp.Support'
New-Item -ItemType Directory -Force -Path $support | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'src\Menu\bin\Release\net9.0-windows\medullo.GridWarp.dll') -Destination $effects -Force
foreach ($file in @('medullo.GridWarp.Runtime.dll', '0Harmony.dll')) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot "src\NativeLab\bin\Release\net9.0-windows\$file") -Destination $support -Force
}
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'third-party\Harmony.LICENSE.txt') -Destination (Join-Path $support '0Harmony.LICENSE.txt') -Force
Complete-Package 'medullo-grid-warp' 'docs\GRID_WARP_GUIDE.md' @(
    "medullo Grid Warp $version - Paint.NET 5.1.9",
    'Close Paint.NET. Copy medullo.GridWarp.dll and the medullo.GridWarp.Support folder into Effects. Restart.',
    'Choose Effects > Tools > medullo Grid Warp.'
)