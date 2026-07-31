# The Ranges and How to Use Them

RedPlanet is divided into four ranges. Each has a different purpose. This page
explains what each one is for, who it suits, and a sensible order to work through
them. For the exact deploy commands, targets, ports, and logins, see the main
README.

## A suggested learning path

1. Start with `labs`. The custom labs isolate one vulnerability at a time, so you
   learn each idea cleanly before seeing it tangled up in a real application.
2. Move to `web-pentest`. Here the same vulnerability classes appear inside full,
   realistic web and API applications, where you also have to do reconnaissance
   and find the vulnerable feature yourself.
3. Try `full-appsec` when you want to see security in the software delivery
   pipeline (build servers, source hosting, code scanners), not just the app.
4. Explore `netsec` in parallel or afterward. It is a different discipline:
   attacking hosts and services across a network rather than a single web app.

You do not have to finish one range before touching another. This is only a guide.

## Range: labs

Intent: teach one vulnerability class per target, with the smallest possible app
around it, so the concept is obvious.

Best for: beginners, and anyone wanting a focused refresher on a specific class.

What you get: thirteen labs, the Mission Control dashboard that indexes them, and
a scoreboard that tracks the flags you capture. The labs roughly increase in
difficulty. The final target, `arcadia-gauntlet`, is a capstone that chains
several weaknesses together into a short mission, the way a real finding often
requires more than one step.

How to work it: open the dashboard (http://localhost:8000), pick a lab, read its
on-page objective and hint, try to capture the flag, then submit it on the
scoreboard. If you get stuck, the lab pages explain the intended path.

Note: the dashboard ships with every range, but the scoreboard is part of the
`labs` range only.

## Range: web-pentest

Intent: practice on the same intentionally vulnerable web and API applications
that the security community uses as standards, including OWASP projects.

Best for: learners ready to move from isolated labs to realistic targets, and
anyone focusing on web or API assessment skills.

What you get: classic web targets (for example WebGoat, Juice Shop, DVWA), a full
vulnerable API (crAPI) plus additional API and GraphQL targets, and a broad host
(Metasploitable2) that bundles several older vulnerable web apps. Because these are
complete applications, part of the exercise is finding the weak spot yourself.

Note: run only one AppSec range at a time (`web-pentest` or `full-appsec`), because
they use the same host ports.

## Range: full-appsec

Intent: extend web and API practice into DevSecOps, the security of the tools that
build and ship software.

Best for: learners interested in build pipelines, source-code hosting, and the
scanners that catch problems before release.

What you get: everything in `web-pentest`, plus a continuous-integration server,
a self-hosted source platform, a static-analysis server, and command-line scanners
for containers and secrets. This lets you practice both attacking these systems and
using the defensive tooling that teams rely on.

## Range: netsec

Intent: practice network penetration testing: discovering hosts and services,
enumerating them, exploiting weak services, and moving through a network.

Best for: learners interested in infrastructure and internal-network assessment,
rather than only web applications.

What you get: a private lab network you attack from an included Kali "attacker box"
(open a shell with `docker exec -it kali bash`). Targets include a classic
multi-service host, a buffer-overflow practice service, weak FTP/SSH/telnet, an
Active Directory domain controller, an unauthenticated database, a misconfigured
web server, and services for enumeration practice (SNMP, DNS zone transfer, an open
mail relay). Optional add-on packs (when run from source) add specific historical
CVEs, an industrial-control target, a VoIP server, and a pivoting scenario where
you must compromise one host to reach a hidden network behind it.

How to work it: from the Kali box, scan the network to discover targets, enumerate
each service, then exploit the weaknesses. The main README lists the addresses and
starting hints for each host.
