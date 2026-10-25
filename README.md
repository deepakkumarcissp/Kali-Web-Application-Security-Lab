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

## Use these targets with the DKCISSP Web Security Scanner

The lab provides vulnerable applications; the separate scanner performs the assessment. Both projects are maintained separately:

- **Lab installer:** [DKCISSP Kali Web Application Security Lab](https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab)
- **Scanner:** [DKCISSP Web Security Scanner](https://github.com/deepakkumarcissp/Web-Security-Scanner)

### End-to-end workflow

1. **Start the lab.** In the lab repository, run `./install.sh` and wait until it reports that the three targets are responding.
2. **Start the scanner.** Follow the scanner repository's setup instructions and open its local dashboard at `http://127.0.0.1:1005`.
3. **Register each target.** In the scanner's **Asset Inventory**, add the exact target URL from the table above, confirm you are authorized to test it, and set its scope to **In Scope**. Repeat only for the targets you intend to assess.
4. **Choose the target.** In **Assess Website**, select the target from **DKCISSP Local Lab Target**. The selector fills the URL only; it does not register or approve the target for you.
5. **Authorize and scan.** Confirm the scan authorization checkbox and start with **Quick** for a low-impact baseline, or **Standard** for broader bounded discovery. Use **Active** only when you intentionally want active payload testing and understand its impact.
6. **Review the evidence.** Inspect the findings, affected URLs, evidence, severity, and remediation guidance. Treat automated results as leads to verify—not as proof by themselves.
7. **Retest.** After changing the lab or a test condition, run the same profile again and compare the completed scans.

| Application | URL to register in Asset Inventory |
|---|---|
| OWASP Juice Shop | `http://127.0.0.1:1003` |
| DVWA | `http://127.0.0.1:1006` |
| OWASP WebGoat | `http://127.0.0.1:1007/WebGoat` |

Start with passive and non-destructive checks. Use exploit validation only against these local training targets and only when you understand the potential impact. A response code or automated scanner alert alone does not prove a vulnerability; manually verify findings.

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
