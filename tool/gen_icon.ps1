# Generate app icon: two-tone capsule + green leaf (Natural Vitality theme).
# ASCII-only on purpose: Windows PowerShell 5.1 reads non-BOM files as ANSI,
# which can corrupt non-ASCII comments.
# Output: assets/icon/icon.png and assets/icon/icon_foreground.png
Add-Type -AssemblyName System.Drawing -ErrorAction SilentlyContinue
if (-not ('System.Drawing.Bitmap' -as [type])) {
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
}
$ErrorActionPreference = 'Stop'

$outDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\assets\icon'))
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function New-Mark {
    param([System.Drawing.Graphics]$g, [double]$scale)

    $g.TranslateTransform([float]512, [float]512)
    $g.RotateTransform([float]-32)
    $g.ScaleTransform([float]$scale, [float]$scale)

    $w = 470.0; $h = 232.0
    $x = -$w / 2; $y = -$h / 2
    $r = $h

    $honey = [System.Drawing.Color]::FromArgb(255, 242, 204, 143)
    $terra = [System.Drawing.Color]::FromArgb(255, 224, 122, 95)
    $ink = [System.Drawing.Color]::FromArgb(70, 62, 58, 51)
    $green = [System.Drawing.Color]::FromArgb(255, 95, 141, 78)
    $rib = [System.Drawing.Color]::FromArgb(150, 76, 115, 64)

    # whole capsule (honey)
    $capsule = New-Object -TypeName System.Drawing.Drawing2D.GraphicsPath
    $capsule.AddArc([float]$x, [float]$y, [float]$r, [float]$r, [float]90, [float]180)
    $capsule.AddArc([float]($x + $w - $r), [float]$y, [float]$r, [float]$r, [float]270, [float]180)
    $capsule.CloseFigure()
    $brHoney = New-Object -TypeName System.Drawing.SolidBrush -ArgumentList $honey
    $g.FillPath($brHoney, $capsule)

    # left half (terracotta)
    $left = New-Object -TypeName System.Drawing.Drawing2D.GraphicsPath
    $left.AddArc([float]$x, [float]$y, [float]$r, [float]$r, [float]90, [float]180)
    $left.AddLine([float]($x + $w / 2), [float]($y + $h), [float]($x + $w / 2), [float]$y)
    $left.CloseFigure()
    $brTerra = New-Object -TypeName System.Drawing.SolidBrush -ArgumentList $terra
    $g.FillPath($brTerra, $left)

    # edge + seam
    $penEdge = New-Object -TypeName System.Drawing.Pen -ArgumentList $ink, ([float]9)
    $g.DrawPath($penEdge, $capsule)
    $penSeam = New-Object -TypeName System.Drawing.Pen -ArgumentList ([System.Drawing.Color]::FromArgb(90, 62, 58, 51)), ([float]7)
    $g.DrawLine($penSeam, [float]($x + $w / 2), [float]$y, [float]($x + $w / 2), [float]($y + $h))

    # highlight
    $hl = New-Object -TypeName System.Drawing.SolidBrush -ArgumentList ([System.Drawing.Color]::FromArgb(70, 255, 255, 255))
    $g.FillEllipse($hl, [float]($x + 40), [float]($y + 26), [float]120, [float]44)

    # leaf above capsule
    $g.TranslateTransform([float]($x + $w * 0.72), [float]($y - 4))
    $g.RotateTransform([float]38)
    $L = 172.0; $H = 66.0
    $leaf = New-Object -TypeName System.Drawing.Drawing2D.GraphicsPath
    $leaf.StartFigure()
    $leaf.AddBezier([float]0, [float]0, [float]($L * 0.28), [float](- $H), [float]($L * 0.72), [float](- $H), [float]$L, [float]0)
    $leaf.AddBezier([float]$L, [float]0, [float]($L * 0.72), [float]$H, [float]($L * 0.28), [float]$H, [float]0, [float]0)
    $leaf.CloseFigure()
    $brLeaf = New-Object -TypeName System.Drawing.SolidBrush -ArgumentList $green
    $g.FillPath($brLeaf, $leaf)
    $penRib = New-Object -TypeName System.Drawing.Pen -ArgumentList $rib, ([float]5)
    $g.DrawLine($penRib, [float]8, [float]0, [float]($L - 8), [float]0)
}

function Save-Icon {
    param([string]$path, [bool]$withBackground, [double]$scale)

    $bmp = New-Object -TypeName System.Drawing.Bitmap -ArgumentList 1024, 1024
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.Clear([System.Drawing.Color]::Transparent)

    if ($withBackground) {
        $rect = New-Object -TypeName System.Drawing.Rectangle -ArgumentList 0, 0, 1024, 1024
        $c1 = [System.Drawing.Color]::FromArgb(255, 251, 248, 240)
        $c2 = [System.Drawing.Color]::FromArgb(255, 233, 241, 226)
        $lg = New-Object -TypeName System.Drawing.Drawing2D.LinearGradientBrush -ArgumentList $rect, $c1, $c2, ([System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)
        $g.FillRectangle($lg, $rect)
        $lg.Dispose()
    }

    New-Mark -g $g -scale $scale
    $g.Dispose()
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "generated: $path"
}

Save-Icon -path (Join-Path $outDir 'icon.png') -withBackground $true -scale 1.15
Save-Icon -path (Join-Path $outDir 'icon_foreground.png') -withBackground $false -scale 1.0
