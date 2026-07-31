# Frequently Asked Questions

## Getting started

**Do I need to know how to program?**
No, not to begin. Many labs are solved by crafting input in a browser. You will
learn faster if you can read a little code and are comfortable in a terminal, but
you can start today without it.

**Which range should I run first?**
The `labs` range. It teaches one idea at a time. See RANGES.md for a suggested
path.

**What do I need installed?**
A Linux host or virtual machine with Docker Engine. Nothing else for the `labs` and
web ranges. The `netsec` range includes its own attacker box with tools built in.

**Is this legal?**
Yes, when you attack the RedPlanet targets on your own isolated machine. It is not
legal to use these techniques against systems you do not own or are not authorized
to test. See SAFETY.md.

## Running the ranges

**How do I start a range?**
Run its controller image with the Docker socket mounted. See the main README for
the exact command per range.

**Can I run everything at once?**
Yes. The `latest` (a.k.a. `all`) tag deploys every range together with all port
and naming conflicts resolved: `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:latest`.
It is heavy (GitLab, SonarQube, Jenkins, crAPI, Metasploitable2, Kali, all 13
labs) - use a host with 16 GB+ RAM and give it a few minutes. You still get one
dashboard on port 8000. Optional netsec packs stay opt-in.

**A service will not load in my browser.**
Give it a minute and check `docker ps`. Some services (databases, Java apps,
GitLab) take a while to become healthy. If a container shows as unhealthy or keeps
restarting for several minutes, see below.

**"Port is already in use" when I start a range.**
Another program, or a previously started range, is already using that port. Stop
the other range (see the main README's stop commands) or free the port, then try
again. Remember that the two AppSec ranges share ports and cannot run at once.
Every range serves the dashboard on port 8000, so if you run two ranges at once,
give the second one a different portal port: `PORTAL_PORT=8010 docker run ...`.

**The `10.x` / `172.x` addresses on the dashboard do not open in my browser.**
That is expected. Those are internal container addresses on the range's Docker
network - they are only reachable from inside the range (for example, from the
netsec Kali box). From your own machine, open a target with its `localhost:PORT`
link (the launch button on each card), not the internal IP.

**Which page is the dashboard, and does every range have one?**
The dashboard (Mission Control) is at `http://localhost:8000` and ships with every
range. The scoreboard at `http://localhost:8001` is part of the `labs` range only;
the dashboard shows whether it is running.

**"Permission denied" talking to the Docker socket.**
Run the command with `sudo`, or add your user to the `docker` group
(`sudo usermod -aG docker $USER`) and log out and back in.

**A container keeps restarting or stays unhealthy.**
Check its logs: `docker logs <container-name>`. Common causes are not enough time
to start, or not enough memory on the host (the DevSecOps tools in `full-appsec`
are heavy). Give the host more RAM or run a lighter range.

**DVWA shows a database error.**
DVWA needs a one-time setup: open `http://localhost:8086/setup.php` and click
"Create / Reset Database", then log in with `admin` / `password`.

**How do I stop a range?**
Remove its containers by network. See the main README for the exact command per
range.

## Solving labs

**Where is the objective for a lab?**
On the lab's own page. Each custom lab states what you are trying to do and gives a
hint.

**What is a flag and where do I put it?**
A flag is a short marker like `RP{...}` that appears once you succeed. Submit it on
the scoreboard at `http://localhost:8001` under a handle of your choice.

**I am completely stuck on a lab.**
Re-read the lab page's hint, review the matching entry in CONCEPTS.md, and try the
simplest version of the attack first. Learning to be methodical is part of the
exercise.

## The attacker box (netsec)

**How do I use the Kali box?**
Open a shell on it: `docker exec -it kali bash`. From there, scan and attack the
other hosts on the lab network. The main README lists the target addresses.
