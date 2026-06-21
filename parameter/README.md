<p align="center">
  <img src="../img/logo2.png" width="180">
</p>

<h1 align="center">GenieACS Parameter Configuration</h1>

<p align="center">
  Complete guide to backup and restore <b>GenieACS</b> parameter collections
  including <b>config</b>, <b>virtualParameters</b>, <b>presets</b>, and <b>provisions</b>
  using <b>Docker</b> and <b>MongoDB</b>.
</p>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&pause=2000&color=58A6FF&center=true&vCenter=true&width=600&lines=GenieACS+Parameter+Config;MongoDB+Restore;Docker+Ready;Always+Learning+%F0%9F%9A%80" />
</p>

<p>
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white" />
  <img src="https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=white" />
  <img src="https://img.shields.io/badge/GenieACS-000000?style=flat-square&logo=gnu&logoColor=white" />
</p>

---

## Overview

This guide covers restoring GenieACS parameter collections from backup files into a running Docker container. Follow the steps below to get your configuration back up and running quickly.

---

## Prerequisites

Before starting, make sure you have:

- Docker & Docker Compose installed and running
- GenieACS container running (`genieacs-server`)
- Backup files available at `/genie-acs/parameter/`

---

## Cara Install Parameter

### 1. Copy Files ke Container

```bash
docker cp /genie-acs/parameter/ genieacs-server:/tmp/
```

### 2. Restore Collections

```bash
# Restore config
docker exec genieacs-server mongorestore \
  --db genieacs --collection config \
  --drop /tmp/parameter/config.bson

# Restore virtualParameters
docker exec genieacs-server mongorestore \
  --db genieacs --collection virtualParameters \
  --drop /tmp/parameter/virtualParameters.bson

# Restore presets
docker exec genieacs-server mongorestore \
  --db genieacs --collection presets \
  --drop /tmp/parameter/presets.bson

# Restore provisions
docker exec genieacs-server mongorestore \
  --db genieacs --collection provisions \
  --drop /tmp/parameter/provisions.bson
```

### 3. Restart GenieACS

```bash
cd /opt/genieacs-docker && docker-compose restart && sleep 15
```

---

## Collections Reference

| Collection | Description |
|---|---|
| `config` | General GenieACS configuration |
| `virtualParameters` | Virtual parameter definitions |
| `presets` | Preset task configurations |
| `provisions` | Provisioning scripts |

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