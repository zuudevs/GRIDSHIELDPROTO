@echo off
title Git Helper
color 0b

:menu
cls
echo =========================================
echo          GIT AUTOMATION HELPER       
echo =========================================
echo.
echo 1) Git Init (Inisialisasi)
echo 2) Git Status
echo 3) Git Add & Commit
echo 4) Git Branch (Lihat & Buat)
echo 5) Git Log (Riwayat)
echo 6) Git Push
echo 7) Keluar
echo.
set /p choice=Masukkan pilihan Anda (1-7): 

if "%choice%"=="1" goto init
if "%choice%"=="2" goto status
if "%choice%"=="3" goto commit
if "%choice%"=="4" goto branch
if "%choice%"=="5" goto log
if "%choice%"=="6" goto push
if "%choice%"=="7" goto exit
echo Pilihan tidak valid. Silakan coba lagi.
timeout /t 2 >nul
goto menu

:init
cls
echo [Info]: Menjalankan git init...
if exist .git (
    echo Peringatan: Repository Git sudah ada di direktori ini.
) else (
    git init
    echo Sukses: Repository berhasil dibuat.
)
pause
goto menu

:status
cls
echo [Info]: Menampilkan status repository...
git status
pause
goto menu

:commit
cls
echo [Info]: Menambahkan semua file dan melakukan commit...
git add .
echo File telah ditambahkan ke staging area.
set /p msg=Masukkan pesan commit: 
if "%msg%"=="" (
    echo Kesalahan: Pesan commit wajib diisi.
) else (
    git commit -m "%msg%"
    echo Sukses: Commit berhasil disimpan.
)
pause
goto menu

:branch
cls
echo [Info]: Daftar Branch
git branch
echo.
set /p newbranch=Buat branch baru? (y/n): 
if /i "%newbranch%"=="y" (
    set /p bname=Masukkan nama branch: 
    git checkout -b %bname%
    echo Sukses: Branch dibuat dan aktif.
)
pause
goto menu

:log
cls
echo [Info]: Riwayat Log
git log --oneline --graph --all --decorate
pause
goto menu

:push
cls
echo [Info]: Push ke remote origin...
for /f %%i in ('git branch --show-current') do set current=%%i
echo Branch aktif: %current%
set /p confirm=Push ke origin/%current%? (y/n): 
if /i "%confirm%"=="y" (
    git push -u origin %current%
) else (
    echo Operasi dibatalkan.
)
pause
goto menu

:exit
echo Program selesai.
exit