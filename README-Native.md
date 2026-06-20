<p align="center">
  <img src="img/main-logo.png" width="180">
</p>

<h1 align="center">GenieACS Without Docker</h1>

---

## Catatan

Panduan ini menginstal **GenieACS** langsung di host beserta virtual parameter dari repo yang sudah tersedia.

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

## Instalasi

### Fase 1 — Instalasi GenieACS

**Step 1 — Masuk sebagai root**

Seluruh proses instalasi harus dijalankan sebagai superuser untuk menghindari error permission.

```bash
sudo su
```

---

**Step 2 — Download script GACS**

Clone repo GACS dari GitHub ke direktori lokal VPS kamu.

```bash
git clone https://github.com/safrinnetwork/GACS-Ubuntu-22.04
```

---

**Step 3 — Masuk ke folder GACS**

Pindah ke direktori hasil clone agar perintah selanjutnya berjalan di path yang benar.

```bash
cd GACS-Ubuntu-22.04
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
dos2unix GACS-Jammy.sh
```

---

**Step 6 — Beri izin eksekusi**

Secara default file `.sh` tidak bisa langsung dijalankan. Perintah ini memberikan hak eksekusi pada script.

```bash
chmod +x GACS-Jammy.sh
```

---

**Step 7 — Jalankan instalasi GACS**

Script akan menginstall GenieACS beserta semua dependensinya secara otomatis. Tunggu hingga proses selesai.

```bash
./GACS-Jammy.sh
```

---

### Fase 2 — Import Virtual Parameter

**Step 1 — Masuk ke folder parameter**

Folder `parameter` berisi dump database MongoDB yang akan di-import ke GenieACS.

```bash
cd parameter
```

---

**Step 2 — Restore database parameter**

Perintah ini mengimport seluruh virtual parameter ke database MongoDB GenieACS.  
Flag `--drop` akan menghapus koleksi yang sudah ada sebelum import — aman untuk instalasi fresh.

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

### Fase 3 — Konfigurasi Provision (Inform)

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

### Fase 4 — Konfigurasi ZeroTier (Opsional)

**Step 1 — Install ZeroTier di VPS**

ZeroTier membuat tunnel virtual antar perangkat. Install dengan satu perintah:

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
zerotier-cli join abcd1234
```

---

**Step 3 — Install & join ZeroTier di MikroTik**

1. Install ZeroTier di MikroTik.
2. Join ke network yang sama dengan VPS.
3. Pastikan ada VLAN yang terhubung ke ONU.

---

**Step 4 — Konfigurasi firewall MikroTik (TR-069 via ZeroTier)**

Jalankan rule berikut di MikroTik. Sesuaikan `IP_ZEROTIER_VPS`, nama interface, dan port Connection Request ONU (contoh port: `58000`).

```bash
/ip firewall filter add chain=forward connection-state=established,related action=accept

/ip firewall filter add chain=forward action=accept protocol=tcp \
  src-address=[IP_ZEROTIER_VPS] \
  in-interface=[NAMA_INTERFACE_ZEROTIER] \
  out-interface=[NAMA_INTERFACE_VLAN] \
  dst-port=58000,7547 comment="ACS -> ONU"

/ip firewall filter add chain=forward action=accept protocol=tcp \
  dst-address=[IP_ZEROTIER_VPS] \
  in-interface=[NAMA_INTERFACE_VLAN] \
  out-interface=[NAMA_INTERFACE_VLAN] \
  src-port=58000,7547 comment="ONU -> ACS replies"

/ip firewall filter add chain=forward action=accept protocol=tcp \
  dst-address=[IP_ZEROTIER_VPS] \
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