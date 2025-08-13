# BlackBull PC Cleaner

**Version:** `1.0.0.7`  
A Windows batch script that helps clean, optimize and maintain a PC. Includes an auto-update mechanism that fetches the latest script from GitHub so you can keep the tool up-to-date automatically.

---

## Table of contents
- [Features](#features)  
- [How it works](#how-it-works)  
- [Menu options](#menu-options)  
- [FPS Boost (details)](#fps-boost-details)  
- [Requirements](#requirements)  
- [Usage](#usage)  
- [Security & warnings](#security--warnings)  
- [How auto-update works](#how-auto-update-works)  
- [Disable auto-update (optional)](#disable-auto-update-optional)  
- [Contributing](#contributing)  
- [License](#license)  
- [Changelog](#changelog)

---

## Features
- Auto-update: checks a GitHub-hosted file for latest version and updates the script automatically.
- One-menu access to common maintenance tasks:
  - Malware Removal Tool (MRT)
  - `winget` bulk updates for applications
  - Clear temporary files
  - Empty Recycle Bin
  - Flush DNS cache
  - Clean Windows Update cache
  - Run `sfc /scannow` and `DISM /RestoreHealth`
  - Disk Cleanup
- Gaming / FPS Boost submenu with multiple tweaks (service management, registry tweaks, power plan, Xbox/Game Bar disable, GPU cache cleaning, network reset, etc.)
- Ability to revert FPS Boost tweaks.

---

## How it works
When launched the script:
1. Downloads the "latest version" number from GitHub.
2. Compares it with the script's embedded `current_version`.
3. If a newer version exists on GitHub it downloads the new script and replaces the running script file, then restarts.
4. Presents a text menu where you pick maintenance tasks. Each selection runs native Windows utilities/commands.

---

## Menu options
The menu shows options and runs the corresponding action:

- **[1] Run MRT (Malware Removal Tool)** — starts Windows MRT (built-in quick scanner).
- **[2] Update all programs** — runs `winget upgrade --all` to update installed apps (requires `winget`).
- **[3] Clear Temp Files** — deletes `%temp%` and `C:\Windows\Temp`.
- **[4] Empty Recycle Bin** — runs PowerShell `Clear-RecycleBin -Force`.
- **[5] Flush DNS Cache** — runs `ipconfig /flushdns`.
- **[6] Clean Windows Update Cache** — stops Windows Update services, removes `C:\Windows\SoftwareDistribution`, restarts services.
- **[7] Run SFC (System File Checker)** — `sfc /scannow`.
- **[8] Run DISM (Restore Health)** — `DISM /Online /Cleanup-Image /RestoreHealth`.
- **[9] Improve FPS / Gaming Mode** — opens the FPS Boost submenu (see below).
- **[10] Exit** — closes the script.
- **[11] Run Disk Cleanup** — runs `cleanmgr.exe /sagerun:1`.

---

## FPS Boost (details)
The FPS Boost submenu contains options to apply or revert multiple performance-oriented changes:

- **Install FPS Boost**:
  - Stops and disables services: `SysMain`, `DiagTrack`, `WSearch`, `Fax`.
  - Disables transparency and animations via registry.
  - Disables Game Mode pre-launch features and Edge prelaunch/background features via registry.
  - Many changes may require restart.

- **Reset FPS Boost**:
  - Re-enables services and registry entries changed by the install step.

- **Other FPS submenu items**:
  - Disable notifications / focus assist (registry).
  - Set High Performance power plan: `powercfg /setactive SCHEME_MIN`.
  - Disable Xbox Game Bar & DVR and stop related services.
  - Reset network: release/renew, winsock reset, IP reset.
  - Clean GPU cache (NVIDIA GLCache & DXCache).
  - Clear clipboard.
  - Disable Windows Tips.
  - Adjust visual effects for best performance (registry).
  - Reset all FPS Boost tweaks (runs same revert commands as Reset).

---

## Requirements
- Windows 10 / Windows 11 (designed for modern Windows).
- Administrative privileges for most actions (service stop/start, registry edits, deleting system folders).
- `curl` available at `%SystemRoot%\System32\curl.exe` (modern Windows includes curl).
- `winget` installed for the "Update all programs" option (optional).
- Running from a local disk (recommended) for safe updating.

---

## Usage
1. Save the batch script (e.g. `CleanPC.bat`) to a location on your machine (e.g., `C:\Tools\CleanPC.bat`).
2. **Run as Administrator**:
   - Right-click → **Run as administrator**, or
   - Open an elevated Command Prompt and run:
     ```cmd
     C:\Tools\CleanPC.bat
     ```
3. Follow text menu prompts to choose an action.

---

## Security & warnings
- **Backup first**: Some operations modify the registry or stop services. Create a restore point or backup important data before using the script.
- **Admin required**: Many functions will fail without elevated privileges.
- **Windows Update cache deletion**: Deleting `C:\Windows\SoftwareDistribution` will remove update download cache; downloads will be re-fetched if needed.
- **Service changes**: Disabling services like `SysMain` (Superfetch) or `WSearch` may affect non-gaming performance (search indexing, prefetch benefits).
- **Registry edits**: Modifying registry values can have unintended side effects. Use caution.
- **Use only trusted sources**: Auto-update downloads the updated script from the `version_url` / `script_url` defined in the script — make sure those URLs point to a trusted GitHub repository.

---

## How auto-update works
- The script reads `current_version` (embedded in the script).
- It downloads a text file `latest_version.txt` from the configured `version_url` (GitHub raw link).
- If `latest_version` != `current_version`, it downloads the new batch file from `script_url` and overwrites the running script, then restarts.
- The script uses the Windows `curl` binary at `%SystemRoot%\System32\curl.exe`.

---

## Disable auto-update (optional)
If you prefer updates to be manual, remove or comment the auto-update section at the top (the `curl` download and compare logic). Alternatively set the `version_url` and `script_url` variables to empty strings to skip the check.

---

## Contributing
- Fork the repo, make changes and open a PR.
- Keep the `current_version` updated when merging changes.
- Ensure any new tools or commands are documented and checked for admin requirements.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
