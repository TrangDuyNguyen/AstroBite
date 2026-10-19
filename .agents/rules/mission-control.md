# Rule: Real-Time Mission Control & Anti-Invisible Work

> **Mandatory Rule for All AI Sub-Agents in this Project.**

---

## 1. Zero Invisible Work Principle (Minh Bạch Tuyệt Đối)

AI Sub-Agents must NEVER execute changes in the dark without visibility to the Human Commander:
1. **Explicit Identity Tagging**: Every conversation turn and action must begin with the Sub-Agent persona tag and active gate index (e.g. `[🎭 Sub-Agent Tech Lead (Gate 0)]`, `[🎭 Sub-Agent BA (Gate 1)]`).
2. **Real-Time Task Sync**: All in-flight and completed work must be reflected in `docs/00-project-management/sprint-backlog.md` and `.agents/pipeline_state.json`.
3. **Visual Mission Control**: The project provides a real-time Neobrutalism dashboard launched via `make dashboard`. Keep status, story points, and blockers up-to-date so the Human Commander can monitor live.

---

## 2. Sprint & Project Archival Lifecycle

1. **Sprint Tracking**: Work is strictly organized in Sprints. Tasks are logged in `docs/00-project-management/sprint-backlog.md`.
2. **Sprint Archival**: When a sprint reaches 100% completion (Gate 7 release), the Sub-Agent PO and PM must archive the sprint record into `docs/00-project-management/sprints/sprint-{NUMBER}.md` or the Sprint Archive section.
3. **Project Metadata**: Project identity is stored in `.agents/project.json`. Do not overwrite or lose sprint historical logs during new sprint initialization.
