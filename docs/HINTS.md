# Lab Hints

These are nudges, not solutions. Each lab page also shows its own objective and a
hint. Try on your own first; read Hint 1, attempt again, and only then read Hint 2.
No flags or ready-made payloads are given here on purpose - working out the exact
input is the point. If a term is new, check GLOSSARY.md and CONCEPTS.md.

Ports are on http://localhost. See the portal (http://localhost:8000) for links.

---

## phobos-sqli - SQL injection (:5001)
- Hint 1: The login and the cargo search both build a database query by pasting
  your text straight into it. What character begins and ends a text value in SQL?
- Hint 2: For the login, end the username value early and turn the rest of the
  query (the password check) into a comment. For the search, notice it returns two
  columns - a query can be combined with another that also returns two columns.

## deimos-xss - Cross-site scripting (:5002)
- Hint 1: Whatever you put in the greeting field and the message board is shown
  back unchanged. What if your text were not text, but markup?
- Hint 2: If a script tag you submit actually runs in the page, you have proven it.
  Try both the reflected greeting and the stored board.

## ares-cmdi - OS command injection (:5003)
- Hint 1: The diagnostics tool runs a system command that includes the host you
  type. Shells let you put more than one command on a line.
- Hint 2: Separators and substitutions (think `;`, `|`, `$( )`) let you append or
  embed a second command. The objective points at a file to read.

## valles-traversal - Path traversal (:5004)
- Hint 1: The viewer opens whatever file name you give it, relative to a folder.
  What does `../` mean in a file path?
- Hint 2: Climb up enough folders to leave the app's directory and reach a
  well-known file elsewhere on the system.

## olympus-ssrf - Server-side request forgery (:5005)
- Hint 1: The tool fetches any URL you give it, but the fetch happens on the
  server, not in your browser. What can the server reach that you cannot?
- Hint 2: The page describes an internal-only address. Point the fetcher at it.

## curiosity-ssti - Template injection (:5006)
- Hint 1: Your input is dropped into a server-side page template. Try a simple
  arithmetic expression written in template syntax.
- Hint 2: If your expression is calculated instead of shown literally, the engine
  is executing your input. Explore what the template can reach from there.

## viking-xxe - XML external entity (:5007)
- Hint 1: This endpoint parses XML that you send. XML documents can declare
  "entities", including ones that load external content.
- Hint 2: Declare a document type with an external entity that points at a local
  file, then reference that entity in the body.

## perseverance-jwt - JWT / broken auth (:5008)
- Hint 1: After logging in you receive a token. It is encoded, not encrypted -
  decode it and read what role it claims.
- Hint 2: The token is signed with a very weak secret. Recover the secret, then
  create a token that claims a higher-privilege role and sign it the same way.

## cydonia-deserialize - Insecure deserialization (:5009)
- Hint 1: Your preferences travel as an encoded, serialized object that the server
  turns back into a live object.
- Hint 2: A carefully crafted serialized object can run code when it is loaded. The
  objective is to read a file on the server.

## tharsis-graphql - GraphQL abuse (:5010)
- Hint 1: GraphQL APIs can describe themselves. Ask the schema what types and
  fields exist.
- Hint 2: One field holds a secret and is simply not requested by the normal
  queries - but nothing stops you from asking for it.

## elysium-idor - IDOR / BOLA (:5011)
- Hint 1: You are shown your own record, addressed by an id number. What happens if
  you change that number?
- Hint 2: Nothing checks that a record belongs to you. Find the overseer's record.

## noctis-proto - Prototype pollution (:5012)
- Hint 1: The settings endpoint merges the JSON you send into a configuration
  object, following every key you provide.
- Hint 2: In JavaScript, special keys can change the default properties shared by
  all objects. Use that to make an administrator check pass.

## arcadia-gauntlet - Chained multi-vulnerability CTF (:5013)
- Hint 1: This target has stages. Begin with reconnaissance: what does the site
  quietly disclose (look where crawlers are told not to go)?
- Hint 2: Each stage feeds the next. Recon reveals a range of ids; browsing those
  ids (an access-control flaw) yields a code; that code plus an injection opens the
  final vault.
