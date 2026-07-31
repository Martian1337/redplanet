# Glossary

Plain-language definitions of terms used across RedPlanet.

- Vulnerability: a weakness that lets software be misused in an unintended way.
- Exploit: the specific technique or input that takes advantage of a vulnerability.
- Payload: the crafted input you send to trigger a vulnerability.
- Flag: a short marker like `RP{...}` revealed when you succeed, used as proof.
- CTF (Capture The Flag): a style of practice where success is proven by finding
  hidden flags.
- Reconnaissance (recon): gathering information about a target before attacking.
- Enumeration: systematically listing a target's details (users, services, shares,
  records) to find a way in.
- Reconnaissance vs enumeration: recon is broad information gathering; enumeration
  is the detailed listing that follows.

## Web and API weaknesses

- SQL injection (SQLi): altering a database query by injecting input into it.
- Cross-site scripting (XSS): getting your script to run in another user's browser.
- Command injection: making a server run operating-system commands you supply.
- Remote code execution (RCE): the ability to run your own code on a target; the
  most severe outcome of many bugs.
- Path traversal / Local File Inclusion (LFI): reading files outside the intended
  folder by manipulating a file path.
- Server-side request forgery (SSRF): making the server send requests on your
  behalf to reach systems you cannot reach directly.
- Server-side template injection (SSTI): abusing a page-templating engine to run
  code on the server.
- XML external entity (XXE): abusing XML parsing to read files or contact other
  systems.
- JSON Web Token (JWT): a signed token used to prove who you are; attacks forge or
  bypass it.
- Insecure deserialization: turning attacker-controlled data back into program
  objects, which can lead to code execution.
- IDOR / BOLA (Insecure Direct Object Reference / Broken Object Level
  Authorization): accessing another user's data by changing an identifier.
- Prototype pollution: corrupting shared default properties of objects in
  JavaScript to change how a program behaves.
- GraphQL introspection: asking a GraphQL API to describe its own schema, which can
  reveal fields that should be hidden.

## Network and infrastructure terms

- Port: a numbered endpoint on a host where a particular service listens.
- Service: a program listening on a port (for example a web server or database).
- Pivoting: using a compromised host as a stepping stone to reach a network you
  could not reach directly.
- Active Directory (AD): Microsoft's directory service for managing users and
  computers in a Windows network; a frequent target in internal assessments.
- SMB: the Windows file- and printer-sharing protocol.
- SNMP: a protocol for monitoring devices; often left with a weak, guessable
  "community string" that leaks information.
- DNS zone transfer (AXFR): a DNS feature that, if misconfigured, hands over a full
  list of a domain's records.
- Open mail relay: a mail server that forwards mail for anyone, a classic
  misconfiguration.
- Buffer overflow: sending more data than a program expects, corrupting memory in a
  way that can lead to code execution.

## RedPlanet and Docker terms

- Range: one self-contained training environment made of several containers.
- Controller image: the small image you run to start a whole range on your host.
- Docker socket: the control channel for the Docker engine (`/var/run/docker.sock`);
  the controller image mounts it to start the range's containers.
- Attacker box: the Kali Linux container in the netsec range, pre-loaded with tools,
  that you attack from.
- Dashboard (Mission Control / portal): the web page at http://localhost:8000 that
  indexes every target, shows which environments are live, and gives each a launch
  button. It ships with every range.
- Scoreboard: the web page (http://localhost:8001) where you submit captured flags
  and track progress. It ships with the `labs` range only.
