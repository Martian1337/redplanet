# Command Cheat Sheet

A one-page reference. See the main README for full details.

## Deploy a range

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:labs
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:web-pentest
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:full-appsec
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:netsec
```

Run only one AppSec range (`web-pentest` or `full-appsec`) at a time.

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
```

## Access - labs range

- Portal:      http://localhost:8000
- Scoreboard:  http://localhost:8001
- Labs:        http://localhost:5001 through http://localhost:5013

## Access - web-pentest range

- WebGoat http://localhost:8080/WebGoat/login   - Juice Shop http://localhost:8087
- crAPI http://localhost:8888                   - MailHog http://localhost:8025
- Metasploitable2 http://localhost:8081         - VAmPI http://localhost:5050
- DVGA http://localhost:5023                    - PyGoat http://localhost:8083
- WrongSecrets http://localhost:8085            - NodeGoat http://localhost:4000
- DIWA http://localhost:8084                    - DVWA http://localhost:8086

## Access - full-appsec adds

- Jenkins http://localhost:8082   - GitLab http://localhost:8929   - SonarQube http://localhost:9000

## Netsec attacker box

```bash
docker exec -it kali bash          # open a shell on the Kali attacker box

# common first moves from inside kali (targets on 172.20.0.0/24):
nmap -sV 172.20.0.0/24                       # discover hosts and services
dig axfr redplanet.lab @172.20.0.13          # DNS zone transfer
snmpwalk -v2c -c public 172.20.0.12          # SNMP enumeration
redis-cli -h 172.20.0.10 ping                # unauthenticated Redis
enum4linux-ng 172.20.0.8                     # Active Directory / SMB
```

## Default logins (deliberately weak)

| Where | User | Password |
|-------|------|----------|
| crAPI | admin@example.com | Admin!123 |
| DVWA (run /setup.php first) | admin | password |
| Tomcat Manager (netsec) | admin | admin |
| SonarQube | admin | admin |
| Samba AD (netsec) | Administrator | Passw0rd! |
| telnet (netsec) | user | user |

## Common fixes

- Permission denied on Docker: use `sudo`, or `sudo usermod -aG docker $USER` then re-login.
- Port already in use: stop the other range first (see stop commands above).
- Service not loading: wait a minute, then re-check `docker ps`.
- DVWA database error: open http://localhost:8086/setup.php and reset the database.
