# Design Specification: Antigravity Multi-Agent Team & SOP Template

- **Date**: 2026-09-26
- **Status**: Draft
- **Target Repository**: `https://github.com/TrangDuyNguyen/antigravity-agent-team-template`
- **Local Path**: `/Users/nguyenduytrang/antigravity-agent-team-template`

---

## 1. Executive Summary & Objective

AstroBite has developed an advanced, disciplined **8-Gate Multi Sub-Agent Software Delivery Lifecycle** orchestrated by specialized AI personas (PO, Tech Lead, BA, UI/UX Designer, PM, QA/QC Tester, Dev Team, and Code Reviewer) governed by the ruthless **Ponytail mindset** (YAGNI, minimal code, zero bloat).

The goal of this initiative is to decouple this multi-agent engine from AstroBite's domain specifics and package it into a standalone, universal **GitHub Template Repository** and **Scaffolding CLI Engine** (`antigravity-agent-team-template`). This template will allow the user to bootstrap the entire agent team and SOP into any existing or new project across multiple technology stacks: **Flutter**, **React Native**, **iOS Native**, **Android Native**, **Web Frontend (FE)**, and **Backend**.

---

## 2. Target Architecture & Repository Layout

The template repository is located at `/Users/nguyenduytrang/antigravity-agent-team-template` and structured as follows:

```
antigravity-agent-team-template/
├── README.md                          # Comprehensive documentation, GitHub template badge, quickstart
├── LICENSE                            # MIT License
├── setup.sh                           # Interactive / automated CLI setup engine
├── install.sh                         # Remote one-liner installer (curl -fsSL ... | bash)
└── template/
    ├── AGENTS.md.tpl                  # Modular AGENTS.md template with dynamic placeholders
    └── .agents/
        ├── mcp_config.json            # Base MCP configurations
        ├── rules/
        │   ├── code-reviewer.md       # Ponytail code review guidelines
        │   └── ponytail.md            # Immutable Ponytail laws (YAGNI, standard library first)
        └── skills/
            ├── _core/                 # Tech-agnostic 8-Gate SOP & Orchestration
            │   ├── feature-lifecycle/ # 8-Gate lifecycle master orchestrator
            │   ├── product-owner/     # Sub-Agent PO (The Strategic Tyrant - Tier S)
            │   ├── tech-lead/         # Sub-Agent Tech Lead & Architect (Tier S)
            │   ├── business-analyst/  # Sub-Agent BA (BDD & Specs - Tier S/2)
            │   ├── ui-ux-designer/    # Sub-Agent UI/UX Designer (4pt grid, 5 states - Tier 2)
            │   ├── project-manager/   # Sub-Agent PM (WBS, Fibonacci SP - Tier 3/S)
            │   ├── qa-tester/         # Sub-Agent QA/QC Tester (Zero Tolerance - Tier S)
            │   ├── code-reviewer/     # Sub-Agent Reviewer (Bloat Assassin - Tier 2)
            │   ├── brainstorming/     # Idea Exploration (Spike / Bounded / Architectural)
            │   ├── ponytail/          # Root ponytail skill
            │   ├── ponytail-audit/    # Whole-repo bloat auditor
            │   ├── ponytail-debt/     # Deferred shortcut tracker
            │   ├── ponytail-gain/     # Code reduction metric scoreboard
            │   ├── ponytail-help/     # Ponytail cheatsheet
            │   ├── ponytail-review/   # One-line complexity review
            │   └── bash-defensive-patterns/ # Robust shell scripting
            │
            └── _stacks/               # Specialized technology stack extensions
                ├── flutter/           # Flutter & Dart
                │   ├── flutter-core-dev/
                │   ├── flutter-native-dev/
                │   ├── cloud-ai-dev/
                │   ├── flutter-expert/
                │   ├── flutter-testing/
                │   ├── flutter-animations/
                │   ├── dart-best-practices/
                │   └── rules.md
                │
                ├── react-native/      # React Native & Expo
                │   ├── rn-core-dev/
                │   ├── rn-native-dev/
                │   ├── rn-testing/
                │   └── rules.md
                │
                ├── ios/               # iOS Native (Swift & SwiftUI)
                │   ├── ios-core-dev/
                │   ├── ios-system-dev/
                │   ├── ios-testing/
                │   └── rules.md
                │
                ├── android/           # Android Native (Kotlin & Jetpack Compose)
                │   ├── android-core-dev/
                │   ├── android-system-dev/
                │   ├── android-testing/
                │   └── rules.md
                │
                ├── frontend/          # Web Frontend (React, Next.js, Vue, TypeScript)
                │   ├── web-core-dev/
                │   ├── web-ui-dev/
                │   ├── web-testing/
                │   └── rules.md
                │
                └── backend/           # Backend (Node.js, Go, Python, Cloud API, DB)
                    ├── backend-core-dev/
                    ├── backend-data-dev/
                    ├── backend-testing/
                    └── rules.md
```

