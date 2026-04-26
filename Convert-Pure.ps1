# ==============================================================================
# Script: Convert-Pure.ps1
# Purpose: Convert PNGs to JPGs using built-in Windows .NET libraries.
#          NO EXTERNAL SOFTWARE REQUIRED.
# Usage:   .\Convert-Pure.ps1
# ==============================================================================

# Configuration
$SourceDir = Get-Location
$TargetSubdir = "Sharing"
$Quality = 85  # 0-100 (85 is great for web/Discord)
$Extension = "png"

# Colors
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$Reset = "`e[0m"

Write-Host "$Yellow🔍 Scanning for .$Extension files in: $($SourceDir.Path)$Reset"

# Create the target folder if it doesn't exist
if (-not (Test-Path $TargetSubdir)) {
    Write-Host "$Green📁 Creating folder: $TargetSubdir$Reset"
    New-Item -ItemType Directory -Path $TargetSubdir | Out-Null
} else {
    Write-Host "$Green✅ Folder '$TargetSubdir' already exists.$Reset"
}

# Initialize counters
$totalFiles = 0
$converted = 0
$skipped = 0

# Get all PNG files
$files = Get-ChildItem -Path $SourceDir.Path -Filter "*.$Extension" -File

if ($files.Count -eq 0) {
    Write-Host "$Yellow⚠️  No .$Extension files found in the current directory.$Reset"
    exit 0
}

Write-Host "$Green🚀 Processing $($files.Count) file(s) using built-in Windows tools...$Reset"

# Load the .NET Image assembly
Add-Type -AssemblyName System.Drawing

foreach ($file in $files) {
    $totalFiles++
    $fileName = $file.BaseName
    $targetFile = Join-Path $TargetSubdir "$fileName.jpg"

    # Check if the target JPG already exists
    if (Test-Path $targetFile) {
        Write-Host "$Yellow⏭️  Skipping: $fileName.jpg (Already exists)$Reset"
        $skipped++
        continue
    }

    try {
        # Load the PNG
        $image = [System.Drawing.Image]::FromFile($file.FullName)
        
        # Create an encoder for JPEG
        $jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        
        # Create EncoderParameters for Quality
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $Quality)
        
        # Save as JPG
        $image.Save($targetFile, $jpegEncoder, $encoderParams)
        
        Write-Host "$Green✅ Converted: $fileName.png -> $fileName.jpg$Reset"
        $converted++
        
        # Clean up memory
        $image.Dispose()
    }
    catch {
        Write-Host "$Red❌ Failed to convert: $fileName.png ($($_.Exception.Message))$Reset"
    }
}

# Final Summary
Write-Host ""
Write-Host "$Blue━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$Reset"
Write-Host "$Blue📊 Summary:$Reset"
Write-Host "   Total PNGs found:   $totalFiles"
Write-Host "   Converted:          $converted"
Write-Host "   Skipped (exists):   $skipped"
Write-Host "$Blue━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$Reset"

if ($converted -gt 0) {
    Write-Host "$Green✅ Done! New images saved to: $($SourceDir.Path)\$TargetSubdir\$Reset"
    Write-Host "   You can now upload the .jpg files to Discord."
}
