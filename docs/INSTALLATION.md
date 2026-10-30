# Installation and First Run

## One-command setup

From a Kali Linux terminal:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git && cd Kali-Web-Application-Security-Lab && chmod +x install.sh lab.sh scenarios.sh && ./install.sh
```

The installer starts all three local training applications: OWASP Juice Shop, DVWA, and OWASP WebGoat. During the first run, Docker downloads the images, so allow several minutes. If Docker is missing, the installer asks before installing packages on supported apt-based systems.

## Local URLs

- Juice Shop: http://127.0.0.1:1003
- DVWA: http://127.0.0.1:1006
- WebGoat: http://127.0.0.1:1007/WebGoat

These addresses are bound to localhost and intended for access from the same Kali machine only.

## Default credentials / first login

- **Juice Shop** — no login required to browse; register your own account from the **Account** menu for personalized features. The application ships with a seeded administrator account, but recovering its credentials is one of the built-in Juice Shop challenges, so they are intentionally not published here.
- **DVWA** — one-time setup required: open `http://127.0.0.1:1006/setup.php` and click **Create / Reset Database**. Then log in with the default credentials `admin` / `password`.
- **WebGoat** — no default account; register your own account the first time you open `http://127.0.0.1:1007/WebGoat`.

## Where the lab lives, and restarting after a reboot

This lab is not installed to a fixed system path — it lives wherever you ran `git clone` from in the one-command setup above (typically `~/Kali-Web-Application-Security-Lab` if cloned from your home directory). Every command must be run from inside that folder; you can move or rename it freely.

After restarting your laptop:

- **Manual start:** `cd ~/Kali-Web-Application-Security-Lab && ./lab.sh start`
- **Automatic start:** containers are configured with `restart: unless-stopped`, so they resume on their own once Docker itself restarts — but only if Docker is enabled to start at boot. Enable that once with `sudo systemctl enable docker` (disable again with `sudo systemctl disable docker` if you'd rather start the lab manually every time).

## Verify the installation

```bash
./lab.sh status
./lab.sh logs
```

The health check can take several minutes while WebGoat initializes. If one target does not respond, inspect its container logs and check available memory and port conflicts.

Never expose these intentionally vulnerable targets to the Internet or scan systems without explicit authorization.
