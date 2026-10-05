# Safety and Responsible Use

RedPlanet exists so you can practice offensive security legally and safely. Please
read this before you start.

## These systems are deliberately insecure

Every target in every range is intentionally vulnerable. Treat the whole project
as hostile software. If any of it were reachable from an untrusted network, it
could be attacked and used as a foothold against you.

## Run it in isolation

- Use a dedicated virtual machine or a spare host that contains nothing important.
- Do not run RedPlanet on your primary computer or on a production network.
- Host ports bind to `127.0.0.1` (localhost) by default, so services are reachable
  only from the machine running them. Keep it that way unless you are on a fully
  controlled, isolated lab network.
- Never expose these services to the public internet.

## Only attack what you are allowed to attack

The skills you build here are powerful and, used against systems you do not own,
illegal in most places. The single most important rule in security testing:

- Only test systems that you own, or that you have explicit written permission to
  test.

RedPlanet gives you targets you are permitted to attack. Real-world engagements
require a defined scope and authorization (for example, a signed penetration-test
agreement or a bug-bounty program's rules). Practicing here does not grant you
permission anywhere else.

## Use your skills constructively

The purpose of learning to attack is to defend better: to find and fix weaknesses
before someone malicious does, to build more secure software, and to perform
authorized testing professionally. Keep that intent.

## Data and cleanup

Ranges run locally and keep their data in Docker containers and volumes on your
host. When you are finished, stop and remove a range's containers (see the main
README) and, if you want a clean slate, remove its Docker volumes as well.
