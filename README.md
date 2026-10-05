# RedPlanet

Self-hosted, intentionally vulnerable cybersecurity training ranges, distributed
as Docker images. Each range is a single controller image that brings up a full
lab on your host with one command.

Images are published on Docker Hub under `martiandefense/redplanet`, one tag per
range:

| Tag | Range | Focus |
|-----|-------|-------|
| `labs` | Custom single-vulnerability labs | 17 focused web/API labs, a portal, and a CTF scoreboard |
| `web-pentest` | Web and API AppSec | WebGoat, Juice Shop, crAPI, Metasploitable2, plus 7 OWASP VWAD apps |
| `full-appsec` | AppSec and DevSecOps | The web-pentest range plus Jenkins, GitLab, SonarQube, Trivy, Gitleaks |
| `netsec` | Network security | An in-network Kali box and classic vulnerable services on a static-IP LAN |
| `cloud` | Cloud security | A LocalStack "AWS" with an SSRF console: pivot to the metadata service, steal credentials, loot S3 / Secrets Manager |
| `k8s` | Kubernetes security | A single-node k3s cluster: anonymous cluster-admin RBAC, then a privileged/hostPath escape to the node |
| `blue` | Blue-team detection | A Suricata IDS and SOC dashboard replaying attack traffic for you to hunt |
| `latest` (= `all`) | Everything at once | All seven ranges deployed together, conflicts resolved - see "Deploy everything" below |

---

## Documentation

New to hands-on security practice? Start with these:

- [docs/GETTING-STARTED.md](docs/GETTING-STARTED.md) - from zero to your first solved lab
- [docs/CONCEPTS.md](docs/CONCEPTS.md) - the ideas behind the ranges, in plain language
- [docs/RANGES.md](docs/RANGES.md) - what each range is for, and a suggested learning path
- [docs/SAFETY.md](docs/SAFETY.md) - responsible and legal use
- [docs/FAQ.md](docs/FAQ.md) - common questions and troubleshooting
- [docs/GLOSSARY.md](docs/GLOSSARY.md) - definitions of the terms used here
- [docs/CHEATSHEET.md](docs/CHEATSHEET.md) - one-page reference of the common commands
- [docs/HINTS.md](docs/HINTS.md) - spoiler-free, tiered hints for each lab

---

## Requirements

- A Linux host or virtual machine to run on. Everything here is intentionally
  vulnerable, so use an isolated machine, not your daily computer.
- Docker Engine installed and the daemon running.
  Install guide: https://docs.docker.com/engine/install/
- The host ports listed per range below must be free.

### Docker permissions (one-time setup)

The Docker daemon is owned by root, so plain `docker` commands need elevated
access. Either prefix every command with `sudo`, or (recommended) add your user to
the `docker` group so you can run Docker without `sudo`:

```bash
sudo usermod -aG docker "$USER"
```

Group membership only takes effect in a new login session. After running that, log
out and back in (or open a fresh terminal, or run `newgrp docker`), then verify:

```bash
docker run --rm hello-world
```

If that works without `sudo`, you are ready. If you still see "permission denied
while trying to connect to the Docker socket at unix:///var/run/docker.sock", your
current terminal has not picked up the new group yet - start a fresh login session,
or use `sudo` for now.

## Warning

Every service in these ranges is deliberately insecure. Run them only on an
isolated host or a dedicated lab VM, never on a machine with sensitive data or on
a production network. Host ports bind to `127.0.0.1` by default; do not expose
these services to any network you do not fully control.

---

## Deploy a range

Each range is launched by running its controller image with the Docker socket
mounted. The controller uses the socket to start the range's containers on your
host, then exits; the range keeps running.

```bash
# Custom labs (portal + scoreboard)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:labs

# Web / API AppSec
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:web-pentest

# Full AppSec + DevSecOps
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:full-appsec

# Network security
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:netsec

# Cloud security (LocalStack "AWS")
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:cloud

# Kubernetes security (single-node k3s)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:k8s

# Blue-team detection (Suricata + SOC dashboard)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:blue
```

