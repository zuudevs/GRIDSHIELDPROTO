#!/bin/bash
# Zuu's Env Switcher for Bash
# Usage: ./scripts/env.sh [native|avr]

MODE=$1
SCRIPT_DIR="$(dirname "$0")"
ROOT_DIR="$SCRIPT_DIR/.."

# Validasi argumen
if [ -z "$MODE" ]; then
    echo "[ERROR] Argumen tidak valid. Harap tentukan mode build."
    echo "Usage: ./scripts/env.sh [native|avr]"
    exit 1
fi

# Cek apakah file target ada
if [ ! -f "$ROOT_DIR/build/$MODE/compile_commands.json" ]; then
    echo "[ERROR] File 'compile_commands.json' tidak ditemukan di direktori 'build/$MODE'."
    echo "[INFO] Silakan jalankan perintah konfigurasi terlebih dahulu: cmake --preset $MODE"
    exit 1
fi

# Pindah ke root directory
cd "$ROOT_DIR" || exit

# Hapus link lama dan buat symlink baru
rm -f compile_commands.json
ln -sf "build/$MODE/compile_commands.json" "compile_commands.json"

echo "[SUCCESS] Konfigurasi Intellisense berhasil diubah ke mode: $MODE"