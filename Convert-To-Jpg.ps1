# ==============================================================================
# Script: Convert-To-Jpg.ps1
# Purpose: Convert all PNG screenshots in the current directory to JPGs
#          and save them in a subfolder named "Sharing".
#          Skips files that already exist in the output folder.
# Usage:   .\Convert-To-Jpg.ps1
# ==============================================================================

# Configuration
$SourceDir = Get-Location
$TargetSubdir = "Sharing"
$Quality = 85
$Extension = "png"

# Colors for output
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$Reset = "`e[0m"

Write-Host "$Yellow🔍 Scanning for .$Extension files in: $($SourceDir.Path)$Reset"

# Check if ImageMagick is installed
try {
    $mogrifyPath = Get-Command mogrify -ErrorAction SilentlyContinue
    if (-not $mogrifyPath) {
        throw "Not found"
    }
} catch {
    Write-Host "$Red❌ Error: 'mogrify' (ImageMagick) is not installed.$Reset"
    Write-Host ""
    Write-Host "$Blue🛠️  Install ImageMagick for your system:$Reset"
    Write-Host "   • Windows (Chocolatey): choco install imagemagick"
    Write-Host "   • Windows (Scoop):      scoop install imagemagick"
    Write-Host "   • Windows (Manual):     Download from https://imagemagick.org/script/download.php"
    Write-Host "   • Ubuntu/Debian:        sudo apt install imagemagick"
    Write-Host "   • Fedora/RHEL:          sudo dnf install ImageMagick"
    Write-Host "   • Arch/Garuda:          sudo pacman -S imagemagick"
    Write-Host "   • macOS:                brew install imagemagick"
    Write-Host ""
    exit 1
}

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

# Get all PNG files in the current directory
$files = Get-ChildItem -Path $SourceDir.Path -Filter "*.$Extension" -File

if ($files.Count -eq 0) {
    Write-Host "$Yellow⚠️  No .$Extension files found in the current directory.$Reset"
    exit 0
}

Write-Host "$Green🚀 Processing $($files.Count) file(s)...$Reset"

foreach ($file in $files) {
    $totalFiles++
    $fileName = $file.BaseName
    $targetFile = Join-Path $TargetSubdir "$fileName.jpg"

    # Check if the target JPG already exists
    if (Test-Path $targetFile) {
        Write-Host "$Yellow⏭️  Skipping: $fileName.jpg (Already exists in $TargetSubdir)$Reset"
        $skipped++
    } else {
        # Convert the file using mogrify
        # -format jpg: Output as JPG
        # -quality 85: Set quality
        # -path Sharing: Save output to the Sharing subfolder
        # Note: We pass the full path of the source file
        $args = "-format", "jpg", "-quality", $Quality, "-path", $TargetSubdir, $file.FullName
        
        $result = & mogrify $args

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$Green✅ Converted: $fileName.png -> $fileName.jpg$Reset"
            $converted++
        } else {
            Write-Host "$Red❌ Failed to convert: $fileName.png$Reset"
        }
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
