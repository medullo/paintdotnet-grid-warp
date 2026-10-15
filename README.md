# medullo Grid Warp

Editable grid warping on the main canvas in **Paint.NET 5.1.9 on Windows**.

## Install

Download the release ZIP. Close Paint.NET and copy these files into `Documents/paint.net App Files/Effects`:

```text
medullo.GridWarp.dll
medullo.GridWarp.Support/
  medullo.GridWarp.Runtime.dll
  0Harmony.dll
  0Harmony.LICENSE.txt
```

Restart Paint.NET. Choose **Effects > Tools > medullo Grid Warp**. No scripts or special launcher are required. [Controls](docs/GRID_WARP_GUIDE.md).

Pixel Studio is a separate repository and is not required. Grid Warp uses version-specific Paint.NET internals; other Paint.NET versions are not supported.

## Build

Requires Windows, the .NET 10 SDK, and Paint.NET 5.1.9. The plugin targets .NET 9.

```powershell
.\build.ps1
.\build.ps1 -PaintNetDir 'C:\Program Files\paint.net'
```

The release ZIP is written to `artifacts/releases/medullo-0.3.0/`.

## Checks

```powershell
dotnet run --project tests/Checks -c Release
```

Canvas and menu regression checks use a copied Paint.NET installation through the helpers in `tools/`.

[MIT License](LICENSE). Includes [Harmony](THIRD_PARTY_NOTICES.md).