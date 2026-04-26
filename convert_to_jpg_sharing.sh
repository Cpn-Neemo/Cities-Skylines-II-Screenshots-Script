#!/bin/bash

# ==============================================================================
# Script: convert_to_jpg.sh
# Purpose: Convert all PNG screenshots in the current directory to JPGs
#          and save them in a subfolder named "Sharing".
#          Skips files that already exist in the output folder.
# Usage:   ./convert_to_jpg.sh
# ==============================================================================

# Configuration
SOURCE_DIR="$(pwd)"          # Current directory where script is run
TARGET_SUBDIR="Sharing"      # Name of the subfolder for output
QUALITY=85                   # JPEG quality (0-100). 85 is good for web/Discord.
EXTENSION="png"              # Input file extension to look for

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 Scanning for .${EXTENSION} files in: ${SOURCE_DIR}${NC}"

# Check if ImageMagick is installed
if ! command -v mogrify &> /dev/null; then
    echo -e "${RED}❌ Error: 'mogrify' (ImageMagick) is not installed.${NC}"
    echo ""
    echo -e "${BLUE}🛠️  Install ImageMagick for your distribution:${NC}"
    echo "   • Ubuntu/Debian/Mint:   sudo apt install imagemagick"
    echo "   • Fedora/RHEL/CentOS:   sudo dnf install ImageMagick"
    echo "   • Arch/Garuda/Manjaro:  sudo pacman -S imagemagick"
    echo "   • macOS (Homebrew):     brew install imagemagick"
    echo "   • Windows (Chocolatey): choco install imagemagick"
    echo ""
    exit 1
fi

# Create the target folder if it doesn't exist
if [ ! -d "$TARGET_SUBDIR" ]; then
    echo -e "${GREEN}📁 Creating folder: ${TARGET_SUBDIR}${NC}"
    mkdir -p "$TARGET_SUBDIR"
else
    echo -e "${GREEN}✅ Folder '${TARGET_SUBDIR}' already exists.${NC}"
fi

# Initialize counters
TOTAL_FILES=0
CONVERTED=0
SKIPPED=0

# Find all PNG files in the current directory (maxdepth 1 ensures we don't go into subfolders)
while IFS= read -r -d '' file; do
    TOTAL_FILES=$((TOTAL_FILES + 1))

    # Get the base filename without extension
    filename=$(basename "$file" .${EXTENSION})
    target_file="${TARGET_SUBDIR}/${filename}.jpg"

    # Check if the target JPG already exists
    if [ -f "$target_file" ]; then
        echo -e "${YELLOW}⏭️  Skipping: ${filename}.jpg (Already exists in ${TARGET_SUBDIR})${NC}"
        SKIPPED=$((SKIPPED + 1))
    else
        # Convert the file
        mogrify -format jpg -quality $QUALITY -path "$TARGET_SUBDIR" "$file"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Converted: ${filename}.png -> ${filename}.jpg${NC}"
            CONVERTED=$((CONVERTED + 1))
        else
            echo -e "${RED}❌ Failed to convert: ${filename}.png${NC}"
        fi
    fi
done < <(find "$SOURCE_DIR" -maxdepth 1 -name "*.${EXTENSION}" -print0)

# Final Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Summary:${NC}"
echo -e "   Total PNGs found:   ${TOTAL_FILES}"
echo -e "   Converted:          ${CONVERTED}"
echo -e "   Skipped (exists):   ${SKIPPED}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  No .${EXTENSION} files found in the current directory.${NC}"
fi

if [ "$CONVERTED" -gt 0 ]; then
    echo -e "${GREEN}✅ Done! New images saved to: ${SOURCE_DIR}/${TARGET_SUBDIR}/${NC}"
    echo -e "   You can now upload the .jpg files to Discord."
fi
