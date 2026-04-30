# symphony-target-template

A ready-to-use template repository for [roll-your-own-symphony](https://github.com/smalldreamcollective/roll-your-own-symphony) — the Elixir daemon that watches your issue tracker and runs a coding agent for each issue.

## What this is

Symphony needs a target repository to watch — one that has a `WORKFLOW.md` (its configuration file) and the right GitHub labels in place. This template gives you both, ready to go.

## Quick start

**1. Use this template**

Click **Use this template** on GitHub, or clone it directly:

```bash
git clone https://github.com/smalldreamcollective/symphony-target-template.git my-project
cd my-project
```

**2. Create the labels**

```bash
chmod +x setup.sh
./setup.sh
```

This creates three labels in your repo:

| Label | Purpose |
|---|---|
| `ready` | Apply to an issue to queue it for Symphony |
| `done` | Applied by the agent when work is complete |
| `wontfix` | Applied when you cancel an agent from the dashboard |

**3. Configure WORKFLOW.md**

Edit `WORKFLOW.md` and fill in the `TODO` values:

- `tracker.repo` — your `owner/repo` (e.g. `acme/my-project`)
- `workspace.hooks.after_create` — update the clone URL to match
- `agent.model` — your preferred Ollama model (or switch `agent.kind` to `claude`)
- `workspace.root` — where Symphony creates per-issue workspaces

**4. Set your environment**

```bash
export GITHUB_TOKEN=your_personal_access_token
```

Your token needs **Issues** (read/write), **Pull requests** (read/write), and **Contents** (read/write) permissions on this repo.

**5. Start Symphony**

```bash
cd /path/to/roll-your-own-symphony/symphony
./start.sh --workflow /path/to/my-project/WORKFLOW.md --port 4000
```

**6. Queue an issue**

Create an issue in this repo and apply the `ready` label. Symphony will pick it up on the next poll (default: 30 seconds) and start working.

## Dashboard

Open [http://localhost:4000](http://localhost:4000) to watch agents run in real time. From the dashboard you can also cancel a running agent — it will be labelled `wontfix` and won't be re-dispatched until you manually mark it as active again.

## How issue state works

Symphony derives issue state from GitHub labels:

- Issue has `ready` label → eligible for dispatch
- Agent applies `done` label → Symphony treats it as terminal
- Issue is closed on GitHub → Symphony treats it as terminal
- User cancels from dashboard → `wontfix` applied, `ready` removed

## Further reading

- [roll-your-own-symphony](https://github.com/smalldreamcollective/roll-your-own-symphony) — the Symphony daemon
- [SPEC.md](https://github.com/smalldreamcollective/roll-your-own-symphony/blob/main/SPEC.md) — full specification
