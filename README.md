# Autodo agents

Signed catalog of external agents for Autodod.

- `catalog.json` is the index read by the Autodod daemon and the app.
- Agents live directly under this repository: `developer/`, and future agents
  alongside it. There are no version folders and no `plugins/` directory.
- Agent versions are metadata in `agent.toml` and `catalog.json`; release
  artifacts are GitHub assets.
- Every release is signed with cosign; the public key is in `keys/cosign.pub`.
- Autodod verifies the catalog signature and the artifact SHA256 before
  installing an agent.

## Agent layout

```text
developer/
  agent.toml
  main.rhai
  prompt.md
  tools.toml
  checks.toml
```

The `developer` agent runs on the Rhai runtime inside bubblewrap. It declares
the model, tools and checks in its manifest, and implements its behavior in
`main.rhai`. The host exposes only the declared capabilities.
