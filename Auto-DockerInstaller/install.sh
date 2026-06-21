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
  echo "      ██████╗██╗      ██████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗ "
  echo "     ██╔════╝██║     ██╔═══██╗████╗  ██║██║████╗  ██║██╔════╝ "
  echo "     ██║     ██║     ██║   ██║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗"
  echo "     ██║     ██║     ██║   ██║██║╚██╗██║██║██║╚██╗██║██║   ██║"
  echo "     ╚██████╗███████╗╚██████╔╝██║ ╚████║██║██║ ╚████║╚██████╔╝"
  echo "      ╚═════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "
  echo ""
}

banner_cancel() {
  clear
  echo -e "${YELLOW}${BOLD}"
  echo "  ██████╗ ██╗   ██╗███████╗"
  echo "  ██╔══██╗╚██╗ ██╔╝██╔════╝"
  echo "  ██████╔╝ ╚████╔╝ █████╗  "
  echo "  ██╔══██╗  ╚██╔╝  ██╔══╝  "
  echo "  ██████╔╝   ██║   ███████╗ "
  echo "  ╚═════╝    ╚═╝   ╚══════╝ "
  echo -e "${NC}"
  echo -e "${YELLOW}${BOLD}         Instalasi dibatalkan.${NC}"
  echo -e "${YELLOW}  ────────────────────────────────────────────────────${NC}"
  echo ""
}

banner_success() {
  clear
  echo -e "${GREEN}${BOLD}"
  echo "  ███████╗██╗   ██╗ ██████╗ ██████╗███████╗███████╗███████╗██╗"
  echo "  ██╔════╝██║   ██║██╔════╝██╔════╝██╔════╝██╔════╝██╔════╝██║"
  echo "  ███████╗██║   ██║██║     ██║     █████╗  ███████╗███████╗██║"
  echo "  ╚════██║██║   ██║██║     ██║     ██╔══╝  ╚════██║╚════██║╚═╝"
  echo "  ███████║╚██████╔╝╚██████╗╚██████╗███████╗███████║███████║██╗"
  echo "  ╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝╚══════╝╚══════╝╚══════╝╚═╝"
  echo ""
  echo -e "${YELLOW}  ────────────────────────────────────────────────────${NC}"
  echo ""
  echo -e "  ${BOLD}Lanjut install GenieACS, Caranya lihat di GitHub nya ya...${NC}"
  echo ""
  echo -e "  ${BOLD}My Links Sosial media :)${NC}"
  echo ""
  echo -e "  ${CYAN}GitHub    ${NC}→  https://github.com/alfannite"
  echo -e "  ${RED}Instagram ${NC}→  https://instagram.com/alfan.niteops"
  echo ""
  echo -e "${YELLOW}  ────────────────────────────────────────────────────${NC}"
  echo ""
}

step() {
  echo -e "${CYAN}${BOLD}  [ ~ ] $1${NC}"
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

echo -e "  ${BOLD}Script ini akan install:${NC}"
echo -e "  • Docker Engine"
echo -e "  • Docker Compose Plugin"
echo ""
echo -ne "${YELLOW}  Lanjutkan instalasi? (y/n): ${NC}"
read -r confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  banner_cancel
  exit 0
fi

echo ""

# ─── CLONE REPO DOCKER ───
step "Mengambil installer dari repo docker..."
sleep 1

rm -rf /tmp/alfannite-docker

if git clone https://github.com/alfannite/docker.git /tmp/alfannite-docker --depth=1 -q; then
  success_msg "Installer berhasil diambil"
else
  error_msg "Gagal mengambil installer. Cek koneksi internet kamu."
fi

# ─── CEK FILE ───
step "Memeriksa file installer..."

if [ ! -f /tmp/alfannite-docker/ubuntu/install.sh ]; then
  error_msg "File installer tidak ditemukan di repo docker."
fi

success_msg "File installer ditemukan"

# ─── PERMISSION ───
step "Memberikan izin eksekusi..."
chmod +x /tmp/alfannite-docker/ubuntu/install.sh
success_msg "Permission berhasil diberikan"

# ─── INSTALL ───
step "Menjalankan installer Docker Engine..."
echo ""
echo -e "${YELLOW}  ────────────────────────────────────────────────────${NC}"
echo ""

cd /tmp/alfannite-docker/ubuntu && sudo ./install.sh

EXIT_CODE=$?

echo ""
echo -e "${YELLOW}  ────────────────────────────────────────────────────${NC}"

# ─── CLEANUP ───
step "Membersihkan file sementara..."
rm -rf /tmp/alfannite-docker
success_msg "Cleanup selesai"

echo ""

# ─── RESULT ───
if [ $EXIT_CODE -eq 0 ]; then
  banner_success
else
  error_msg "Instalasi gagal. Cek log di atas untuk detail error."
fi