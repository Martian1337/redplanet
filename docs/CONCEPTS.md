# Concepts

A short, plain-language explanation of the ideas behind RedPlanet. Read this if
you are new to hands-on security practice.

## Why practice on intentionally vulnerable systems

You cannot learn to find and fix security flaws by reading alone, and you must
never test techniques against systems you do not own or have written permission
to test. RedPlanet solves this by giving you deliberately broken applications and
networks that are yours to attack, in a safe and legal sandbox. The flaws are the
lesson, not accidents to be reported.

## What a "vulnerability" is

A vulnerability is a weakness that lets someone make software behave in a way its
designers did not intend, for example reading data they should not see, or running
commands on a server. An "exploit" is the specific input or technique that takes
advantage of that weakness. The input you send is often called a "payload".

## Flags and the scoreboard

Each custom lab hides a "flag", a short marker that looks like `RP{...}`. You only
see a lab's flag once you have successfully performed its intended exploit, so a
flag is proof that you understood and executed the attack. The scoreboard lets you
submit flags under a handle and tracks your progress. This capture-the-flag (CTF)
style keeps practice goal-directed and measurable.

## The domains RedPlanet covers

- Web application security: attacking the logic of websites and web apps
  (for example, injection and cross-site scripting).
- API security: attacking the machine-to-machine interfaces behind modern apps
  (for example, broken authorization and token handling).
- DevSecOps: the security of the tools that build and ship software (build
  servers, source hosting, code and secret scanners).
- Network security: attacking hosts and services across a network, the way a
  penetration tester would during an internal engagement.
- Cloud security: chaining an app flaw into a cloud-account compromise through the
  provider's metadata service and over-permissive permissions.
- Kubernetes and container security: abusing a cluster's own features to read
  secrets and escape onto the host that runs it.
- Defensive security (blue team): detection and threat hunting - reading
  intrusion-detection alerts to spot attacks rather than carrying them out.

## The attacker box (network security)

In the netsec range you attack from an "attacker box", a Kali Linux container that
sits on the same virtual network as the targets and comes with common tools
pre-installed. This mirrors real assessments, where a tester works from a machine
inside the target network. You open a shell on it with `docker exec -it kali bash`.

## Industry references

Many labs map to well-known catalogs of common weaknesses. You do not need to
memorize these, but they are useful for looking things up:

- OWASP Top 10 - the ten most critical web application risks.
- OWASP API Security Top 10 - the same idea, focused on APIs.
- CWE (Common Weakness Enumeration) - a stable, numbered dictionary of software
  weakness types (for example, CWE-89 is SQL injection).

## The vulnerability classes you will meet

One line each, in plain terms:

- SQL injection: bending a database query with crafted input.
- Cross-site scripting (XSS): getting your script to run in another user's browser.
- Command injection: making a server run operating-system commands you supply.
- Path traversal: reading files outside the folder the app meant to serve.
- Server-side request forgery (SSRF): making the server fetch a URL for you,
  reaching things you could not reach directly.
- Template injection (SSTI): abusing a server's page-templating engine to run code.
- XML external entity (XXE): abusing XML parsing to read files or reach services.
- JWT and broken authentication: forging or bypassing login tokens.
- Insecure deserialization: turning attacker-supplied data back into live objects,
  which can run code.
- GraphQL abuse: over-asking a flexible API to reveal data it should not.
- IDOR / BOLA: changing an identifier to access someone else's data.
- Prototype pollution: corrupting shared object defaults in JavaScript to change
  program behavior.
- Unrestricted file upload: uploading a file the server will execute as code,
  turning an upload feature into remote code execution.
- CORS misconfiguration: a too-trusting cross-origin policy that lets another
  website read a victim's data.
- Mass assignment: sending extra fields the form never showed you (such as a role
  flag) and having the app bind them straight onto an object.
- NoSQL injection: bending a NoSQL database query by supplying an operator object
  instead of a plain value.

## How the ranges run

Each range is delivered as one "controller" image. Running it with the Docker
socket mounted lets it start that range's set of containers on your host. This is
why every deploy command mounts `/var/run/docker.sock`. The controller does the
setup and exits; the range keeps running until you stop it.
