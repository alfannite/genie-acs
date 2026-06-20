#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

banner_start() {
  clear
  echo -e "${CYAN}${BOLD}"
  echo "  ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ "
  echo "  ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗"
  echo "  ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝"
  echo "  ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗"
  echo "  ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║"
  echo "  ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
  echo -e "${NC}"
  echo -e "${BLUE}${BOLD}         Auto Install Docker — by Alfannite${NC}"
  echo -e "${YELLOW}  ─────────────────────────────────────────────────${NC}"
  echo ""
}

banner_success() {
  echo ""
  echo -e "${GREEN}${BOLD}"
  echo "  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗██╗"
  echo "  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝██║"
  echo "  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗██║"
  echo "  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║╚═╝"
  echo "  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║██╗"
  echo "  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝╚═╝"
  echo -e "${NC}"
  echo -e "${GREEN}${BOLD}         Docker berhasil terinstall! 🚀${NC}"
  echo -e "${YELLOW}  ─────────────────────────────────────────────────${NC}"
  echo ""
  echo -e "  ${BOLD}Connect with me:${NC}"
  echo ""
  echo -e "  ${CYAN}GitHub    ${NC}→  https://github.com/alfannite"
  echo -e "  ${RED}Instagram ${NC}→  https://instagram.com/alfan.niteops"
  echo ""
  echo -e "${YELLOW}  ─────────────────────────────────────────────────${NC}"
  echo ""
}

step() {
  echo -e "${CYAN}${BOLD}  [ * ] $1${NC}"
}

success_msg() {
  echo -e "${GREEN}${BOLD}  [ ✓ ] $1${NC}"
}

error_msg() {
  echo -e "${RED}${BOLD}  [ ✗ ] $1${NC}"
  exit 1
}

# ─── START ───
banner_start

echo -e "${BOLD}  Installer ini akan:${NC}"
echo -e "  • Clone repo Docker dari ${CYAN}github.com/alfannite/docker${NC}"
echo -e "  • Masuk ke folder ubuntu"
echo -e "  • Jalankan install.sh secara otomatis"
echo ""
echo -ne "${YELLOW}  Lanjutkan instalasi? (y/n): ${NC}"
read -r confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo ""
  echo -e "${RED}  Instalasi dibatalkan.${NC}"
  echo ""
  exit 0
fi

echo ""

# ─── CLONE ───
step "Cloning repository..."
sleep 1

if git clone https://github.com/alfannite/docker.git /tmp/alfannite-docker 2>/dev/null; then
  success_msg "Repository berhasil di-clone"
else
  error_msg "Gagal clone repository. Cek koneksi internet kamu."
fi

# ─── MASUK FOLDER ───
step "Masuk ke folder ubuntu..."
cd /tmp/alfannite-docker/ubuntu || error_msg "Folder ubuntu tidak ditemukan di repo."
success_msg "Berhasil masuk ke folder ubuntu"

# ─── PERMISSION ───
step "Memberikan izin eksekusi pada install.sh..."
chmod +x install.sh
success_msg "Permission berhasil diberikan"

# ─── INSTALL ───
step "Menjalankan install.sh..."
echo ""
echo -e "${YELLOW}  ─────────────────────────────────────────────────${NC}"
echo ""

sudo ./install.sh

EXIT_CODE=$?

echo ""
echo -e "${YELLOW}  ─────────────────────────────────────────────────${NC}"

if [ $EXIT_CODE -eq 0 ]; then
  banner_success
else
  echo ""
  error_msg "Instalasi gagal. Cek log di atas untuk detail error."
fi

# ─── CLEANUP ───
rm -rf /tmp/alfannite-docker