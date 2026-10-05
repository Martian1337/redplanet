# Command Cheat Sheet

A one-page reference. See the main README for full details.

## Deploy a range

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:labs
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:web-pentest
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:full-appsec
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:netsec
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:cloud
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:k8s
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:blue

# Everything at once (heavy - 16 GB+ RAM):
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:latest
```

Run only one AppSec range (`web-pentest` or `full-appsec`) at a time. The
`latest` tag deploys all ranges together with conflicts already resolved.

## Check status

```bash
docker ps                                                   # running containers
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
docker logs <container-name>                                # a container's output
```

## Stop a range (remove its containers)

```bash
docker rm -f $(docker ps -aq --filter network=redplanet-net)   # labs
docker rm -f $(docker ps -aq --filter network=app-network)     # web-pentest / full-appsec
docker rm -f $(docker ps -aq --filter network=training-net)    # netsec

# cloud, k8s, and blue: stop each with its own controller
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down martiandefense/redplanet:cloud
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down martiandefense/redplanet:k8s
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down martiandefense/redplanet:blue

# Everything (the latest / all deploy):
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down martiandefense/redplanet:latest
```

## Bring parts up or down (RP_ACTION / RP_ONLY)

```bash
# Stop one range you started from its own tag:
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down martiandefense/redplanet:netsec

# From the combined image, act on one portion
# (all|portal|labs|web|devsecops|netsec|cloud|k8s|blue):
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e RP_ACTION=down -e RP_ONLY=devsecops martiandefense/redplanet:latest
```

## Access - dashboard and scoreboard

- Dashboard:   http://localhost:8000   (one shared dashboard, all ranges)
- Scoreboard:  http://localhost:8001   (labs range only)
- Run several ranges at once and they reuse the same dashboard - no config needed.

## Access - labs range

- Labs:        http://localhost:5001 through http://localhost:5017

## Access - web-pentest range

- WebGoat http://localhost:8080/WebGoat/login   - Juice Shop http://localhost:8087
- crAPI http://localhost:8888                   - MailHog http://localhost:8025
- Metasploitable2 http://localhost:8081         - VAmPI http://localhost:5050
- DVGA http://localhost:5023                    - PyGoat http://localhost:8083
- WrongSecrets http://localhost:8085            - NodeGoat http://localhost:4000
- DIWA http://localhost:8084                    - DVWA http://localhost:8086
- (optional reverse proxy on http://localhost:8090)

Note: DVWA needs one-time setup - open http://localhost:8086/setup.php and reset
the database, then log in with `admin` / `password`.

## Access - full-appsec adds

- Jenkins http://localhost:8082   - GitLab http://localhost:8929   - SonarQube http://localhost:9000
- (Trivy and Gitleaks are command-line scanners, not web UIs)

## Access - cloud range

- SSRF console: http://localhost:5085   - fake AWS API: http://localhost:4566
- Chain: SSRF -> internal instance metadata service (IMDS) -> steal role creds ->
  abuse over-permissive IAM -> loot S3 / Secrets Manager / Lambda.

## Access - k8s range

- API server: https://localhost:6443 (system:anonymous is cluster-admin)
- Exposed app: http://localhost:30080
- In-cluster toolbox: `docker exec -it k8s-toolbox bash`
- Chain: anonymous RBAC -> read a Secret -> privileged/hostPath pod -> escape to node.

## Access - blue range

- SOC dashboard: http://localhost:5088 (detection and threat hunting, not exploitation)
- Hunt the Suricata alerts and decode the DNS-exfiltration subdomain for the flag.

## Netsec attacker box

```bash
docker exec -it kali bash          # open a shell on the Kali attacker box

# common first moves from inside kali (targets on 172.20.0.0/24):
nmap -sV 172.20.0.0/24                       # discover hosts and services
dig axfr redplanet.lab @172.20.0.13          # DNS zone transfer
snmpwalk -v2c -c public 172.20.0.12          # SNMP enumeration
redis-cli -h 172.20.0.10 ping                # unauthenticated Redis
enum4linux-ng 172.20.0.8                     # Samba / SMB enumeration
```

## Default logins (deliberately weak)

| Where | User | Password |
|-------|------|----------|
| crAPI | admin@example.com | Admin!123 |
| DVWA (run /setup.php first) | admin | password |
| SonarQube | admin | admin |
| FTP (netsec) | ftpuser | ftppass123 |
| SSH (netsec) | root | root |
| Samba / SMB (netsec) | smbuser | smbpass123 |
| Tomcat Manager (netsec) | admin | admin |
| telnet (netsec) | user | user |
| MSSQL (netsec `db` pack) | sa | Sup3rWeak! |
| Linux privesc box (netsec `privesc` pack) | lowpriv | lowpriv |
| Container-escape box (netsec `escape` pack) | builder | builder |

## Common fixes

- Permission denied on Docker: use `sudo`, or `sudo usermod -aG docker $USER` then re-login.
- Port already in use: stop the other range first (see stop commands above).
- Service not loading: wait a minute, then re-check `docker ps`.
- DVWA database error: open http://localhost:8086/setup.php and reset the database.
