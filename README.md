# DKCISSP Web Application Security Lab

**One installer. Three local vulnerable web applications. One repeatable lab.**

The DKCISSP Web Application Security Lab is a Docker-based training environment for Kali Linux and authorized web application security testing. A single installer prepares/checks the required tools and starts all three targets together:

- **OWASP Juice Shop** — a modern web application for discovering and testing common web/API weaknesses.
- **DVWA (Damn Vulnerable Web Application)** — a PHP application for practicing classic web vulnerability checks.
- **OWASP WebGoat** — guided lessons and exercises for learning web application security.

This is a deliberately vulnerable training environment, not a production service and not a scanner by itself. It provides local targets that a tester or DKCISSP scanner can assess.

## Quick start: install all three in one go

Run these commands on your Kali Linux machine:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git
cd Kali-Web-Application-Security-Lab
chmod +x install.sh lab.sh scenarios.sh
./install.sh
```

**That single `./install.sh` command starts Juice Shop, DVWA, and WebGoat together.** You do not need to install each application separately.

What happens during installation:

1. Checks that the system is Linux/Kali and that required files are present.
2. Checks Docker and Docker Compose availability. If Docker is missing on an apt-based system, it asks before installing packages.
3. Checks for `curl`, which is used for HTTP readiness checks.
4. Validates the Docker Compose configuration.
5. Downloads the required container images if they are not already available.
6. Starts all three applications and checks whether their local URLs respond.

The first setup can take several minutes depending on your internet connection and machine. Keep the terminal open until the installer finishes. If an application is still starting or fails its readiness check, use the troubleshooting commands below.

### Open the three applications

After startup, open these URLs **on the same Kali machine**:

| Application | URL | Default port |
|---|---|---:|
| OWASP Juice Shop | http://127.0.0.1:1003 | 1003 |
| DVWA | http://127.0.0.1:1006 | 1006 |
| OWASP WebGoat | http://127.0.0.1:1007/WebGoat | 1007 |

The installer publishes the applications on the loopback interface (`127.0.0.1`) so they are not intentionally exposed to your LAN or the Internet.

### Default credentials / first login

| Application | First login |
|---|---|
| OWASP Juice Shop | No login required to browse. Register your own account from the **Account** menu for personalized features. The application also ships with a seeded administrator account, but recovering its credentials is one of the built-in Juice Shop challenges — they are intentionally not published here. |
| DVWA | One-time setup required: open `http://127.0.0.1:1006/setup.php` and click **Create / Reset Database**. After that, log in with the default credentials `admin` / `password`. |
| OWASP WebGoat | No default account. Register your own account the first time you open `http://127.0.0.1:1007/WebGoat`. |

## Manage the lab

Run commands from the repository directory:

| Command | What it does |
|---|---|
| `./lab.sh start` | Starts all three applications and checks their HTTP responses. |
| `./lab.sh status` | Shows container status and checks each target URL. |
| `./lab.sh logs` | Follows logs for the lab services; press Ctrl+C to stop following. |
| `./lab.sh scenarios` | Opens the guided local security-testing scenario menu. |
| `./lab.sh stop` | Stops all three services but retains their containers. |
| `./lab.sh reset` | Recreates the three containers after confirmation; writable container state is discarded. |
| `./lab.sh destroy` | Removes the lab containers and dedicated network after confirmation. Downloaded images are retained. |
| `./lab.sh --help` | Displays available commands and target URLs. |

To start the lab again later, return to the repository directory and run:

```bash
./lab.sh start
```

### If a port is already in use

You can choose alternative local ports for the lab:

```bash
DKCISSP_PORT=1013 DKCISSP_DVWA_PORT=1016 DKCISSP_WEBGOAT_PORT=1017 ./lab.sh start
```

Use the same environment variables for later `status`, `logs`, `stop`, `reset`, or `destroy` commands when you need to refer to those non-default ports.

## Where the lab lives, and restarting after a reboot

### Default location

This lab is not "installed" to a fixed system path. It lives wherever you ran `git clone` from the Quick start steps above — if you cloned it from your home directory, that's `~/Kali-Web-Application-Security-Lab`. Every command (`./install.sh`, `./lab.sh ...`) must be run from inside that folder. To find it later:

```bash
find ~ -maxdepth 3 -iname "Kali-Web-Application-Security-Lab" -type d 2>/dev/null
```

You can move or rename the cloned folder freely — nothing here is hardcoded to a fixed absolute path, since all scripts resolve paths relative to their own location. Docker's own image and container data is stored separately, in Docker's data root (`/var/lib/docker` by default on Kali/Debian); that's managed by the Docker engine itself, not by this repository.

### Starting the lab again after restarting your laptop

**Manual start** — go back to the repository folder and run:

```bash
cd ~/Kali-Web-Application-Security-Lab   # or wherever you cloned it
./lab.sh start
```

**Automatic start** — every lab container is already configured with `restart: unless-stopped`, so once started they come back on their own whenever the Docker *engine* restarts. That only happens automatically if the Docker service itself is enabled to start at boot. Enable it once:

```bash
sudo systemctl enable docker
```

After that, a reboot brings Docker back up, and Docker restarts the lab containers for you — no manual command needed. If you'd rather keep manual control instead, leave Docker's autostart disabled (or run `sudo systemctl disable docker` to turn it back off) and just run `./lab.sh start` yourself whenever you want the lab running.

## Safety and scope

**These applications are intentionally vulnerable. Do not deploy them as production applications.**

- Keep published ports bound to `127.0.0.1`. Do not change them to `0.0.0.0` or expose the targets to a LAN or the public Internet.
- Scan only these local targets unless you have explicit authorization for another system.
- Use synthetic accounts and data; never use production credentials.
- Review installation prompts before approving system package changes.
- Docker access can grant root-equivalent control of the host.
- This repository orchestrates third-party projects. Review their upstream documentation, licensing, and image update notes.

## Troubleshooting

Check the service state and logs:

```bash
./lab.sh status
./lab.sh logs
```

If Docker is not running:

```bash
sudo systemctl start docker
./lab.sh status
```

If a target does not respond, check its container logs, available memory, and whether its host port is already in use. WebGoat may take longer to initialize during first startup. Do not assume the lab is ready until the target URL responds.

Validate the Compose file:

```bash
docker compose -f docker-compose.yml config --quiet
```

## DKCISSP website integration

The repository provides the local lab installer. A DKCISSP website page can link to this repository and show the quick-start commands and target ports. A normal browser page cannot silently install software on a visitor's Kali machine: the user must run the commands locally. Keep the vulnerable targets on the user's machine and do not publish them as public DKCISSP-hosted services.

## Upstream projects

This repository orchestrates these independent training applications and does not claim ownership of them:

- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [DVWA](https://github.com/digininja/DVWA)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)

Before using this lab in a tester onboarding workflow, test the complete installation on the target Kali environment and verify that all three applications respond as expected.
