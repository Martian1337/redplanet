# The Ranges and How to Use Them

RedPlanet is divided into seven ranges. Each has a different purpose. This page
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
5. Branch into `cloud` and `k8s` when you are ready to attack modern
   infrastructure: a cloud provider's APIs and metadata service, and a Kubernetes
   cluster. These chain small misconfigurations into full compromise.
6. Finish with `blue`. It flips the perspective: instead of attacking, you defend,
   hunting through intrusion-detection alerts to spot the attacks you have learned.

You do not have to finish one range before touching another. This is only a guide.

## Range: labs

Intent: teach one vulnerability class per target, with the smallest possible app
around it, so the concept is obvious.

Best for: beginners, and anyone wanting a focused refresher on a specific class.

What you get: seventeen labs, the Mission Control dashboard that indexes them, and
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
(open a shell with `docker exec -it kali bash`). The always-on targets include a
classic multi-service host, weak FTP/SSH/telnet, a Samba/SMB file server, an
unauthenticated database (Redis), a misconfigured web server (Tomcat), and
services for enumeration practice (SNMP, DNS zone transfer, an open mail relay).

Optional, opt-in add-on packs extend the range when you want a specific scenario:
an Active Directory domain (for Kerberoasting, AS-REP roasting, DCSync, and lateral
movement), specific historical CVEs, an industrial-control (ICS/Modbus) target, a
VoIP server, a pivoting scenario where you must compromise one host to reach a
hidden network behind it, a database server, a Linux privilege-escalation box, a
container-escape box, and an anonymous file share.

How to work it: from the Kali box, scan the network to discover targets, enumerate
each service, then exploit the weaknesses. The main README lists the addresses and
starting hints for each host.

## Range: cloud

Intent: practice cloud security by chaining a web-app flaw into a full cloud
account compromise, the way real cloud breaches unfold.

Best for: learners moving into cloud and wanting to understand how one small
mistake in an app can expose an entire cloud environment.

What you get: a self-contained, AWS-style cloud (built on LocalStack, so nothing
touches a real cloud account) and a web console with a server-side request forgery
(SSRF) weakness. The intended path: use the SSRF to reach the internal instance
metadata service, steal the temporary credentials it hands out, and then abuse
over-permissive permissions to loot storage buckets, secrets, and more.

How to work it: open the console, find the SSRF, and follow the chain inward. Each
step hands you what you need for the next, and capturing the final flags proves you
reached the secrets.

## Range: k8s

Intent: practice Kubernetes attacks, where a cluster's own features become the
escalation path.

Best for: learners interested in containers and orchestration security.

What you get: a single-node Kubernetes cluster deliberately left open. The intended
path: connect to the cluster anonymously (where anyone is treated as a full
administrator), read a secret you should not be able to see, launch a privileged
pod, and use it to escape onto the underlying node's filesystem - owning the host
that runs the cluster.

How to work it: use the in-cluster toolbox (`docker exec -it k8s-toolbox bash`) or
the exposed API, work through the chain, and capture the flags that mark reading
the secret and escaping to the node.

## Range: blue

Intent: practice defence. This range is about detection and threat hunting, not
exploitation.

Best for: anyone interested in the blue-team side - security operations, intrusion
detection, and investigation - and for giving context to everything the offensive
ranges teach.

What you get: an intrusion-detection system (Suricata) watching a stream of replayed
attack traffic (port scans, suspicious user agents, command-and-control beacons,
cleartext credentials, and data smuggled out over DNS), plus a security-operations
dashboard for reviewing the alerts.

How to work it: open the dashboard, hunt through the alerts to understand what each
attack looks like on the wire, and decode the data being smuggled out over DNS to
capture the flag.
