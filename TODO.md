📋 Project Roadmap & TODO

This document outlines future enhancements, feature requests, and potential pivots for the Screenshot to JPG Converter project.
🎯 Phase 1: Domain Specific Adaptation (Cities: Skylines II)

Goal: Tailor the tool specifically for the Cities: Skylines II modding and sharing community. The current generic naming and folder structures are not optimized for game assets.

    Rename Output Folder
        Change default output folder from Sharing/ to CSII_Ready/ or Discord_Uploads/.
        Add a timestamp subfolder (e.g., CSII_Ready/2026-04-26/) to prevent overwriting daily screenshots.

    Update File Naming Convention
        Instead of IMAGE-000001.jpg, implement a pattern relevant to the game:
            Pattern: CSII_[CityName]_[Date]_[Index].jpg
            Challenge: Need to extract the city name from the screenshot filename or metadata (if available).
            Fallback: CSII_Screenshot_YYYYMMDD_HHMMSS.jpg.

    Metadata Preservation
        Investigate if ImageMagick or .NET can preserve or strip specific EXIF data relevant to game mods (e.g., mod version, map seed) without bloating the file.

    Specific Quality Presets
        Add a CLI argument or config option for "Discord Mode" (85% quality, max 8MB) vs. "Steam Workshop Mode" (95% quality, larger files).

🖥️ Phase 2: Graphical User Interface (GUI)

Goal: Make the tool accessible to non-technical users who prefer dragging and dropping files over running terminal commands.

    Cross-Platform GUI Framework
        Option A (Python): Use CustomTkinter or PyQt6 for a modern look. (Requires Python install).
        Option B (Electron/JS): Build a lightweight web-view app. (Heavier footprint).
        Option C (Native):
            Windows: WPF or WinUI 3.
            Linux: GTK4/Libadwaita.
        Decision: Python + CustomTkinter is likely the best balance of speed and cross-platform support.

    Core GUI Features
        Drag & Drop Zone: A central area to drop multiple PNG screenshots.
        Configuration Panel:
            Dropdown for Output Quality (Low, Medium, High).
            Text field for Output Folder path.
            Checkbox: "Overwrite existing files?"
        Progress Bar: Visual indicator of conversion progress.
        Log Window: Scrollable text area showing "Converted: city_01.png" in real-time.
        One-Click "Share to Discord" Button: (Bonus) Opens the output folder or copies file paths to clipboard.

    Packaging
        Compile the GUI script into a standalone .exe (Windows) and .AppImage (Linux) so users don't need Python installed.

🐛 Maintenance & Bug Fixes

    Error Handling Improvements
        Better error messages if a file is locked by another process.
        Graceful exit if the user cancels mid-process.
    Performance Optimization
        Multi-threading support for the GUI version to prevent freezing during large batches.
    Documentation Updates
        Add screenshots of the GUI (once built).
        Update README with CSII-specific examples.

Last Updated: April 26, 2026 Status: Planning Phase
