<h1 align="center">Provision: inform</h1>

<p align="center">
Universal ONU WiFi Auto-Config — ACS connection & WiFi setup for all ONU devices.
</p>

![GenieACS](https://img.shields.io/badge/GenieACS-Provision-22C55E?style=flat-square)
![TR-069](https://img.shields.io/badge/TR--069-ACS-0EA5E9?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

</p>

---

## 🚀 Overview

Script provision `inform` ini berjalan otomatis setiap kali perangkat ONU melakukan koneksi ke ACS (GenieACS).

Fungsinya mencakup dua hal utama — mengatur ulang koneksi ACS dan melakukan auto-konfigurasi WiFi dengan SSID `ACS_AUTO`, berlaku untuk semua ONU kecuali MikroTik.

---

## ✨ Features

* Auto-set ACS URL, username & password
* Auto-set Connection Request credentials
* Periodic Inform setiap 200 detik
* Auto-set SSID menjadi `ACS_AUTO` (Open WiFi)
* Support semua ONU — Fiberhome, ZTE, Huawei, dll
* MikroTik aware — skip WiFi config otomatis
* Idempotent — skip jika sudah terkonfigurasi

---

## ⚙️ Konfigurasi

Sebelum deploy, sesuaikan variabel berikut di bagian atas script:

| Parameter        | Default                        | Keterangan                        |
|------------------|--------------------------------|-----------------------------------|
| `url`            | `http://IP_ACS/Domain_ACS:7547`| URL ACS server                    |
| `informInterval` | `200`                          | Interval inform (detik)           |
| `AcsUser`        | `msn`                          | Username ACS                      |
| `AcsPass`        | `msn`                          | Password ACS                      |
| `ConnReqUser`    | `msn`                          | Username Connection Request       |
| `ConnReqPass`    | `msn`                          | Password Connection Request       |

---

## 🔄 Alur Kerja

```text
ONU Connect ke ACS
       │
       ├── Brand == MikroTik?
       │       ├── Ya  → Set ACS via Device.ManagementServer.*
       │       │         Skip WiFi Config
       │       │
       │       └── Tidak → Set ACS via InternetGatewayDevice.ManagementServer.*
       │                   Cek WLANConfiguration.1.SSID
       │                       ├── SSID == "ACS_AUTO" → Skip
       │                       └── SSID != "ACS_AUTO" → Set SSID, Open WiFi, Enable
       │
       └── Selesai — log provision completed
```

---

## 📡 Parameter WiFi yang Di-set

| Parameter                  | Nilai      | Keterangan              |
|----------------------------|------------|-------------------------|
| `WLANConfiguration.1.SSID` | `ACS_AUTO` | Nama WiFi               |
| `BeaconType`               | `None`     | Open WiFi (tanpa pass)  |
| `Enable`                   | `true`     | WiFi aktif              |
| `SSIDAdvertisementEnabled` | `true`     | SSID broadcast aktif    |

---

## 📝 Catatan

> Script hanya mengubah WiFi **sekali** — jika SSID sudah `ACS_AUTO`, konfigurasi akan di-skip.

> Untuk mengganti SSID atau menambah password, edit bagian `WLANConfiguration.1` di script.

> MikroTik menggunakan path `Device.*` bukan `InternetGatewayDevice.*` — sudah ditangani otomatis.

---

## 📜 License

This project is licensed under the MIT License.
See the LICENSE file for details.

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
  <a href="https://discord.gg/mS4UXkQjW">
    <img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white"/>
  </a>
</div>