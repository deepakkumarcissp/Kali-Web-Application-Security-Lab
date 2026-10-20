# Installation and First Run

## One-command setup

From a Kali Linux terminal:

```bash
git clone https://github.com/deepakkumarcissp/Kali-Web-Application-Security-Lab.git && cd Kali-Web-Application-Security-Lab && chmod +x install.sh lab.sh && ./install.sh
```

This is one copy-paste setup command. During development, the repository may require GitHub access. The installer can ask for permission to install Docker packages on an apt-based system; system package installation requires administrative privileges.

## What success looks like

The installer should validate the Compose file, start the Juice Shop container, and wait for an HTTP response. It should print a local URL, usually `http://127.0.0.1:3000`.

## Before reporting a problem

Run:

```bash
./lab.sh status
./lab.sh logs
```

When reporting a problem, include your Kali version, Docker/Compose version, the failed command, and sanitized output. Never include credentials or private tokens.
