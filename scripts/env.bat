@echo off
:: Zuu's Env Switcher for Windows (CMD) - Fixed Version
:: Usage: scripts\env.bat [native|avr]

setlocal
set "MODE=%1"
set "ROOT_DIR=%~dp0.."

:: Validasi argumen
if "%MODE%"=="" (
    echo [ERROR] Mana argumennya? Jangan males!
    echo Usage: scripts\env.bat [native^|avr]
    exit /b 1
)

:: Cek apakah file target ada
if not exist "%ROOT_DIR%\build\%MODE%\compile_commands.json" (
    echo [ERROR] File compile_commands.json di build/%MODE% gak ada!
    echo [INFO] Jalanin dulu: cmake --preset %MODE%
    exit /b 1
)

:: Hapus link lama kalau ada
if exist "%ROOT_DIR%\compile_commands.json" (
    del "%ROOT_DIR%\compile_commands.json"
)

:: Masuk ke root dir dulu biar link-nya bener
pushd "%ROOT_DIR%"

:: Coba bikin Symlink (Butuh Developer Mode atau Run as Admin)
mklink "compile_commands.json" "build\%MODE%\compile_commands.json" >nul 2>&1

if %errorlevel% neq 0 (
    :: Hapus tanda kurung di pesan ini biar script gak error!
    echo [WARNING] Gagal bikin Symlink. Mungkin kurang privilege? Aku copy file aja ya.
    copy "build\%MODE%\compile_commands.json" "compile_commands.json" >nul
) else (
    echo [SUCCESS] Intellisense sekarang pake mode: %MODE%
)

popd
endlocal