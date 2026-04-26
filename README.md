🖼️ Screenshot to JPG Converter

A lightweight, cross-platform tool to batch convert PNG screenshots into optimized JPG files for easy sharing on Discord, social media, or the web.

This repository contains two scripts designed to handle the same task on different operating systems:

    Linux/macOS: A Bash script using ImageMagick (fast, efficient).
    Windows: A PowerShell script using built-in .NET libraries (no installation required).

Both scripts automatically create a Sharing subfolder, skip files that have already been converted, and provide a summary of the operation.
⚠️ Important Disclaimer & Usage Warning

    🤖 AI-Assisted Development

    These scripts were generated with the assistance of an Artificial Intelligence (AI) model. While the logic has been tested in controlled environments, they have not undergone a thorough, professional security audit or extensive stress testing.

    Before using these scripts for everyday production tasks:

        Review the code: Understand what the script does before running it.
        Backup your data: Always keep a backup of your original PNG files.
        Test on a small batch: Run the script on a few dummy images first to ensure it behaves as expected on your specific system.
        Verify paths: Ensure the script is run from the correct directory.

    Use at your own risk. The author assumes no liability for data loss or unintended behavior.

🚀 Features

    Batch Conversion: Converts all .png files in the current directory to .jpg.
    Smart Skipping: Automatically detects if a .jpg already exists in the output folder and skips it (idempotent).
    Optimized Output: Saves images at 85% quality, balancing file size and visual fidelity for web/Discord.
    Organized Output: Creates a Sharing/ subfolder to keep converted files separate from originals.
    Detailed Logging: Provides a color-coded summary of total files, converted files, and skipped files.
    Cross-Platform: Works on Linux, macOS, and Windows.

🐧 Linux & macOS (Bash + ImageMagick)
Prerequisites

You need ImageMagick installed.

    Arch/Garuda: sudo pacman -S imagemagick
    Ubuntu/Debian: sudo apt install imagemagick
    Fedora: sudo dnf install ImageMagick
    macOS: brew install imagemagick

Usage

    Navigate to your screenshots folder:

    cd ~/Pictures/Screenshots

    Make the script executable:

    chmod +x convert_to_jpg.sh

    Run the script:

    ./convert_to_jpg.sh

Output

Converted files will appear in ./Sharing/.
🪟 Windows (PowerShell)
Option A: No Installation Required (Pure .NET)

Uses built-in Windows libraries. Best for quick tasks without installing software.

    File: Convert-Pure.ps1
    Requirements: None (Works on Windows 7+).

Option B: Faster Performance (ImageMagick)

Requires ImageMagick installation but is faster for large batches.

    File: Convert-To-Jpg.ps1
    Requirements: Install ImageMagick (see below).

Installation (Optional - for Option B)

If you want to use the ImageMagick version:

    Scoop: scoop install imagemagick
    Chocolatey: choco install imagemagick
    Manual: Download from imagemagick.org

Usage

    Navigate to your screenshots folder in File Explorer.
    Right-click in the folder → Open in Terminal (or open PowerShell here).
    Enable Execution Policy (Run once as Administrator if you get an error):

    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

    Run the script:

    .\Convert-Pure.ps1
    # OR
    .\Convert-To-Jpg.ps1

