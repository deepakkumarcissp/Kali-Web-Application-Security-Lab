# DKCISSP Web Application Security Lab

A local-first web application security testing lab for Kali Linux. The goal is simple: spend less time preparing infrastructure and more time learning how to test, document, fix, and retest web application security issues.

The first version runs **OWASP Juice Shop** locally in Docker and provides guided testing scenarios. It is a practical lab—not an academy, hosted service, or production security scanner.

> **Current status:** MVP for local testing. The repository has automated configuration checks and has been exercised on the maintainer's Kali machine, but it has not been validated on every supported installation. Guided scenarios help you investigate; they do not automatically certify that a vulnerability exists.

## Quick start

### Requirements

- Kali Linux or another Debian-family Linux system using `apt`
- Git, Docker Engine, Docker Compose, and `curl`
- Internet access for the initial repository clone and Juice Shop image download
- Suggested starting point: 2 CPU cores and 4 GB RAM for the Kali VM

Keep the lab on a dedicated test machine or VM where possible. Docker access can provide root-equivalent control of the host.

### First-time setup

From a Kali terminal, run:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git
cd Kali-Web-Application-Security-Lab
chmod +x install.sh lab.sh scenarios.sh
./install.sh
```

If the repository is private, your GitHub account must have access before cloning. The installer checks for Docker and Compose. If Docker is missing on an apt-based system, it asks before installing system packages; installation may require your sudo password. Review the prompt before approving it.

The installer validates the Compose configuration, starts the lab, and waits for an HTTP response. It does not silently add your account to the Docker group.

### When setup finishes

Open this address in the browser on the same Kali machine:

**http://127.0.0.1:1002**

A successful start reports `DKCISSP LAB READY`, the local URL, and that the network exposure is localhost-only.

If port 1002 is already in use, choose another local port:

```bash
DKCISSP_PORT=1003 ./lab.sh start
```

Use the same `DKCISSP_PORT` value for other commands that check the URL, for example:

```bash
DKCISSP_PORT=1003 ./lab.sh status
```

## What happens automatically

After you start the installer, the lab:

1. Checks that the host is Linux and that the Compose configuration exists.
2. Checks Docker access and Docker Compose availability.
3. Asks before installing missing Docker packages or `curl` on supported apt-based systems.
4. Validates the Compose configuration.
5. Starts the Juice Shop container.
6. Waits up to 90 seconds for an HTTP response.
7. Prints the local URL and next step if the health check succeeds.
8. Gives troubleshooting commands if the health check does not pass.

The lab uses a pinned OWASP Juice Shop image tag for reproducibility. The published container port is bound to `127.0.0.1` by default; it is not intended to be exposed to your LAN or the Internet.

## Everyday commands

Run these from the repository directory:

| Command | What it does |
|---|---|
| `./lab.sh start` | Start the lab and wait for its HTTP health check. |
| `./lab.sh status` | Show container status, local URL, and a health-check result. |
| `./lab.sh scenarios` | Open the guided security-testing menu. |
| `./lab.sh logs` | Follow recent application logs; press Ctrl+C to stop following. |
| `./lab.sh stop` | Stop the service while retaining its container. |
| `./lab.sh reset` | Ask for confirmation, then recreate the application container. Writable application state is discarded. |
| `./lab.sh destroy` | Ask for confirmation, then remove the lab container and its dedicated network. The downloaded image is retained. |
| `./lab.sh --help` | Display the command summary. |

Reset and destroy are intentionally confirmation-gated. Read the prompt before continuing.

## Guided security-testing scenarios

Launch the interactive menu:

```bash
./lab.sh scenarios
```

The current menu includes:

1. **Broken access control** — a guided workflow for checking authorization boundaries.
2. **Injection** — an input-handling checklist.
3. **Cross-site scripting (XSS)** — a safe testing checklist.
4. **Local target health** — check whether the lab responds.

The guides are intentionally human-led. They help you establish normal behavior, inspect requests, test only the local training application, interpret what you observe, record sanitized evidence, and think through remediation and retesting. The presence of a checklist is not proof that a vulnerability exists.

### Mission guides

- [Mission 01 — Injection and input handling](docs/missions/mission-01-injection.md)
- [Mission 02 — Broken access control](docs/missions/mission-02-access-control.md)
- [Mission 03 — Cross-site scripting](docs/missions/mission-03-xss.md)

For each exercise, aim to capture:

- **Objective:** What security property are you checking?
- **Baseline:** What should a normal, authorized user be able to do?
- **Observation:** What request or response provides evidence?
- **Finding:** What did you actually observe? Avoid assumptions.
- **Root cause:** Which missing or incorrect control could explain it?
- **Remediation:** What should the application owner change?
- **Retest:** What evidence would show that the fix works?

Do not include real credentials, session tokens, personal data, or other secrets in screenshots or reports.

## Safety and scope

OWASP Juice Shop is deliberately vulnerable. Use this project only for authorized practice against the local lab instance.

- Keep the published address bound to `127.0.0.1`. Do not change it to `0.0.0.0` or expose it to the Internet.
- Do not point scanners or test scripts at systems you do not own or have explicit permission to assess.
- Use synthetic accounts and data. Never reuse production credentials.
- Review installation prompts and Compose configuration before approving changes.
- Docker access can grant root-equivalent control of the host.
- This project is not designed for production use and does not replace a professional security assessment.

## Troubleshooting

### Docker is not installed

Run:

```bash
./install.sh
```

On a supported apt-based system, the installer asks whether to install Docker packages. You can decline and install/configure Docker yourself, then run the installer again.

### Docker service is not running

```bash
sudo systemctl start docker
./lab.sh status
```

### Docker permission error

The script checks whether Docker is available to your account and can try `sudo docker` when appropriate. If access still fails, check the Docker service and your system's Docker permissions. Do not grant broader Docker access without understanding the security implications.

### Port 1002 is already in use

```bash
DKCISSP_PORT=1003 ./lab.sh start
```

If you select a different port, use that same `DKCISSP_PORT` setting when checking status.

### The application does not become healthy

```bash
./lab.sh status
./lab.sh logs
```

The startup health check waits up to 90 seconds. If the container is still starting, inspect the logs and try the status command again. Check that Docker has enough memory and that the selected port is available.

### Compose configuration fails

Review `docker-compose.yml` and validate it with:

```bash
docker compose -f docker-compose.yml config
```

If your installation uses the standalone Compose command, try `docker-compose -f docker-compose.yml config`.

## How the project is tested

The repository's CI workflow validates shell syntax and the Docker Compose configuration. Local smoke tests have also checked the guided menu, the access-control walkthrough, and the local HTTP health response on the maintainer's Kali machine.

These checks are not a full security audit, and they do not prove that every scenario finds a vulnerability. Installation behavior, scanner integrations, and every reset/destroy edge case still require continued testing on supported systems.

## Roadmap

1. **Reliable foundation:** local deployment, lifecycle commands, health checks, clear errors, and documentation.
2. **Better guided missions:** consistent steps, evidence capture, hints, remediation, and retesting.
3. **More practical scenarios:** expand coverage across the OWASP Top 10 with clear scope and safety boundaries.
4. **Optional tooling:** add scanner integrations and defensive telemetry only when needed, with explicit user control.
5. **Reporting:** produce a clear, evidence-based summary of observations, risk, recommended fixes, and retest results.

Planned items are not yet implemented unless explicitly described as available above.

## Third-party software

This project orchestrates [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/); it does not claim ownership of that software. Review its project documentation and license before redistribution. The image tag is pinned for reproducibility and should only be updated after validation.
