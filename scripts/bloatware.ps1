# Hapus bloatware bawaan Windows dan app sponsor
# Edit daftar $bloat sesuai selera. App penting (Store, Kalkulator, Notepad, Foto, dll) sengaja TIDAK dihapus.

$bloat = @(
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.BingFinance",
    "Microsoft.BingSports",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.Office.OneNote",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.549981C3F5F10",          # Cortana
    "Clipchamp.Clipchamp",
    "MicrosoftTeams",
    "MSTeams",
    "Microsoft.Copilot",
    "MicrosoftCorporationII.QuickAssist",
    "*CandyCrush*",
    "*Disney*",
    "*Spotify*",
    "*TikTok*",
    "*Instagram*",
    "*Facebook*",
    "*Twitter*",
    "*Netflix*",
    "*LinkedIn*",
    "*AmazonPrimeVideo*",
    "*Amazon.com*",
    "*Hulu*",
    "*Duolingo*",
    "*Flipboard*",
    "*Pandora*",
    "*Royal Revolt*",
    "*March of Empires*",
    "*FarmVille*",
    "*Roblox*",
    "*McAfee*",
    "*Dolby*"
)

foreach ($app in $bloat) {
    Write-Host "  - $app" -ForegroundColor Cyan

    # Hapus untuk semua user yang sudah ada
    Get-AppxPackage -AllUsers -Name $app -ErrorAction SilentlyContinue |
        Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

    # Hapus dari paket provisioned supaya tidak muncul lagi di user baru
    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like $app } |
        Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
}

# Hapus OneDrive (opsional, hapus tanda # di bawah kalau mau)
# Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
# $od = "$env:SystemRoot\System32\OneDriveSetup.exe"
# if (Test-Path "$env:SystemRoot\SysWOW64\OneDriveSetup.exe") { $od = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" }
# Start-Process $od "/uninstall" -Wait

Write-Host ""
Write-Host "Bloatware selesai dihapus." -ForegroundColor Green
