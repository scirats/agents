# Autodo agent catalog

Signed catalog of declarative agent plugins for Autodod.

- `catalog.json` is the index read by the Autodo app.
- Plugin artifacts are released as GitHub assets.
- Every release is signed with cosign; the public key is in `keys/cosign.pub`.
- The Autodod server verifies signatures and SHA256 before installing.

The first plugin is `developer` (manifest + prompt + tools + checks). It is declarative: the host runner executes the agent loop; the plugin does not run arbitrary code.
