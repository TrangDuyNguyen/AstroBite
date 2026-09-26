# Implementation Plan: Antigravity Multi-Agent Team & SOP Template

- **Date**: 2026-09-26
- **Spec Reference**: `docs/superpowers/specs/2026-09-26-antigravity-agent-team-template-design.md`
- **Target Repo**: `/Users/nguyenduytrang/antigravity-agent-team-template` -> `github.com/TrangDuyNguyen/antigravity-agent-team-template`

---

## Task Breakdown

### Phase 1: Directory Setup & Agnostic Core Skills
- [ ] Create `/Users/nguyenduytrang/antigravity-agent-team-template` and template hierarchy.
- [ ] Export & sanitize 8-Gate Agnostic Core skills to `template/.agents/skills/_core/`:
  - `feature-lifecycle`
  - `product-owner`
  - `tech-lead`
  - `business-analyst`
  - `ui-ux-designer`
  - `project-manager`
  - `qa-tester`
  - `code-reviewer`
  - `brainstorming`
  - `ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, `ponytail-review`
  - `bash-defensive-patterns`
- [ ] Copy base rules: `code-reviewer.md`, `ponytail.md` to `template/.agents/rules/`.
- [ ] Copy `mcp_config.json` to `template/.agents/mcp_config.json`.

### Phase 2: Tech Stacks Modules
- [ ] `_stacks/flutter`: Core Dev, Native Dev, Cloud AI Dev, Testing, Animations, Dart Best Practices + `rules.md`.
- [ ] `_stacks/react-native`: Standard React Native CLI (No Expo), Core Dev, Native Dev (TurboModules), Testing (Jest/Maestro) + `rules.md`.
- [ ] `_stacks/ios`: Core Dev (SwiftUI/UIKit), System Dev (SwiftData/WidgetKit), Testing (XCTest) + `rules.md`.
- [ ] `_stacks/android`: Core Dev (Compose/Kotlin), System Dev (Room/WorkManager/NDK), Testing (JUnit5/Compose) + `rules.md`.
- [ ] `_stacks/frontend`: Web Core Dev (React/Next/Vue), Web UI Dev (Tailwind/CSS), Web Testing (Playwright) + `rules.md`.
- [ ] `_stacks/backend`: Backend Core Dev (Node/Go/Python), Data Dev (PostgreSQL/Redis), Contract Testing (k6) + `rules.md`.

### Phase 3: Scaffolding Engine & Documentation
- [ ] Create `template/AGENTS.md.tpl` with dynamic placeholders.
- [ ] Build `setup.sh`: Interactive CLI with stack selection, target verification, file copying, template interpolation, and dry-run mode.
- [ ] Build `install.sh`: One-liner curl downloader and bootstrapper.
- [ ] Build `README.md`: Badges, Mermaid architecture diagram, usage guide (GitHub template button & CLI), MIT LICENSE.

### Phase 4: Verification & GitHub Release
- [ ] Run dry-run verification with `setup.sh` in a test directory to validate generated `.agents/` and `AGENTS.md`.
- [ ] Initialize git repo in `/Users/nguyenduytrang/antigravity-agent-team-template`.
- [ ] Create remote repo `TrangDuyNguyen/antigravity-agent-team-template` on GitHub via `gh repo create`.
- [ ] Push commit to GitHub `main` branch.
- [ ] Mark repository as GitHub Template (`is_template=true`).