---

## 3. Core Sub-Agents & Personas (Domain-Agnostic)

All core skills in `_core/` are sanitized to eliminate AstroBite-specific domain coupling while maintaining full operational rigor:

1. **Sub-Agent PO (`product-owner`)**:
   - Focus: Product Vision, OKRs, MoSCoW prioritization, Gate 1 sign-off, Gate 7 commercial release.
   - Persona: "The Strategic Tyrant". Ruthless against feature bloat.
2. **Sub-Agent Tech Lead (`tech-lead`)**:
   - Focus: Gate 0 Brainstorming & Spikes, Architecture Decision Records (ADR), technical feasibility sign-off (Gate 1 & 2), SLAs, CI/CD pipeline supervision, Technical Release Clearance (Gate 7).
   - Persona: "The Pragmatic System Architect".
3. **Sub-Agent BA (`business-analyst`)**:
   - Focus: PRD authoring, BDD User Stories (`Given-When-Then`), Acceptance Criteria, Data Dictionary.
   - Persona: "The Pedantic Logician". Zero tolerance for ambiguity.
4. **Sub-Agent UI/UX Designer (`ui-ux-designer`)**:
   - Focus: User flows (Mermaid), responsive layout blueprints, 4pt/8pt spacing system, mandatory 5 UI states (Default, Shimmer/Loading, Empty, Error, Offline). Integration with Google Stitch MCP.
   - Persona: "The Aesthetic Purist".
5. **Sub-Agent PM (`project-manager`)**:
   - Focus: Sprint backlog planning, Work Breakdown Structure (WBS) mapped across the 8 Gates, Fibonacci Story Points (1, 2, 3, 5, 8), Risk & Blocker tracking.
   - Persona: "The Clockwork Disciplinarian".
6. **Sub-Agent QA/QC Tester (`qa-tester`)**:
   - Focus: Gate 3 test design (EP, BVA, Gherkin `.feature`), Gate 6 verification & release sign-off.
   - Persona: "The Paranoid Inquisitor". ZERO DU DI. 100% genuine pass rate, memory leak verification, latency and frame rate checks.
7. **Sub-Agent Reviewer (`code-reviewer`)**:
   - Focus: Gate 5 Ponytail diff review. Single-line action format `<file>:L<line>: <tag> <what>. <replacement>.`
   - Persona: "The Ruthless Bloat Assassin".
8. **Ponytail Philosophy (`ponytail*`)**:
   - The universal engineering principle: YAGNI first, stdlib before custom code, shortest working diff, deletion over addition.

---

## 4. Stack Extension Specifications

Each stack in `_stacks/<name>` contains specialized Gate 4 Dev sub-agents and a `rules.md` file that injects stack-specific architectural constraints into `AGENTS.md`:

1. **Flutter**:
   - Framework: Flutter 3.x, Dart 3.x, Riverpod 2.x, AutoRoute, Freezed.
   - Sub-agents: `flutter-core-dev`, `flutter-native-dev`, `cloud-ai-dev`, `flutter-testing`, `flutter-animations`, `dart-best-practices`.
