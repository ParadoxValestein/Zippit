# Backup Zip Script

Zippit is a zip‑file compression script, made to quickly back up any folder without having to hunt it down manually.
I made this because constantly having to zip my project folder myself was a pain in the bumm :)

This script will compress your file/folder into a zip file using Windows PowerShell’s `Compress-Archive`, and uses the highest “Optimal” deflate setting.  
PowerShell uses .NET’s `System.IO.Compression` with deflate-level 9 by default.

No additional programs are needed, as this uses PowerShell, which comes with Windows.

---

## Supports

- **Windows 10 and later** → works immediately  
- **Windows Server 2016 and later** → works immediately  
- **Windows 7 / 8.1** → batch runs, but you must install WMF 5.x first

---

## How to use

1. Run the `.bat` file.  
2. Enter the full path of the file or folder you want to compress, then press **Enter**.  
3. When prompted, enter the number of leading zeroes for the file counter  
   - e.g. `3` → `ExampleFolder Backup 001`  
   - `0` → `ExampleFolder Backup 1`  
4. Press **Enter** again and the script will finish.

