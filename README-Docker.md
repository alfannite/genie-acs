<p align="center">
  <img src="img/logo1.png" width="180">
</p>

<h1 align="center">GenieACS With Docker</h1>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&pause=2000&color=58A6FF&center=true&vCenter=true&width=600&lines=Installation+Docker;Linux+Ubuntu;Convenience;Always+Learning+%F0%9F%9A%80" />
</p>

<p>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" />
</p>

---

## Description

Tutorial Install **GenieACS** menggunakan Docker & Docker Compose beserta virtual parameter dari repo yang udah di berikan.

---

## Prasyarat

- Akses **root** ke Server
- Pastikan port berikut terbuka di firewall:

| Port | Protokol | Fungsi |
|------|----------|--------|
| 7547 | TCP | CWMP (komunikasi ACS ↔ CPE) |
| 7557 | TCP | NBI (North Bound Interface) |
| 3000 | TCP | UI (Web interface GenieACS) |

---

## Installation

### Case 1 — GenieACS Docker + ZeroTier (Server)

**Step 1 — Masuk sebagai root**

Seluruh proses instalasi harus dijalankan sebagai superuser untuk menghindari error permission.

```bash
sudo su
```

---

**Step 2 — Update sistem**

Pastikan paket sistem up-to-date sebelum mulai instalasi.

```bash
apt update -y && apt upgrade -y && apt autoremove -y
```

---

**Step 3 — Install Docker + Compose**

Install Docker Engine dan Docker Compose secara otomatis menggunakan script. 

# CHECK POINNT DI SINI POINTING AUTO INSTALL DOCKER, MAUU BERAK

```bash
bash <(curl -s https://raw.githubusercontent.com/alfannite/genie-acs/Auto-Install/install.sh)
```

---

**Step 4 — Download script GACS**

Clone repo GACS dari GitHub ke direktori lokal Server kamu.

```bash
git clone https://github.com/alfannite/genie-acs
```

---

**Step 5 — Masuk ke folder GACS**

Pindah ke direktori hasil clone agar perintah selanjutnya berjalan di path yang benar.

```bash
cd genie-acs
```

---

**Step 6 — Jalankan installer Docker**

Beri izin eksekusi lalu jalankan script installer Docker yang sudah include konfigurasi ZeroTier.

```bash
chmod +x install-genieacs-docker.sh
./install-genieacs-docker.sh
```

---

### Case 2 — GenieACS Docker (Mini PC / Tanpa ZeroTier)

**Step 1 — Masuk sebagai root**

Seluruh proses instalasi harus dijalankan sebagai superuser untuk menghindari error permission.

```bash
sudo su
```

---

**Step 2 — Update sistem**

Pastikan paket sistem up-to-date sebelum mulai instalasi.

```bash
apt update -y && apt upgrade -y && apt autoremove -y
```

---

**Step 3 — Install Docker + Compose**

Install Docker Engine dan Docker Compose secara otomatis menggunakan script.

```bash
bash <(curl -s https://raw.githubusercontent.com/alfannite/genie-acs/main/install.sh)
```

---

**Step 4 — Download script GACS**

Clone repo GACS dari GitHub ke direktori lokal Server kamu.

```bash
git clone https://github.com/alfannite/genie-acs
```

---

**Step 5 — Masuk ke folder GACS**

Pindah ke direktori hasil clone agar perintah selanjutnya berjalan di path yang benar.

```bash
cd genie-acs
```

---

**Step 6 — Jalankan installer Docker**

Beri izin eksekusi lalu jalankan script installer Docker versi tanpa ZeroTier.

```bash
chmod +x docker-non-zerotier.sh
./docker-non-zerotier.sh
```

---

### Case 3 — Import Virtual Parameter (Docker)

Untuk install parameter `config`, `virtualParameters`, `presets`, dan `provisions` ke dalam container.

**Step 1 — Salin folder parameter ke container**

Copy folder parameter dari direktori repo ke dalam container GenieACS.

```bash
docker cp ./parameter/ genieacs-server:/tmp/
```

---

**Step 2 — Restore parameter ke database**

Import tiap koleksi parameter ke database MongoDB yang berjalan di dalam container.