2. **React Native**:
   - Framework: React Native / Expo, TypeScript strict, Zustand / TanStack Query, Reanimated.
   - Sub-agents: `rn-core-dev`, `rn-native-dev`, `rn-testing`.
3. **iOS Native**:
   - Framework: Swift, SwiftUI, UIKit interoperability, SwiftData / CoreData, async/await, Instruments.
   - Sub-agents: `ios-core-dev`, `ios-system-dev`, `ios-testing`.
4. **Android Native**:
   - Framework: Kotlin, Jetpack Compose, Coroutines / Flow, Room, Clean Architecture / MVI.
   - Sub-agents: `android-core-dev`, `android-system-dev`, `android-testing`.
5. **Web Frontend**:
   - Framework: React / Next.js / Vue, TypeScript, TailwindCSS / CSS Modules, Web Vitals, Playwright.
   - Sub-agents: `web-core-dev`, `web-ui-dev`, `web-testing`.
6. **Backend**:
   - Framework: Node.js / Go / Python, REST, GraphQL, gRPC, PostgreSQL / MongoDB, Redis, Docker, k6.
   - Sub-agents: `backend-core-dev`, `backend-data-dev`, `backend-testing`.

---

## 5. Scaffolding Engine (`setup.sh`) & Installer (`install.sh`)

### `setup.sh` Workflow
1. **Interactive Prompt**:
   - Prompts for Project Name and Description.
   - Displays selectable checkbox/numbered menu of available Stacks (allows multiple selections for hybrid apps, e.g., `flutter` + `backend`).
2. **Target Workspace Discovery**:
   - Detects target directory (defaults to current working directory).
   - Verifies git initialization.
3. **Skill & Rule Injection**:
   - Copies `template/.agents/skills/_core/*` into `<target>/.agents/skills/`.
   - Copies selected `template/.agents/skills/_stacks/<stack>/*` into `<target>/.agents/skills/`.
   - Copies `template/.agents/rules/` and `template/.agents/mcp_config.json`.
4. **Dynamic `AGENTS.md` Synthesis**:
   - Reads `template/AGENTS.md.tpl`.
   - Replaces `{{PROJECT_NAME}}`, `{{PROJECT_TYPE}}`.
   - Concatenates rules from each selected stack's `rules.md` into `{{STACK_ARCHITECTURE_RULES}}` and `{{STACK_TECH_SPEC}}`.
   - Writes generated `AGENTS.md` to `<target>/AGENTS.md`.
5. **Validation & Summary**:
   - Checks that all placeholders are resolved.
   - Prints activation status and next steps for Antigravity IDE.

---

## 6. GitHub Integration & Release Plan

1. **Local Repository Setup**:
   - Initialize git repo in `/Users/nguyenduytrang/antigravity-agent-team-template`.
   - Configure `.gitignore`, `README.md`, `LICENSE`.
2. **GitHub Publication**:
   - Execute `gh repo create TrangDuyNguyen/antigravity-agent-team-template --public --source=. --remote=origin --push --description "Universal 8-Gate Multi Sub-Agent SOP & Ponytail Template for Antigravity IDE"`.
   - Enable GitHub **"Template Repository"** setting via `gh api -X PATCH /repos/TrangDuyNguyen/antigravity-agent-team-template -f is_template=true`.

---

## 7. Verification & Acceptance Criteria

- [ ] Complete file tree generated at `/Users/nguyenduytrang/antigravity-agent-team-template`.
- [ ] Core skills sanitized of AstroBite-specific domain logic.
- [ ] 6 stacks created with respective dev agents and `rules.md`.
- [ ] `setup.sh` runs successfully in dry-run/test mode with 0 errors.
- [ ] Git repository committed and pushed to `TrangDuyNguyen/antigravity-agent-team-template` on GitHub.
- [ ] GitHub repository verified as public template repository.
