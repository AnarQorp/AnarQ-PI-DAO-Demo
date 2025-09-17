# AnarQ PI DAO Demo

This repository provides a clean **demo-ready setup** of the **AnarQ&Q Ecosystem**, with **Qsocial** as the main entrypoint (dashboard) and all core modules available through the underlying `anarqq-ecosystem-core`.

---

## 🌐 Overview
- **Qsocial** → the dashboard and main user interface.  
- **QpiC**, **Qmarket**, **Qmail**, **Qdrive**, **Qonsent**, **Qlock**, etc. are provided via the **core package**.  
- Backend logic is mocked where necessary, but the structure is already **production-ready**.  
- This demo targets the **Pi Network Hackathon** and **Pi Ventures** presentations.

---

## 🚀 Quickstart

### 1. Clone this repository
```bash
git clone https://github.com/AnarQorp/AnarQ-PI-DAO-Demo.git
cd AnarQ-PI-DAO-Demo
2. Fetch the core
bash
Copiar código
bash bootstrap/fetch-core-demo.sh
3. Start the demo
bash
Copiar código
bash run/start-demo.sh
Access it at: http://localhost:4173

4. Stop the demo
bash
Copiar código
bash run/stop-demo.sh
📱 Mobile builds
For Android/iOS builds we use Capacitor + Android Studio:

bash
Copiar código
pnpm build
pnpm --package=@capacitor/cli dlx cap add android
pnpm --package=@capacitor/cli dlx cap sync android
pnpm --package=@capacitor/cli dlx cap open android
Then build a signed APK from Android Studio.

🛠 Requirements
Node.js ≥ 18

pnpm ≥ 9 (use corepack enable && corepack prepare pnpm@9 --activate)

Git

(Optional) Android Studio for APK builds

🤝 Contributing
This demo is designed for the Pi Hackathon. We welcome community contributions:

DAO Coordinators

Qnode Developers

Community Managers

Wallet Developers

Content Creators

Contact: anarqorp@proton.me

📜 License
Code is provided under CC BY-NC-SA 4.0 for demo purposes.
