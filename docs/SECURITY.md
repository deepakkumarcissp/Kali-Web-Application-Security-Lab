# Security Notes

## Scope

This is a deliberately vulnerable training target intended to run on the learner's own Kali Linux VM. It is not suitable for production or shared public hosting.

## Network boundaries

- The Compose published port binds to `127.0.0.1` by default.
- Do not expose the application through router port forwarding, a public reverse proxy, or a public cloud host.
- Only test the local lab application unless you have separate, explicit authorization for another target.

## Host considerations

- Docker daemon access can provide root-equivalent control of the host.
- Keep the VM updated and use a snapshot before experiments if practical.
- The container drops Linux capabilities and enables `no-new-privileges`. These settings still need validation against the pinned application image during local testing.
- Do not run the lab on a machine containing sensitive work data if you can use a dedicated VM instead.

## Reporting

Please do not publish secrets, tokens, personal information, or screenshots containing sensitive data in issue reports. Include sanitized logs and reproduction steps instead.
