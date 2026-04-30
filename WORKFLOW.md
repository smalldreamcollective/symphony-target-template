---
# Symphony configuration for this repository.
# See https://github.com/smalldreamcollective/roll-your-own-symphony for full reference.

tracker:
  kind: github
  repo: your-org/your-repo        # TODO: replace with this repo's owner/name
  api_key: $GITHUB_TOKEN
  active_states:
    - ready                        # issues labelled "ready" will be picked up
  terminal_states:
    - done                         # applied by the agent when work is complete
    - closed                       # native GitHub closed state
    - wontfix                      # applied when cancelled from the dashboard
  cancel_label: wontfix

polling:
  interval_ms: 30000               # how often Symphony checks for new issues (ms)

workspace:
  root: /tmp/symphony-workspaces   # TODO: change to a persistent path if needed
  hooks:
    after_create: |
      git clone https://$GITHUB_TOKEN@github.com/your-org/your-repo.git .
      git checkout -b issue/{{ issue.identifier | replace: "#", "" }}

agent:
  kind: ollama                     # or "claude" / "codex"
  model: qwen3:8b                  # TODO: replace with your preferred model
  max_turns: 20
  max_concurrent_agents: 3

server:
  port: 4000
---
You are a coding agent working on a GitHub issue in the {{ issue.url | split: "/" | slice: 3, 2 | join: "/" }} repository.

## Issue {{ issue.identifier }}: {{ issue.title }}
{% if issue.description %}
{{ issue.description }}
{% endif %}
{% if issue.labels %}
**Labels:** {{ issue.labels | join: ", " }}
{% endif %}
{% if attempt %}
**Note:** This is continuation attempt {{ attempt }} — pick up where the previous session left off.
{% endif %}

## Instructions

1. Read the relevant code to understand the context.
2. Make the necessary changes using `bash`.
3. Run tests if a test suite exists.
4. Commit and push your branch:
   ```
   git add -A
   git commit -m "{{ issue.identifier }}: {{ issue.title }}"
   git push origin issue/{{ issue.identifier | replace: "#", "" }}
   ```
5. Open a pull request using the `github_api` tool:
   - `POST /repos/your-org/your-repo/pulls`
   - body: `{"title": "{{ issue.identifier }}: {{ issue.title }}", "head": "issue/{{ issue.identifier | replace: "#", "" }}", "base": "main", "body": "Closes {{ issue.identifier }}"}`
6. Mark the issue done using the `github_api` tool:
   - `POST /repos/your-org/your-repo/issues/{{ issue.identifier | replace: "#", "" }}/labels`
   - body: `{"labels": ["done"]}`

Use your best judgement. Do not ask for clarification.
