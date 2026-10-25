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

## Verify the installation

```bash
./lab.sh status
./lab.sh logs
```

The health check can take several minutes while WebGoat initializes. If one target does not respond, inspect its container logs and check available memory and port conflicts.

Never expose these intentionally vulnerable targets to the Internet or scan systems without explicit authorization.
