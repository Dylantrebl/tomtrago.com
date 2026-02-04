# Agent windows — one window per agent

Open **one file per Cursor window** so you can see and check each agent’s work. Run in the order below; do not run two agents that edit the same files at the same time.

| Order | Window | File | Role |
|-------|--------|------|------|
| 1 | Window 1 | [01_UPGRADE_AGENT.md](01_UPGRADE_AGENT.md) | Gemfile, bundle, rails app:update (Stages 1–3) |
| 2 | Window 2 | [02_CONFIG_AGENT.md](02_CONFIG_AGENT.md) | production.rb, cable.yml (after Stage 3) |
| 3 | Window 3 | [03_DEPLOY_AGENT.md](03_DEPLOY_AGENT.md) | Heroku stack, buildpacks, deploy, migrate |
| 4 | Window 4 | [04_QA_AGENT.md](04_QA_AGENT.md) | Local + production smoke tests (read-only) |

**Contract (file ownership and risks):** [../PARALLEL_DEV_CONTRACT.md](../PARALLEL_DEV_CONTRACT.md)
