# Getting Started

This guide takes you from nothing to solving your first lab. No prior security
experience is assumed. You do need to be comfortable running commands in a Linux
terminal.

## 1. Prepare an isolated machine

Everything in RedPlanet is intentionally insecure, so run it somewhere isolated:
a dedicated virtual machine, or a spare Linux host that holds nothing important
and is not on a production network. Do not run these ranges on your daily work
computer.

## 2. Install Docker

RedPlanet ranges ship as Docker images, so you need Docker Engine.

- Install: https://docs.docker.com/engine/install/
- Confirm it works:

  ```bash
  docker run --rm hello-world
  ```

  If you get a "permission denied" error talking to the Docker socket, either run
  Docker commands with `sudo`, or add your user to the `docker` group
  (`sudo usermod -aG docker $USER`, then log out and back in).

## 3. Launch the labs range

Start with the `labs` range. It is the gentlest introduction.

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock martiandefense/redplanet:labs
```

What just happened: RedPlanet ships each range as a small "controller" image. When
you run it with the Docker socket mounted, it starts the range's containers on
your host and then exits. The lab containers keep running.

Give it a minute, then check that things are healthy:

```bash
docker ps
```

## 4. Open Mission Control

In a browser on the same machine, open:

- http://localhost:8000 - the dashboard (a live index of every target, with a
  launch button for each; ships with every range)
- http://localhost:8001 - the scoreboard (where you submit flags; `labs` only)

Always open a target with its **`localhost:PORT`** button. The `10.x` addresses
on the cards are internal container addresses and will not open in your browser.

## 5. Solve your first lab (a worked example)

Open the SQL injection lab, "phobos-sqli", at http://localhost:5001.

The goal, shown on the page, is to log in as the `admin` user without knowing the
password. The login form is vulnerable to SQL injection: it builds a database
query by pasting your input directly into it. That means your input can change
what the query does.

Try this in the "Callsign" (username) field, and anything in the password field:

```
admin' -- 
```

(Note the space after `--`.) Submit it. You are logged in as admin, and the page
shows a flag that looks like:

```
RP{ph0b0s_un10n_crossed_the_relay}
```

Why it worked, in plain terms: the app intended to check "username = admin AND
password = whatever". The `'` closed the username value early, and `--` turned the
rest of the query (the password check) into an ignored comment. The database only
saw "username = admin", so it let you in.

## 6. Record the flag

Open the scoreboard at http://localhost:8001, choose a handle (a nickname), paste
the flag, and submit. Your progress is saved and survives restarts.

## 7. Keep going

Every lab on the portal has its objective and a hint written on its own page.
Work through them at your own pace. See RANGES.md for a suggested order and
CONCEPTS.md if a term is unfamiliar.

## 8. Stop the range when you are done

```bash
docker rm -f $(docker ps -aq --filter network=redplanet-net)
```

This removes the lab containers. (Other ranges use different networks; see the
main README for their stop commands.)

## Troubleshooting

- A service will not load: wait another minute and re-check `docker ps`; some
  services take time to become healthy.
- "Port is already in use": another program (or an old range) is using that port.
  Stop the old range, or free the port, and try again.
- See FAQ.md for more.
