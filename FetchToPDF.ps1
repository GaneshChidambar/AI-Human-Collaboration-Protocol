param(
    [Parameter(Mandatory=$true)]
    [string]$UrlListPath,
    [string]$OutputFolder = "$env:USERPROFILE\Desktop\AI-PDFs",
    [int]$WaitPerUrlSec = 4,
    [switch]$FileNameFromUrl
)

# Resolve Edge path
$edgeCandidates = @(
    "$Env:ProgramFiles (x86)\Microsoft\Edge\Application\msedge.exe",
    "$Env:ProgramFiles\Microsoft\Edge\Blueprint\Application\msedge.exe",
    "$Env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ }

if (-not $edgeCandidates -or $edgeCandidates.Count -eq 0) {
    Write-Error "Microsoft Edge (msedge.exe) not found. Please install Edge or add it to PATH."
    exit 1
}

$EdgePath = $edgeCandidates[0]

# Check inputs
if (-not (Test-Path $UrlListPath)) {
    Write-Error "UrlListPath not found: $UrlListPath"
    exit 1
}

# Create output folder
if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

$urls = Get-Content -Path $UrlListPath | Where-Object { $_ -and $_.Trim().Length -gt 0 }

$index = 0
foreach ($url in $urls) {
    $index++
    $safeName = ""
    if ($FileNameFromUrl) {
        $safeName = ($url -replace '[:/*?\"<>|]', '_').TrimEnd('_')
    } else {
        $safeName = ("page_{0:000}" -f $index)
    }

    $pdfPath = Join-Path $OutputFolder ($safeName + ".pdf")
    Write-Host "Printing to PDF: $url -> $pdfPath"

    # Start Edge headless print
    $arguments = @("--headless", "--disable-gpu", "--print-to-pdf=$pdfPath", "$url")
    $proc = Start-Process -FilePath $EdgePath -ArgumentList $arguments -PassThru

    # Wait a bit for heavy pages or JS rendering
    Start-Sleep -Seconds $WaitPerUrlSec

    try {
        if (!$proc.HasExited) {
            $proc.WaitForExit(15000) | Out-Null # 15 seconds max per page
        }
    } catch {
        Write-Warning "Edge instance handling encountered an issue for URL: $url"
    }
}

Write-Host "Done. PDFs in $OutputFolder"
