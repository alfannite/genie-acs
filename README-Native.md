<p align="center">
  <img src="img/logo1.png" width="180">
</p>

<h1 align="center">GenieACS Without Docker</h1>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&pause=2000&color=58A6FF&center=true&vCenter=true&width=600&lines=Installations+Docker;Linux+Ubuntu;Convenience;Always+Learning+%F0%9F%9A%80" />
</p>

<p>
  <img src="https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white" />
</p>

---

## Description
Tutorial Install **GenieACS** langsung di host beserta virtual parameter dari repo yang udah di berikan.

---

## Prasyarat

- Akses **root** ke VPS
- Pastikan port berikut terbuka di firewall:

| Port | Protokol | Fungsi |
|------|----------|--------|
| 7547 | TCP | CWMP (komunikasi ACS ↔ CPE) |
| 7557 | TCP | NBI (North Bound Interface) |
| 3000 | TCP | UI (Web interface GenieACS) |

---

## Installation

### Case 1 — Installation GenieACS

**Step 1 — Masuk sebagai root**

Seluruh proses instalasi harus dijalankan sebagai superuser untuk menghindari error permission.

```bash
sudo su
```

---

**Step 2 — Download script GACS**

Clone repo GACS dari GitHub ke direktori lokal Server kamu.

```bash
git clone https://github.com/alfannite/genie-acs
```

---

**Step 3 — Masuk ke folder GACS**

Pindah ke direktori hasil clone agar perintah selanjutnya berjalan di path yang benar.

```bash
cd ubuntu-gacs-install.sh
```

---

**Step 4 — Install dos2unix**

Script yang dibuat di Windows memiliki line ending berbeda (CRLF). `dos2unix` mengubahnya ke format Unix (LF) agar bisa dieksekusi di Linux.

```bash
apt-get update -y && apt-get install -y dos2unix
```

---

**Step 5 — Konversi format script**

Setelah `dos2unix` terinstall, konversi script GACS agar line ending-nya sesuai.

```bash
dos2unix ubuntu-gacs-install.sh
```

---

**Step 6 — Beri izin eksekusi**

Default file `.sh` tidak bisa langsung dijalankan. Perintah ini memberikan hak eksekusi pada script.

```bash
chmod +x ubuntu-gacs-install.sh
```

---

**Step 7 — Jalankan instalasi GACS**

Script akan menginstall GenieACS beserta semua **Dependency** secara otomatis. Tunggu hingga proses selesai.

```bash
./ubuntu-gacs-install.sh
```

---

### Case 2 — Import Virtual Parameter

**Step 1 — Masuk ke folder parameter**

Folder `parameter` berisi dump database MongoDB yang akan di-import ke GenieACS.

```bash
cd parameter
```

---

**Step 2 — Restore database parameter**

Perintah ini mengimport seluruh virtual parameter ke database MongoDB GenieACS.  
Flag `--drop` akan menghapus koleksi yang sudah ada sebelum import — aman untuk instalasi.

```bash
mongorestore --db genieacs --drop .
```

> **Catatan:** Jika file dump berada di lokasi lain, ganti `.` dengan path lengkap folder dump kamu.

---

**Step 3 — Restart service GenieACS**

Setelah parameter terimport, restart semua service agar perubahan aktif.

```bash
systemctl restart genieacs-{cwmp,ui,nbi}
```

---

### Case 3 — Konfigurasi Provision (Inform)

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

### Case 4 — Konfigurasi ZeroTier (Opsional)

**Step 1 — Install ZeroTier di Server**

ZeroTier membuat tunnel virtual antar perangkat. Install one command:

```bash
curl -s https://install.zerotier.com | sudo bash
```

---

**Step 2 — Join ke ZeroTier network**

Ganti `[Network id]` dengan Network ID dari akun ZeroTier kamu.

```bash
zerotier-cli join [Network id]
```

Contoh:

```bash
zerotier-cli join xyz12345
```

---

**Step 3 — Install & join ZeroTier di MikroTik**

1. Install ZeroTier di MikroTik.
2. Join ke network yang sama dengan Server.
3. Pastikan ada VLAN yang terhubung ke ONU.

---

**Step 4 — Konfigurasi firewall MikroTik (TR-069 via ZeroTier)**

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
<div align="center">
  <p>Made by Alfannite for you hehe 😊 </p>

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