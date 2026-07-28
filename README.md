# RedPlanet

Self-hosted, intentionally vulnerable cybersecurity training ranges, distributed
as Docker images. Each range is a single controller image that brings up a full
lab on your host with one command.

Images are published on Docker Hub under `martiandefense/redplanet`, one tag per
range:

| Tag | Range | Focus |
|-----|-------|-------|
| `labs` | Custom single-vulnerability labs | 13 focused web/API labs, a portal, and a CTF scoreboard |
| `web-pentest` | Web and API AppSec | WebGoat, Juice Shop, crAPI, Metasploitable2, plus 7 OWASP VWAD apps |
| `full-appsec` | AppSec and DevSecOps | The web-pentest range plus Jenkins, GitLab, SonarQube, Trivy, Gitleaks |
| `netsec` | Network security | An in-network Kali box and classic vulnerable services on a static-IP LAN |

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

- A Linux host (or VM) with Docker Engine installed and running.
- The host ports listed per range below must be free.

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
```

Give the services a minute to become healthy (`docker ps`), then open the URLs
listed for that range.

### Stopping a range

The range's services run as named containers on their own Docker network. Remove
them by network:

```bash
docker rm -f $(docker ps -aq --filter network=redplanet-net)   # labs
docker rm -f $(docker ps -aq --filter network=app-network)     # web-pentest / full-appsec
docker rm -f $(docker ps -aq --filter network=training-net)    # netsec
```

---

## Range: `labs`

Thirteen small, single-vulnerability labs, a mission-control portal, and a
persistent CTF scoreboard.

- Portal (index of every target): http://localhost:8000
- Scoreboard (submit flags, leaderboard, survives restarts): http://localhost:8001

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
| vulnserver | 172.20.0.3 | Buffer-overflow / exploit dev |
| vulnerable-ftp | 172.20.0.5 | FTP exploitation |
| vulnerable-ssh | 172.20.0.7 | SSH brute / enumeration |
| samba-ad-dc | 172.20.0.8 | Active Directory / SMB (`Administrator` / `Passw0rd!`) |
| redis-unauth | 172.20.0.10 | Unauthenticated Redis (host :6379) |
| tomcat | 172.20.0.11 | Weak Manager `admin` / `admin` (host :8282) |
| snmp | 172.20.0.12 | SNMP community `public` (host :161/udp) |
| bind9 | 172.20.0.13 | DNS zone transfer: `dig axfr redplanet.lab @172.20.0.13` |
| telnet | 172.20.0.14 | Weak login `user` / `user` (host :2323) |
| smtp | 172.20.0.20 | Open mail relay (host :2525) |

Optional add-on packs are gated behind Docker Compose profiles when running from
source (`cve`, `ics`, `voip`, `pivot`): a vulhub CVE corner, OpenPLC (ICS),
Asterisk (VoIP), and a pivoting scenario.

---

## Credits

RedPlanet bundles well-known intentionally vulnerable projects from their
original authors, including OWASP WebGoat, Juice Shop, crAPI, PyGoat, NodeGoat,
WrongSecrets, DVWA, DVGA (Dolev Farhi), VAmPI (erev0s), DIWA (snsttr),
Metasploitable2, and others, alongside original single-vulnerability labs created
for RedPlanet. All third-party components remain under their respective licenses.

## License

RedPlanet's own materials (this documentation and the original labs) are released
under the MIT License - see [LICENSE](LICENSE). Bundled third-party applications
and images remain under their respective upstream licenses (see Credits above).