Give the services a minute to become healthy (`docker ps`), then open the URLs
listed for that range.

### Deploy everything at once

The `latest` (a.k.a. `all`) tag is a combined controller that brings up **every
range together** - the labs, the web/API apps, the DevSecOps toolchain, the
netsec LAN, the cloud range, the Kubernetes cluster, and the blue-team stack -
with all port and naming conflicts resolved for you:

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:latest
```

This is heavy: it runs GitLab, SonarQube, Jenkins, the crAPI stack,
Metasploitable2, Samba, a Kali box, a k3s cluster, LocalStack, Suricata, and all
17 labs at the same time. Use a host with plenty of RAM (16 GB or more
recommended) and give it a few minutes to settle. You get a single Mission
Control dashboard on port 8000 that lights up each range as it comes online. The
optional netsec add-on packs (`ad`/`cve`/`ics`/`voip`/`pivot`/`db`/`privesc`/`escape`/`share`)
are not included here - they stay opt-in.

To stop everything, run the same image with `RP_ACTION=down`:

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -e RP_ACTION=down martiandefense/redplanet:latest
```

Or remove the containers of each project directly:

```bash
for p in redplanet-portal redplanet-labs redplanet-web redplanet-devsecops \
         redplanet-netsec redplanet-cloud redplanet-k8s redplanet-blue; do
  docker rm -f $(docker ps -aq --filter "label=com.docker.compose.project=$p") 2>/dev/null
done
```

### Mission Control dashboard (every range)

Whichever range you start, it comes with the Mission Control dashboard at
**http://localhost:8000**. It is a live index of every target that:

- probes each service and shows which **environments are active and detected**;
- turns every reachable target into a labelled launch button;
- provides search, per-range filters, spoiler-free hints, per-range network
  diagrams, and (for the labs) capture tracking.

Open a target from your host using its **`localhost:PORT`** link. The `10.x` /
`172.x` addresses shown on the cards are internal container addresses on the
range's Docker network - they are not reachable from your browser; they are there
so you know each host's address when attacking from inside the range (for
example, from the netsec Kali box).

The dashboard is a single shared service. If you run more than one range at the
same time (for example `web-pentest` and `netsec`), they **reuse the same
dashboard** on port 8000 instead of conflicting, and it detects every range that
is up - no extra configuration needed.

