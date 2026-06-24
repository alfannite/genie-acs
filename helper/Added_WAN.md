<div align="center">

# 📡 Konfigurasi WAN & LAN Interface — ACS / TR-069

Panduan konfigurasi WAN Bridge, WAN Route, SSID, dan Binding Interface untuk perangkat ONT/ONU.

</div>

![GenieACS](https://img.shields.io/badge/GenieACS-Provision-22C55E?style=flat-square)
![TR-069](https://img.shields.io/badge/TR--069-ACS-0EA5E9?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

---

## WAN Bridge

> Digunakan ketika PPPoE di-handle oleh router pelanggan, bukan oleh ONT.

### Slot WAN PPP

| Parameter     | Nilai                      |
|---------------|----------------------------|
| Conn Mode     | `PPPoE_Bridged`            |
| Service List  | `INTERNET` atau `OTHER`    |

### Slot WAN IP

| Parameter     | Nilai                      |
|---------------|----------------------------|
| Conn Mode     | `IP_Bridged`               |
| Service List  | `INTERNET` atau `OTHER`    |

---

## WAN Route / PPPoE

> Digunakan ketika ONT langsung dial PPPoE atau sebagai router.

| Parameter     | Nilai        |
|---------------|--------------|
| Conn Mode     | `IP_Routed`  |
| Service List  | `INTERNET`   |

---

## Konfigurasi SSID

### SSID dengan Password

| Parameter      | Nilai                    |
|----------------|--------------------------|
| Security Mode  | `11i` atau `WPAand11i`   |

### SSID tanpa Password

| Parameter      | Nilai  |
|----------------|--------|
| Security Mode  | `None` |

---

## Bind / Tag LAN & WLAN Interface

> Isi manual menggunakan parameter di bawah.  
> Gunakan **pemisah koma (`,`)** untuk lebih dari satu parameter.

> ⚠️ **Khusus ZTE F670L** — kolom `Wan Interface` juga wajib diisi dengan parameter WAN-nya.

---

### WAN IP Interface

```
Wan 1 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.1
Wan 2 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.2
Wan 3 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.3
Wan 4 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANIPConnection.4
```

### WAN PPP Interface

```
Wan 1 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.1
Wan 2 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.2
Wan 3 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.3
Wan 4 : InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1.WANPPPConnection.4
```

---

### LAN Interface

> Untuk selain F670L — cukup isi LAN/WLAN interface saja pada WAN config.

```
LAN 1 : InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1
LAN 2 : InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.2
LAN 3 : InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.3
LAN 4 : InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.4
```

### WLAN Interface — 2.4 GHz (SSID 1–4)

```
SSID 1 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.1
SSID 2 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.2
SSID 3 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.3
SSID 4 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.4
```

### WLAN Interface — 5 GHz (SSID 5–8)

> 📝 Untuk **dual band**, SSID 5 GHz dimulai dari **SSID 6 ke atas**.

```
SSID 5 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.5
SSID 6 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.6
SSID 7 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.7
SSID 8 : InternetGatewayDevice.LANDevice.1.WLANConfiguration.8
```

---

## Contoh Pengisian — Multi Interface

Contoh binding semua LAN port + SSID dual band sekaligus:

```
InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1,InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.2,InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.3,InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.4,InternetGatewayDevice.LANDevice.1.WLANConfiguration.1,InternetGatewayDevice.LANDevice.1.WLANConfiguration.5
```

---

## Contoh Konfigurasi — FIBERHOME

| Parameter       | Nilai                                                                                                                                                                                                                                                  |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PPPoE Mode      | `PPPoE_Routed`                                                                                                                                                                                                                                         |
| Service List    | `TR069,INTERNET`                                                                                                                                                                                                                                       |
| LAN Interface   | `InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1,InternetGatewayDevice.LANDevice.1.WLANConfiguration.1,InternetGatewayDevice.LANDevice.1.WLANConfiguration.5` |

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
  <a href="https://discord.gg/mS4UXkQjW">
    <img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white"/>
  </a>
</div>