```bash
docker exec genieacs-server mongorestore --db genieacs --collection config \
  --drop /tmp/parameter/config.bson

docker exec genieacs-server mongorestore --db genieacs --collection virtualParameters \
  --drop /tmp/parameter/virtualParameters.bson

docker exec genieacs-server mongorestore --db genieacs --collection presets \
  --drop /tmp/parameter/presets.bson

docker exec genieacs-server mongorestore --db genieacs --collection provisions \
  --drop /tmp/parameter/provisions.bson
```

---

**Step 3 — Restart layanan**

Restart seluruh service Compose agar perubahan parameter aktif.

```bash
cd /opt/genieacs-docker && docker-compose restart && sleep 15
```

---

### Case 4 — Konfigurasi Provision (Inform)

Setelah menambahkan parameter login, buka **GenieACS UI → Provisions → Show (Inform)** dan perbarui variabel berikut:

```js
const url         = 'http://[IP_ACS]:7547'
const AcsUser     = 'username_acs_kamu'
const AcsPass     = 'password_acs_kamu'
let ConnReqUser   = 'username_connreq'
const ConnReqPass = 'password_connreq'
```

> **Penting:** Simpan perubahan setelah edit. Tanpa ini, Inform dan Connection Request tidak akan terhubung ke ACS kamu.

---

### Case 5 — Konfigurasi ZeroTier MikroTik (TR-069 via ZeroTier)

**Step 1 — Install & join ZeroTier di MikroTik**

1. Install ZeroTier di MikroTik.
2. Join ke network yang sama dengan Server.
3. Pastikan ada VLAN yang terhubung ke ONU.

---

**Step 2 — Konfigurasi firewall MikroTik**

Jalankan rule berikut di MikroTik. Sesuaikan `IP_ZEROTIER_Server`, nama interface, dan port Connection Request ONU (contoh port: `58000`).

```bash
/ip firewall filter add chain=forward connection-state=established,related action=accept

/ip firewall filter add chain=forward action=accept protocol=tcp \
  src-address=[IP_ZEROTIER_Server] \
  in-interface=[NAMA_INTERFACE_ZEROTIER] \
  out-interface=[NAMA_INTERFACE_VLAN] \
  dst-port=58000,7547 comment="ACS -> ONU"

/ip firewall filter add chain=forward action=accept protocol=tcp \
  dst-address=[IP_ZEROTIER_Server] \
  in-interface=[NAMA_INTERFACE_VLAN] \
  out-interface=[NAMA_INTERFACE_VLAN] \
  src-port=58000,7547 comment="ONU -> ACS replies"

/ip firewall filter add chain=forward action=accept protocol=tcp \
  dst-address=[IP_ZEROTIER_Server] \
  in-interface=[NAMA_INTERFACE_VLAN] \
  out-interface=[NAMA_INTERFACE_ZEROTIER] \
  dst-port=7547 comment="ONU -> ACS CWMP"

/ip firewall filter add chain=forward \
  in-interface=[NAMA_INTERFACE_ZEROTIER] \
  out-interface=[NAMA_INTERFACE_VLAN] action=accept
```

> **Catatan:** Port `58000` adalah contoh port Connection Request URL dari ONU — sesuaikan dengan perangkat kamu.

---

## Template & Tools

| Tool | Link |
|------|------|
| ZeroTier Firewall Generator | https://nangili.id/tools/zt_firewall.html |
| ZeroTier Config Generator | https://nangili.id/tools/zt_config.html |

---

## Video Panduan

| Topik | Link |
|-------|------|
| Instalasi Docker | https://youtu.be/Jt0bW3Yq2d8?feature=shared |

---

<div align="center">
  <p>Made by Alfannite for you hehe 😊</p>

  <a href="https://github.com/alfannite">
    <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white"/>
  </a>
  <a href="https://threads.net/@yeofanya">
    <img src="https://img.shields.io/badge/Threads-000000?style=for-the-badge&logo=threads&logoColor=white"/>
  </a>
  <a href="https://instagram.com/alfan.niteops">
    <img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white"/>
  </a>
  <a href="https://t.me/fannite_ops">
    <img src="https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white"/>
  </a>
  <a href="https://www.twitch.tv/fannitee">
    <img src="https://img.shields.io/badge/Twitch-9146FF?style=for-the-badge&logo=twitch&logoColor=white"/>
  </a>
  <a href="https://discord.gg/LINK_INVITE_ATAU_USER">
    <img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white"/>
  </a>
</div>