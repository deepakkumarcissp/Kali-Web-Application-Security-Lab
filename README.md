# DKCISSP Web Application Security Lab

A local-first web application security training lab for Kali Linux. The first milestone deploys OWASP Juice Shop on your own machine with a localhost-only port binding and a simple lifecycle controller.

> **Status:** Initial implementation for local testing. It has not yet been validated on every supported Kali Linux installation. Do not treat it as a production security product.

## Design goals

- One copy-paste setup command after Git access is configured.
- Run on a single Kali Linux VM; no cloud account or remote lab required.
- Keep the vulnerable target bound to `127.0.0.1` by default.
- Provide clear startup health checks and useful failure messages.
- Keep scanner integrations and more advanced missions optional future milestones.

## Quick start

From a Kali Linux terminal, run this as one copy-paste command:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git && cd Kali-Web-Application-Security-Lab && chmod +x install.sh lab.sh && ./install.sh
```

The repository may be private while it is being developed. Learners will need repository access until the project owner chooses to publish it.

The installer checks Docker and Compose. If Docker is missing on an apt-based system, it asks before installing system packages. Installing system packages may require your sudo password. It then validates the Compose configuration, starts the application, and waits for an HTTP response.

Open the URL printed by the installer, normally:

`http://127.0.0.1:3000`

If port 3000 is already in use, select another port:

```bash
DKCISSP_PORT=3001 ./lab.sh start
```

## Lab commands

```bash
./lab.sh start
./lab.sh status
./lab.sh logs
./lab.sh stop
./lab.sh reset
./lab.sh destroy
```

- `start`: starts the application and checks its HTTP response.
- `status`: shows Compose status and attempts an HTTP check.
- `logs`: follows recent application logs; press Ctrl+C to stop following.
- `stop`: stops the service while retaining its container.
- `reset`: asks for confirmation, then recreates the application container. Writable application state is discarded.
- `destroy`: asks for confirmation and removes the lab container and dedicated network. It does not remove the downloaded image.

## Requirements

- Kali Linux or another apt-based Debian-family Linux system.
- Git, Docker Engine, Docker Compose, and curl.
- Internet access for the initial clone and image download. Normal exercises should run locally once downloaded.
- Suggested development target: 2 CPU cores and 4 GB RAM for the Kali VM; actual minimums will be documented after testing.

## Safety

Juice Shop is deliberately vulnerable and is intended for training. This configuration binds its published port to localhost. Do not change the binding to all interfaces or expose the application to the Internet. Use only the lab instance for practice. The lab is not designed for production use.

Docker access can grant root-equivalent control of the host. Review installation prompts and use a dedicated test VM where possible. The installer does not add your account to the Docker group.

## Current scope and roadmap

1. **Foundation:** local app deployment, lifecycle commands, health check, documentation.
2. **Learning experience:** guided missions with evidence, hints, remediation, and retesting.
3. **Optional tooling:** scanner integration and defensive telemetry, enabled only when needed.

## Troubleshooting

- Docker service not running: `sudo systemctl start docker`
- Check service status: `./lab.sh status`
- Inspect logs: `./lab.sh logs`
- Choose another port: `DKCISSP_PORT=3001 ./lab.sh start`
- Review the Compose file before running if you customize the lab.

## Third-party software

This project orchestrates OWASP Juice Shop; it does not claim ownership of that software. Review its project documentation and license before redistribution. The image tag is pinned for reproducibility and should be updated only after validation.
