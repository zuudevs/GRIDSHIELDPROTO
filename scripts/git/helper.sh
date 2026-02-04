#!/bin/bash

# Konfigurasi Warna Tampilan
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fungsi Header Tampilan
show_header() {
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}          GIT AUTOMATION HELPER          ${NC}"
    echo -e "${BLUE}=========================================${NC}"
}

# Menu Utama
while true; do
    show_header
    echo "Menu Operasi Git:"
    echo "1) Git Init (Inisialisasi repository baru)"
    echo "2) Git Status (Cek status file)"
    echo "3) Git Add & Commit (Simpan perubahan)"
    echo "4) Git Branch (Manajemen Branch)"
    echo "5) Git Log (Riwayat Commit)"
    echo "6) Git Push (Unggah ke remote)"
    echo "7) Keluar"
    echo -e "${BLUE}=========================================${NC}"
    read -p "Masukkan pilihan Anda (1-7): " choice

    case $choice in
        1)
            echo -e "\n${GREEN}[Info]: Menjalankan git init...${NC}"
            if [ -d ".git" ]; then
                echo -e "${RED}Peringatan: Direktori ini sudah memiliki inisialisasi Git (.git).${NC}"
            else
                git init
                echo -e "${GREEN}Sukses: Repository berhasil diinisialisasi.${NC}"
            fi
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        2)
            echo -e "\n${GREEN}[Info]: Memeriksa status repository...${NC}"
            git status
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        3)
            echo -e "\n${GREEN}[Info]: Memulai proses staging dan commit...${NC}"
            git add .
            echo "Semua perubahan telah ditambahkan ke stage (git add .)."
            read -p "Masukkan pesan commit: " commit_msg
            if [ -z "$commit_msg" ]; then
                echo -e "${RED}Kesalahan: Pesan commit tidak boleh kosong. Operasi dibatalkan.${NC}"
            else
                git commit -m "$commit_msg"
                echo -e "${GREEN}Sukses: Commit berhasil dibuat.${NC}"
            fi
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        4)
            echo -e "\n${GREEN}[Info]: Manajemen Branch${NC}"
            echo "Daftar branch saat ini:"
            git branch
            read -p "Apakah Anda ingin membuat branch baru? (y/n): " create_branch
            if [ "$create_branch" == "y" ]; then
                read -p "Masukkan nama branch baru: " branch_name
                git checkout -b "$branch_name"
                echo -e "${GREEN}Sukses: Branch '$branch_name' telah dibuat dan diaktifkan.${NC}"
            fi
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        5)
            echo -e "\n${GREEN}[Info]: Riwayat Commit (Log)${NC}"
            git log --oneline --graph --all --decorate
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        6)
            echo -e "\n${GREEN}[Info]: Push ke remote repository${NC}"
            current_branch=$(git branch --show-current)
            read -p "Push branch '$current_branch' ke origin? (y/n): " confirm_push
            if [ "$confirm_push" == "y" ]; then
                git push -u origin "$current_branch"
            else
                echo "Operasi dibatalkan oleh pengguna."
            fi
            read -p "Tekan Enter untuk melanjutkan..."
            ;;
        7)
            echo "Keluar dari program. Terima kasih."
            exit 0
            ;;
        *)
            echo -e "${RED}Kesalahan: Pilihan tidak valid. Silakan masukkan angka 1-7.${NC}"
            sleep 1
            ;;
    esac
done