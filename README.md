# Win Cleaner - CMD Admin Tools

Tools CMD (Windows 10/11) untuk bersih-bersih PC sekali jalan.

## Fitur

| Menu | Fungsi |
|------|--------|
| 1 | Hapus bloatware (Bing News, Solitaire, Skype, Teams, TikTok, Netflix, dll) |
| 2 | Hapus file sampah di disk C dan D (temp, prefetch, log, dump, cache Windows Update, cache browser, Recycle Bin) |
| 3 | Bersihkan cache foto / thumbnail / icon (foto asli tidak dihapus) |
| 4 | Optimasi settingan (matikan telemetri, iklan, Game DVR, tampilkan ekstensi file, High Performance, dll) |
| 5 | Jalankan semua sekaligus |
| 6 | Buat restore point |

## Cara pakai

```cmd
git clone https://github.com/USERNAME/win-cleaner.git
cd win-cleaner
cleaner.bat
```

Script otomatis minta akses Administrator.

## Catatan

- Daftar bloatware bisa diedit di `scripts/bloatware.ps1`.
- Disarankan jalankan menu 6 (restore point) dulu sebelum menu lain.
- Hibernate dimatikan di menu 4. Kalau butuh, aktifkan lagi dengan `powercfg -h on`.