The **CTF scoreboard** (http://localhost:8001) ships only with the `labs` range;
the dashboard detects whether it is present and links to it when it is.

### Bring parts up or down

The full deployment is heavy, so you can start or stop portions with two
environment variables on the same `docker run` command:

- `RP_ACTION` = `up` (default) or `down`
- `RP_ONLY` = `all` (default), `portal`, `labs`, `web`, `devsecops`, `netsec`,
  `cloud`, `k8s`, or `blue` (the `RP_ONLY` selector applies to the combined
  `latest` image)

```bash
# From an "everything" deploy, drop just the heavy DevSecOps tools:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -e RP_ACTION=down -e RP_ONLY=devsecops martiandefense/redplanet:latest

# Tear down a single range you started from its own tag:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  -e RP_ACTION=down martiandefense/redplanet:netsec
```

Tearing a range down leaves the shared dashboard running. To remove the dashboard
too, use `-e RP_ACTION=down -e RP_ONLY=portal` (or `-e RP_ACTION=down` on the
`latest` image, which removes everything).

### Stopping a range

The range's services run as named containers on their own Docker network. Remove
them by network:

```bash
docker rm -f $(docker ps -aq --filter network=redplanet-net)   # labs
docker rm -f $(docker ps -aq --filter network=app-network)     # web-pentest / full-appsec
docker rm -f $(docker ps -aq --filter network=training-net)    # netsec
docker rm -f $(docker ps -aq --filter network=cloud-net)       # cloud
docker rm -f $(docker ps -aq --filter network=k8s-net)         # k8s
docker rm -f $(docker ps -aq --filter network=blue-net)        # blue
```

---

## Range: `labs`

Seventeen small, single-vulnerability labs, the Mission Control dashboard, and a
persistent CTF scoreboard.

- Dashboard (index of every target - ships with every range): http://localhost:8000
- Scoreboard (submit flags, leaderboard, survives restarts - `labs` only): http://localhost:8001

| Lab | Vulnerability | URL |
|-----|---------------|-----|
| phobos-sqli | SQL injection | http://localhost:5001 |
| deimos-xss | Cross-site scripting | http://localhost:5002 |
| ares-cmdi | OS command injection | http://localhost:5003 |
| valles-traversal | Path traversal / LFI | http://localhost:5004 |
| olympus-ssrf | Server-side request forgery | http://localhost:5005 |
| curiosity-ssti | Template injection (Jinja2) | http://localhost:5006 |
| viking-xxe | XML external entity | http://localhost:5007 |
| perseverance-jwt | JWT / broken auth | http://localhost:5008 |
| cydonia-deserialize | Insecure deserialization | http://localhost:5009 |
| tharsis-graphql | GraphQL abuse | http://localhost:5010 |
| elysium-idor | IDOR / BOLA | http://localhost:5011 |
| noctis-proto | Prototype pollution | http://localhost:5012 |
| arcadia-gauntlet | Chained multi-vulnerability CTF | http://localhost:5013 |
| hellas-upload | Unrestricted file upload → RCE | http://localhost:5014 |
| utopia-cors | CORS misconfiguration | http://localhost:5015 |
| gale-massassign | Mass assignment | http://localhost:5016 |
| jezero-nosqli | NoSQL injection | http://localhost:5017 |

Each lab awards a flag of the form `RP{...}` when its intended exploit succeeds.
Submit captured flags on the scoreboard.

---

## Range: `web-pentest`

Well-known vulnerable web and API applications.

| Application | URL | Notes |
|-------------|-----|-------|
| WebGoat | http://localhost:8080/WebGoat/login | Register an account |
| Juice Shop | http://localhost:8087 | |
| crAPI (vulnerable API) | http://localhost:8888 | Login `admin@example.com` / `Admin!123` |
| MailHog (crAPI mail) | http://localhost:8025 | |
| Metasploitable2 | http://localhost:8081 | DVWA at `/dvwa`, Mutillidae at `/mutillidae/` |
| VAmPI (vulnerable API) | http://localhost:5050 | |
| DVGA (GraphQL) | http://localhost:5023 | |
| PyGoat | http://localhost:8083 | |
| WrongSecrets | http://localhost:8085 | |
| NodeGoat | http://localhost:4000 | |
| DIWA | http://localhost:8084 | |
| DVWA | http://localhost:8086 | Run `/setup.php` once, then login `admin` / `password` |

An optional reverse proxy (Compose profile `proxy`) can path-route every app
onto a single port (`http://localhost:8090`) instead of a wall of ports.

---

## Range: `full-appsec`

Everything in `web-pentest`, plus a DevSecOps toolchain. Run only one AppSec
range at a time; they share host ports.

| Tool | URL | Notes |
|------|-----|-------|
| Jenkins | http://localhost:8082 | CI/CD |
| GitLab CE | http://localhost:8929 | Self-hosted Git + CI |
| SonarQube | http://localhost:9000 | Static analysis, login `admin` / `admin` |
| Trivy | (CLI) | `docker exec trivy trivy image <image>` |
| Gitleaks | (CLI) | `docker exec gitleaks gitleaks ...` |

---

## Range: `netsec`

A static-IP LAN on `172.20.0.0/24`, attacked from an in-network Kali box. Open a
shell on the attacker box:

```bash
docker exec -it kali bash
```

| Host | Address | Practice |
|------|---------|----------|
| kali (attacker) | 172.20.0.100 | `docker exec -it kali bash` |
| metasploitable2 | 172.20.0.2 | Classic multi-service target |
| vulnerable-ftp | 172.20.0.5 | FTP - weak login `ftpuser` / `ftppass123` |
| vulnerable-ssh | 172.20.0.7 | SSH - weak login `root` / `root` |
| samba-ad-dc | 172.20.0.8 | SMB - guest share + `smbuser` / `smbpass123` (host :139/:445) |
| redis-unauth | 172.20.0.10 | Unauthenticated Redis (host :6379) |
| tomcat | 172.20.0.11 | Weak Manager `admin` / `admin` (host :8282) |
| snmp | 172.20.0.12 | SNMP community `public` (host :161/udp) |
| bind9 | 172.20.0.13 | DNS zone transfer: `dig -p 5353 axfr redplanet.lab @127.0.0.1` |
| telnet | 172.20.0.14 | Weak login `user` / `user` (host :2323) |
| smtp | 172.20.0.20 | Open mail relay (host :2525) |

Optional add-on packs are gated behind Docker Compose profiles: an Active
Directory domain (`ad` - a Samba DC `REDPLANET.LOCAL` plus a domain-joined member
for Kerberoasting, AS-REP roasting, DCSync and lateral movement), a vulhub CVE
corner (`cve`), OpenPLC/Modbus ICS (`ics`), Asterisk VoIP (`voip`), a pivoting
scenario into an isolated subnet (`pivot`), MSSQL (`db`), a Linux privesc box
(`privesc`), a Docker-socket container escape (`escape`), and an anonymous rsync
share (`share`).

---

## Range: `cloud`

An AWS-style range built on [LocalStack](https://localstack.cloud/). The intended
path is a classic cloud attack chain, start to finish:

1. Find a server-side request forgery (SSRF) in the console at
   **http://localhost:5085**.
2. Point it at the internal instance **metadata service (IMDS)** to steal the
   instance role's temporary credentials.
3. Use those credentials against the fake AWS API at **http://localhost:4566** to
   abuse over-permissive IAM and loot S3, Secrets Manager, and Lambda for the
   flags.

The metadata service is internal-only - it is reachable only through the SSRF,
exactly as in a real cloud environment.

---

## Range: `k8s`

A single-node [k3s](https://k3s.io/) cluster seeded with realistic
misconfigurations. Work from the in-cluster toolbox:

```bash
docker exec -it k8s-toolbox bash
```

- The Kubernetes API server is at **https://localhost:6443**, where
  `system:anonymous` is bound to **cluster-admin** - enumerate your rights and
  read a Secret you should never be able to reach.
- An anonymously-exposed NodePort app is at **http://localhost:30080**.
- From there, schedule a privileged / `hostPath` pod to **escape onto the node**
  and read a file that lives only on the node's filesystem.

---

## Range: `blue`

The defensive range. A Suricata IDS watches the network while a replay engine
loops suspicious traffic (port scans, a bad user-agent, a C2 beacon, cleartext
credentials, DNS exfiltration). Open the SOC dashboard at
**http://localhost:5088**, triage the alerts, and decode the DNS-exfiltration
subdomain to capture the flag. This range is about reading telemetry and hunting,
not exploitation.

---

## Credits

RedPlanet bundles well-known intentionally vulnerable projects from their
original authors, including OWASP WebGoat, Juice Shop, crAPI, PyGoat, NodeGoat,
WrongSecrets, DVWA, DVGA (Dolev Farhi), VAmPI (erev0s), DIWA (snsttr),
Metasploitable2, and others, alongside original single-vulnerability labs created
for RedPlanet. The cloud range uses LocalStack, the Kubernetes range uses k3s, and
the blue-team range uses Suricata. All third-party components remain under their
respective licenses.

## License

RedPlanet's own materials (this documentation and the original labs) are released
under the MIT License - see [LICENSE](LICENSE). Bundled third-party applications
and images remain under their respective upstream licenses (see Credits above).
