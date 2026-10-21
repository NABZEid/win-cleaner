@echo off
chcp 65001 >nul
title Win Cleaner - CMD Admin Tools
setlocal EnableDelayedExpansion

:: ===== Auto minta akses Administrator =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Meminta akses Administrator...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ==========================================
echo        WIN CLEANER - CMD ADMIN TOOLS
echo ==========================================
echo.
echo  [1] Hapus bloatware
echo  [2] Bersihkan file sampah disk C dan D
echo  [3] Bersihkan cache foto / thumbnail
echo  [4] Optimasi settingan Windows
echo  [5] Jalankan SEMUA (1-4)
echo  [6] Buat restore point
echo  [0] Keluar
echo.
set /p pilih=Pilih menu: 

if "%pilih%"=="1" call :bloatware & goto selesai
if "%pilih%"=="2" call :sampah & goto selesai
if "%pilih%"=="3" call :foto & goto selesai
if "%pilih%"=="4" call :settingan & goto selesai
if "%pilih%"=="5" call :semua & goto selesai
if "%pilih%"=="6" call :restore & goto selesai
if "%pilih%"=="0" exit /b
goto menu

:selesai
echo.
echo Selesai. Tekan tombol apa saja untuk kembali ke menu...
pause >nul
goto menu

:: ------------------------------------------
:semua
call :restore
call :bloatware
call :sampah
call :foto
call :settingan
goto :eof

:: ------------------------------------------
:restore
echo.
echo [*] Membuat restore point...
powershell -NoProfile -Command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'WinCleaner' -RestorePointType MODIFY_SETTINGS -ErrorAction SilentlyContinue"
goto :eof

:: ------------------------------------------
:bloatware
echo.
echo [*] Menghapus bloatware...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\bloatware.ps1"
goto :eof

:: ------------------------------------------
:sampah
echo.
echo [*] Membersihkan file sampah...

echo     - Temp user dan sistem
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%d in ("%TEMP%\*") do rd /s /q "%%d" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%d in ("C:\Windows\Temp\*") do rd /s /q "%%d" >nul 2>&1

echo     - Prefetch, log, dump, error report
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
del /f /s /q "C:\Windows\Logs\CBS\*" >nul 2>&1
del /f /s /q "C:\Windows\Minidump\*" >nul 2>&1
del /f /q "C:\Windows\MEMORY.DMP" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft\Windows\WER" >nul 2>&1
rd /s /q "%LocalAppData%\Microsoft\Windows\WER" >nul 2>&1
rd /s /q "%LocalAppData%\CrashDumps" >nul 2>&1

echo     - Cache Windows Update
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
for /d %%d in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%d" >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1

echo     - Cache browser (Chrome, Edge, Firefox)
del /f /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*" >nul 2>&1
del /f /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Code Cache\*" >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*" >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Edge\User Data\Default\Code Cache\*" >nul 2>&1
for /d %%p in ("%LocalAppData%\Mozilla\Firefox\Profiles\*") do rd /s /q "%%p\cache2" >nul 2>&1

echo     - File sampah (.tmp .chk .dmp .old .gid) di disk C dan D
for %%D in (C D) do (
    if exist %%D:\ (
        echo       Disk %%D:
        del /f /s /q "%%D:\*.tmp" >nul 2>&1
        del /f /s /q "%%D:\*.chk" >nul 2>&1
        del /f /s /q "%%D:\*.dmp" >nul 2>&1
        del /f /s /q "%%D:\*.old" >nul 2>&1
        del /f /s /q "%%D:\*.gid" >nul 2>&1
        rd /s /q "%%D:\$RECYCLE.BIN" >nul 2>&1
        rd /s /q "%%D:\found.000" >nul 2>&1
    )
)

echo     - Kosongkan Recycle Bin
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo     - Bersihkan komponen Windows lama (DISM, agak lama)
dism /online /Cleanup-Image /StartComponentCleanup /Quiet

echo     - Flush DNS
ipconfig /flushdns >nul 2>&1
goto :eof

:: ------------------------------------------
:foto
echo.
echo [*] Membersihkan cache foto / thumbnail...
echo     (foto asli kamu TIDAK dihapus)
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /s /q "%LocalAppData%\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\*" >nul 2>&1
del /f /s /q "%LocalAppData%\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\LocalState\*cache*" >nul 2>&1
start explorer.exe
goto :eof

:: ------------------------------------------
:settingan
echo.
echo [*] Mengoptimasi settingan Windows...

echo     - Matikan telemetri
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1

echo     - Matikan iklan, saran, dan app otomatis
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul
for %%k in (SubscribedContent-338387Enabled SubscribedContent-338388Enabled SubscribedContent-338389Enabled SubscribedContent-310093Enabled SubscribedContent-353694Enabled SubscribedContent-353696Enabled SystemPaneSuggestionsEnabled SilentInstalledAppsEnabled PreInstalledAppsEnabled OemPreInstalledAppsEnabled SoftLandingEnabled RotatingLockScreenOverlayEnabled) do (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v %%k /t REG_DWORD /d 0 /f >nul
)

echo     - Matikan pencarian Bing di Start
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul

echo     - Matikan Game DVR
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul

echo     - Tampilkan ekstensi file dan file tersembunyi
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >nul

echo     - Power plan High Performance
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if %errorlevel% neq 0 (
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
)

echo     - Matikan hibernate (hemat ruang disk)
powercfg -h off >nul 2>&1

echo     - Matikan efek startup delay
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul

echo     - Restart Explorer agar settingan terbaca
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
goto :eof
