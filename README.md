# DKCISSP Web Application Security Lab

A local-first, Docker-based web application security training lab for Kali Linux. Install once and run three deliberately vulnerable applications for authorized scanner testing:

- **OWASP Juice Shop** — modern JavaScript storefront and API testing.
- **DVWA (Damn Vulnerable Web Application)** — classic PHP/MySQL vulnerability practice.
- **OWASP WebGoat** — guided lessons for common web application weaknesses.

This is a learning and validation lab, not a production scanner. Findings from a scanner should be verified manually; a test checklist or HTTP response alone does not prove a vulnerability.

## Quick start

On Kali Linux:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git
cd Kali-Web-Application-Security-Lab
chmod +x install.sh lab.sh scenarios.sh
./install.sh
```

The installer checks Docker and Compose, asks before installing missing system packages, validates the Compose configuration, and starts all three applications. The first run downloads their container images and may take several minutes.

## Local URLs

All targets are bound to loopback addresses and should be accessed from the same Kali machine:

| Application | Local URL | Default host port |
|---|---|---:|
| OWASP Juice Shop | http://127.0.0.1:1003 | 1003 |
| DVWA | http://127.0.0.1:1006 | 1006 |
| OWASP WebGoat | http://127.0.0.1:1007/WebGoat | 1007 |

If any port is already in use, override the ports for a command:

```bash
DKCISSP_PORT=1013 DKCISSP_DVWA_PORT=1016 DKCISSP_WEBGOAT_PORT=1017 ./lab.sh start
```

Use the same port variables for `status`, `logs`, `stop`, `reset`, or `destroy` when you have overridden defaults.

## Lab management

Run commands from the repository directory:

| Command | Purpose |
|---|---|
| `./lab.sh start` | Start all three applications and wait for HTTP checks. |
| `./lab.sh status` | Show container state and health checks for each target. |
| `./lab.sh logs` | Follow logs for all lab services (Ctrl+C to stop). |
| `./lab.sh scenarios` | Open the existing guided testing menu. |
| `./lab.sh stop` | Stop all lab services while retaining containers. |
| `./lab.sh reset` | Recreate all three containers after confirmation; writable state is discarded. |
| `./lab.sh destroy` | Remove all lab containers and the dedicated network after confirmation. Downloaded images are retained. |
| `./lab.sh --help` | Display commands and URLs. |

## Recommended scanner test plan

1. **Discovery/crawling:** use Juice Shop to test URL discovery and modern client-side routes.
2. **PHP checks:** use DVWA for PHP-oriented checks and classic input-handling scenarios.
3. **Guided vulnerability scenarios:** use WebGoat to practice and verify individual vulnerability classes.
4. **Quality checks:** record the evidence for each finding, remove duplicates, verify severity, and track false positives.
5. **Retest:** after changing a test condition, rerun the same scanner check and compare results.

Start with passive discovery and non-destructive checks. Use exploit validation only inside these local training applications and only when you understand the impact.

## Safety and scope

These applications are intentionally vulnerable.

- The Compose file binds published ports to `127.0.0.1`; do not change them to `0.0.0.0` or expose the targets to a LAN or the Internet.
- Scan only these local training targets unless you have explicit authorization for another system.
- Use synthetic accounts and data. Never use production credentials.
- Review installation prompts before approving system package changes.
- Docker access can grant root-equivalent control of the host.
- This project is not intended for production use and does not replace a professional security assessment.

## Troubleshooting

Check containers and health checks:

```bash
./lab.sh status
./lab.sh logs
```

If Docker is not running:

```bash
sudo systemctl start docker
./lab.sh status
```

If a target does not respond, check its logs, available RAM, and whether its host port is already in use. WebGoat may take longer to initialize on the first start. Do not assume the application is ready until its URL responds.

Validate Compose configuration:

```bash
docker compose -f docker-compose.yml config --quiet
```

## Third-party projects

This repository orchestrates third-party training applications and does not claim ownership of them. Review each upstream project's documentation, license, and image update notes before redistributing or changing pinned images:

- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [DVWA](https://github.com/digininja/DVWA)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)

The images and the startup process should be tested on the target Kali environment before using this lab in a tester onboarding workflow.
