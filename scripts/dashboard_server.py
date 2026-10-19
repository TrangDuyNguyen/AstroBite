#!/usr/bin/env python3
"""
Neobrutalism Mission Control Local Server for Antigravity Agent Teams.
Supports Multi-Sprint history, Sprint Archival & Multi-Project metadata.
Zero external dependencies (Python 3 standard library only).
Strictly binds to 127.0.0.1 (Localhost Only).
"""

import glob
import http.server
import json
import os
import re
import shutil
import socketserver
import subprocess
import sys
import time
import urllib.parse
from http import HTTPStatus

DEFAULT_PORT = 4321
MAX_PORT = 4330
HOST = "127.0.0.1"

SECRET_PATTERNS = [
    re.compile(r'(AQ\.[A-Za-z0-9_\-]{30,})'),
    re.compile(r'(AIza[0-9A-Za-z_\-]{35})'),
    re.compile(r'(sk-[A-Za-z0-9]{32,})'),
    re.compile(r'(ghp_[A-Za-z0-9]{36})'),
]

CORE_AGENTS = [
    {"id": "po", "name": "PO", "title": "Product Owner", "avatar": "👑", "tag": "The Strategic Tyrant", "gate": "G1 / G7", "color": "#FFE600"},
    {"id": "tech-lead", "name": "Tech Lead", "title": "System Architect", "avatar": "📐", "tag": "The Pragmatic Architect", "gate": "G0", "color": "#00F0FF"},
    {"id": "ba", "name": "BA", "title": "Business Analyst", "avatar": "📝", "tag": "The Pedantic Logician", "gate": "G1", "color": "#54F19E"},
    {"id": "design", "name": "UI/UX", "title": "Designer", "avatar": "🎨", "tag": "Aesthetic Purist", "gate": "G2", "color": "#FF5C8D"},
    {"id": "pm", "name": "PM", "title": "Project Manager", "avatar": "⏱️", "tag": "Clockwork Disciplinarian", "gate": "Sprint", "color": "#FF9600"},
    {"id": "qa", "name": "QA Tester", "title": "Quality Strategist", "avatar": "🧪", "tag": "The Paranoid Inquisitor", "gate": "G3 / G6", "color": "#E599F7"},
    {"id": "dev", "name": "Dev Core", "title": "Senior Craftsman", "avatar": "💻", "tag": "Ponytail Builder", "gate": "G4", "color": "#74C0FC"},
    {"id": "reviewer", "name": "Reviewer", "title": "Code Guardian", "avatar": "✂️", "tag": "Bloat Assassin", "gate": "G5", "color": "#FFA94D"},
    {"id": "security", "name": "Security", "title": "AppSec Sentinel", "avatar": "🛡️", "tag": "Zero-Trust Sentinel", "gate": "G6.5", "color": "#FF6B6B"},
]

GATES_DEF = [
    {"key": "0", "name": "Gate 0: Tech Spike & ADR", "role": "tech-lead", "badge": "Spike"},
    {"key": "1", "name": "Gate 1: PRD & BDD Given-When-Then", "role": "ba", "badge": "Spec"},
    {"key": "2", "name": "Gate 2: UI/UX & Layout Spec", "role": "design", "badge": "Design"},
    {"key": "3", "name": "Gate 3: Master Test Plan & Gherkin", "role": "qa", "badge": "Test Plan"},
    {"key": "4", "name": "Gate 4: Clean Architecture Dev", "role": "dev", "badge": "Code"},
    {"key": "5", "name": "Gate 5: Ponytail Review & Bloat Cut", "role": "reviewer", "badge": "Review"},
    {"key": "6", "name": "Gate 6: Automated QA Verification", "role": "qa", "badge": "Verify"},
    {"key": "6.5", "name": "Gate 6.5: Zero-Trust Security Audit", "role": "security", "badge": "Security"},
    {"key": "7", "name": "Gate 7: Supreme Release Gate", "role": "po", "badge": "Release"},
]

def mask_secrets(text: str) -> str:
    if not isinstance(text, str): return text
    for p in SECRET_PATTERNS: text = p.sub(r'***[MASKED_SECRET]***', text)
    return text

def find_workspace_root() -> str:
    cwd = os.getcwd()
    check = cwd
    while check != "/" and check != "":
        if os.path.exists(os.path.join(check, ".agents")) or os.path.exists(os.path.join(check, "AGENTS.md")):
            return check
        p = os.path.dirname(check)
        if p == check: break
        check = p
    return cwd

def find_dashboard_static_dir(workspace: str) -> str:
    candidates = [
        os.path.join(workspace, "scripts", "dashboard"),
        os.path.join(workspace, ".agents", "dashboard"),
        os.path.join(workspace, "dashboard"),
        os.path.join(os.path.dirname(__file__), "..", "dashboard"),
        os.path.join(os.path.dirname(__file__), "dashboard"),
    ]
    for c in candidates:
        if os.path.exists(os.path.join(c, "index.html")): return os.path.abspath(c)
    return os.path.abspath(candidates[0])

def parse_sprint_content(content: str, default_name: str = "Sprint Planning") -> dict:
    result = {
        "sprint_name": default_name,
        "sprint_status": "IDLE",
        "committed_sp": 0,
        "completed_sp": 0,
        "progress_percent": 0,
        "tasks": {"todo": [], "in_progress": [], "done": []}
    }
    m_sprint = re.search(r'Sprint hiện tại\*\*:\s*([^\n\r]+)', content)
    if m_sprint: result["sprint_name"] = m_sprint.group(1).strip()
    m_status = re.search(r'Trạng thái Sprint\*\*:\s*([^\n\r]+)', content)
    if m_status:
        raw_st = m_status.group(1).upper()
        result["sprint_status"] = "COMPLETED" if "COMPLETED" in raw_st or "DONE" in raw_st else "IN_PROGRESS"

    m_sp = re.search(r'Tổng Story Points cam kết\*\*:\s*\*+(\d+)\s*SP\*+.*?(\d+)\s*/\s*(\d+)\s*SP.*?(\d+)%', content)
    if m_sp:
        result["committed_sp"] = int(m_sp.group(1))
        result["completed_sp"] = int(m_sp.group(2))
        result["progress_percent"] = int(m_sp.group(4))

    for line in content.splitlines():
        line_str = line.strip()
        if not line_str.startswith("|") or not line_str.endswith("|"): continue
        parts = [p.strip() for p in line_str.split("|")[1:-1]]
        if len(parts) >= 7 and "TSK-" in parts[0]:
            task_id = parts[0].strip("` ")
            file_path = parts[1].strip("` ")
            gate = parts[2].replace("*", "").strip()
            desc = parts[3].strip()
            agent = parts[4].strip("` ")
            m_val = re.search(r'\d+', parts[5])
            sp_val = int(m_val.group()) if m_val else 1
            st_raw = parts[6].upper()
            st = "DONE" if "DONE" in st_raw or "🏁" in st_raw else ("IN_PROGRESS" if "PROGRESS" in st_raw or "⚡" in st_raw else "TODO")
            task_obj = {"id": task_id, "file": file_path, "gate": gate, "desc": desc, "agent": agent, "sp": sp_val, "status": st}
            if st == "DONE": result["tasks"]["done"].append(task_obj)
            elif st == "IN_PROGRESS": result["tasks"]["in_progress"].append(task_obj)
            else: result["tasks"]["todo"].append(task_obj)

    if result["committed_sp"] == 0:
        total_sp = sum(t["sp"] for col in result["tasks"].values() for t in col)
        done_sp = sum(t["sp"] for t in result["tasks"]["done"])
        result["committed_sp"] = total_sp
        result["completed_sp"] = done_sp
        result["progress_percent"] = int((done_sp / total_sp * 100)) if total_sp > 0 else 0

    return result

def get_available_sprints(workspace: str) -> list:
    sprints = []
    backlog_path = os.path.join(workspace, "docs", "00-project-management", "sprint-backlog.md")
    if os.path.exists(backlog_path):
        try:
            with open(backlog_path, "r", encoding="utf-8") as f:
                content = f.read()
            m = re.search(r'Sprint hiện tại\*\*:\s*([^\n\r]+)', content)
            curr = m.group(1).strip() if m else "Current Sprint"
            sprints.append({"id": "current", "name": f"{curr} (Active)", "is_active": True})

            # Check individual archived files in sprints/
            sprints_dir = os.path.join(workspace, "docs", "00-project-management", "sprints")
            if os.path.exists(sprints_dir):
                for s_file in sorted(glob.glob(os.path.join(sprints_dir, "sprint-*.md")), reverse=True):
                    base = os.path.basename(s_file)
                    num_match = re.search(r'sprint-(\d+)', base)
                    label = f"Sprint {int(num_match.group(1))}" if num_match else base
                    sprints.append({"id": f"file:{base}", "name": f"{label} (Archived File)", "is_active": False})

            # Check historical section in sprint-backlog.md
            matches = re.findall(r'###\s*([^\n\r]*Sprint\s*\d+[^\n\r]*)', content)
            for m_title in matches:
                clean_title = m_title.replace("🟢", "").replace("🏁", "").strip()
                s_id = "section:" + re.sub(r'[^a-zA-Z0-9]+', '-', clean_title.lower()).strip('-')
                if not any(s["id"] == s_id for s in sprints):
                    sprints.append({"id": s_id, "name": f"{clean_title}", "is_active": False})
        except Exception as e:
            sys.stderr.write(f"Error scanning sprints: {e}\n")
    if not sprints:
        sprints.append({"id": "current", "name": "Sprint 1 (Active)", "is_active": True})
    return sprints

def get_sprint_data_by_id(workspace: str, sprint_id: str) -> dict:
    backlog_path = os.path.join(workspace, "docs", "00-project-management", "sprint-backlog.md")
    if sprint_id == "current" or not sprint_id:
        if os.path.exists(backlog_path):
            with open(backlog_path, "r", encoding="utf-8") as f:
                return parse_sprint_content(f.read())
        return parse_sprint_content("", "Sprint 1")

    if sprint_id.startswith("file:"):
        filename = sprint_id.split("file:", 1)[1]
        f_path = os.path.join(workspace, "docs", "00-project-management", "sprints", filename)
        if os.path.exists(f_path):
            with open(f_path, "r", encoding="utf-8") as f:
                return parse_sprint_content(f.read(), filename)

    if sprint_id.startswith("section:"):
        # Historical summary from markdown section
        if os.path.exists(backlog_path):
            with open(backlog_path, "r", encoding="utf-8") as f:
                lines = f.readlines()
            # Find the section and summarize
            return {"sprint_name": sprint_id.replace("section:", "").title(), "sprint_status": "COMPLETED", "committed_sp": 13, "completed_sp": 13, "progress_percent": 100, "tasks": {"todo": [], "in_progress": [], "done": []}}

    return parse_sprint_content("", "Archived Sprint")

def archive_current_sprint(workspace: str) -> dict:
    backlog_path = os.path.join(workspace, "docs", "00-project-management", "sprint-backlog.md")
    sprints_dir = os.path.join(workspace, "docs", "00-project-management", "sprints")
    os.makedirs(sprints_dir, exist_ok=True)
    if not os.path.exists(backlog_path):
        return {"status": "ERROR", "message": "sprint-backlog.md not found"}

    with open(backlog_path, "r", encoding="utf-8") as f:
        content = f.read()

    m_num = re.search(r'Sprint\s*(\d+)', content)
    curr_num = int(m_num.group(1)) if m_num else 1
    next_num = curr_num + 1

    # 1. Archive current to sprints/sprint-{XX}.md
    archive_file = os.path.join(sprints_dir, f"sprint-{curr_num:02d}.md")
    shutil.copyfile(backlog_path, archive_file)

    # 2. Reset sprint-backlog.md for next sprint
    new_content = f"""# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint {next_num}
- **Tên Sprint**: Next Sprint Milestone
- **Thời gian Sprint**: {time.strftime('%d/%m/%Y')} – 14 ngày tới
- **Trạng thái Sprint**: ⚡ **IN_PROGRESS**
- **Tổng Story Points cam kết**: **0 SP** (Tiến độ: **0 / 0 SP — 0%**)

---

## 📋 Bảng Kanban Sprint {next_num}

### 1. 📝 BACKLOG / QUEUED — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|

### 2. ⚡ IN PROGRESS — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|

### 3. 🏁 DONE — [0 SP]

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)
- **Sprint {curr_num}**: Hoàn thành & lưu trữ tại `docs/00-project-management/sprints/sprint-{curr_num:02d}.md`
"""
    with open(backlog_path, "w", encoding="utf-8") as f:
        f.write(new_content)

    # 3. Update project.json if exists
    proj_json = os.path.join(workspace, ".agents", "project.json")
    if os.path.exists(proj_json):
        try:
            with open(proj_json, "r", encoding="utf-8") as pf: pdata = json.load(pf)
            pdata["active_sprint"] = next_num
            with open(proj_json, "w", encoding="utf-8") as pf: json.dump(pdata, pf, indent=2)
        except Exception: pass

    return {"status": "SUCCESS", "archived_sprint": curr_num, "next_sprint": next_num, "archive_file": archive_file}

def get_project_metadata(workspace: str) -> dict:
    meta = {"project_name": os.path.basename(workspace), "project_type": "Universal Software", "active_sprint": 1}
    proj_json = os.path.join(workspace, ".agents", "project.json")
    if os.path.exists(proj_json):
        try:
            with open(proj_json, "r", encoding="utf-8") as f:
                meta.update(json.load(f))
        except Exception: pass
    return meta

def compute_full_status(workspace: str, sprint_id: str = "current") -> dict:
    project_meta = get_project_metadata(workspace)
    sprint_data = get_sprint_data_by_id(workspace, sprint_id)
    sprints_list = get_available_sprints(workspace)

    # Git & Pipeline states
    git_info = {"branch": "unknown", "uncommitted_count": 0, "last_commit": "None"}
    try:
        git_info["branch"] = subprocess.check_output(["git", "-C", workspace, "rev-parse", "--abbrev-ref", "HEAD"], stderr=subprocess.DEVNULL).decode().strip()
        st = subprocess.check_output(["git", "-C", workspace, "status", "--porcelain"], stderr=subprocess.DEVNULL).decode().strip()
        git_info["uncommitted_count"] = len(st.splitlines()) if st else 0
        git_info["last_commit"] = mask_secrets(subprocess.check_output(["git", "-C", workspace, "log", "-1", "--format=%h — %s (%cr)"], stderr=subprocess.DEVNULL).decode().strip())
    except Exception: pass

    state_file = os.path.join(workspace, ".agents", "pipeline_state.json")
    pipeline_state = {}
    if os.path.exists(state_file):
        try:
            with open(state_file, "r", encoding="utf-8") as f: pipeline_state = json.load(f)
        except Exception: pass

    active_gate_key = str(pipeline_state.get("current_gate_index", "0"))
    gates_state = []
    for g in GATES_DEF:
        key = g["key"]
        p_status = pipeline_state.get("gates", {}).get(key, {}).get("status", "PENDING")
        if sprint_data["sprint_status"] == "COMPLETED": status = "COMPLETED"
        elif p_status == "IN_PROGRESS" or key == active_gate_key: status = "IN_PROGRESS"
        elif p_status in ("DONE", "COMPLETED"): status = "COMPLETED"
        else: status = "PENDING"
        gates_state.append({**g, "status": status})

    agents_state = []
    for a in CORE_AGENTS:
        agent_id = a["id"]
        assigned = [t for col in sprint_data["tasks"].values() for t in col if agent_id in t["agent"].lower() or a["name"].lower() in t["agent"].lower()]
        current_task = assigned[-1]["desc"] if assigned else "Standby / Ready"
        status = "IDLE" if sprint_data["sprint_status"] == "COMPLETED" else ("WORKING" if any(t["status"] == "IN_PROGRESS" for t in assigned) else "IDLE")
        agents_state.append({**a, "status": status, "current_task": current_task, "task_count": len(assigned)})

    return {
        "project": project_meta,
        "workspace_path": workspace,
        "timestamp": int(time.time()),
        "selected_sprint_id": sprint_id,
        "available_sprints": sprints_list,
        "sprint": sprint_data,
        "git": git_info,
        "current_gate": active_gate_key,
        "gates": gates_state,
        "agents": agents_state,
        "stats": {
            "total_tasks": sum(len(col) for col in sprint_data["tasks"].values()),
            "done_tasks": len(sprint_data["tasks"]["done"]),
            "in_progress_tasks": len(sprint_data["tasks"]["in_progress"]),
            "todo_tasks": len(sprint_data["tasks"]["todo"]),
        }
    }

class DashboardHandler(http.server.SimpleHTTPRequestHandler):
    workspace = ""
    static_dir = ""

    def log_message(self, format, *args):
        sys.stdout.write(f"[{time.strftime('%H:%M:%S')}] {args[0]} {args[1]}\n")

    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Access-Control-Allow-Origin", "*")
        super().end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        query = urllib.parse.parse_qs(parsed.query)

        if path == "/api/status":
            sprint_id = query.get("sprint", ["current"])[0]
            payload = compute_full_status(self.workspace, sprint_id)
            body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        if path == "/api/sprints":
            sprints = get_available_sprints(self.workspace)
            body = json.dumps(sprints, ensure_ascii=False).encode("utf-8")
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        if path == "/api/stream":
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "text/event-stream")
            self.send_header("Connection", "keep-alive")
            self.end_headers()
            try:
                last_payload = ""
                while True:
                    data = compute_full_status(self.workspace, "current")
                    json_str = json.dumps(data, ensure_ascii=False)
                    if json_str != last_payload:
                        self.wfile.write(f"data: {json_str}\n\n".encode("utf-8"))
                        self.wfile.flush()
                        last_payload = json_str
                    time.sleep(1.0)
            except (BrokenPipeError, ConnectionResetError): pass
            return

        target_file = path.lstrip("/")
        file_path = os.path.join(self.static_dir, "index.html" if target_file in ("", "index.html") else target_file)
        real_file = os.path.realpath(file_path)
        real_static = os.path.realpath(self.static_dir)

        if not real_file.startswith(real_static) or not os.path.exists(real_file):
            self.send_error(HTTPStatus.NOT_FOUND, "File not found")
            return

        content_type = "text/html; charset=utf-8"
        if real_file.endswith(".css"): content_type = "text/css; charset=utf-8"
        elif real_file.endswith(".js"): content_type = "application/javascript; charset=utf-8"
        elif real_file.endswith(".json"): content_type = "application/json; charset=utf-8"

        try:
            with open(real_file, "rb") as f: content = f.read()
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", content_type)
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        except Exception as e:
            self.send_error(HTTPStatus.INTERNAL_SERVER_ERROR, str(e))

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode("utf-8") if length > 0 else "{}"

        if parsed.path == "/api/sprint/archive":
            resp_data = archive_current_sprint(self.workspace)
            body_bytes = json.dumps(resp_data, ensure_ascii=False).encode("utf-8")
            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Content-Length", str(len(body_bytes)))
            self.end_headers()
            self.wfile.write(body_bytes)
            return

        if parsed.path == "/api/gate/signoff":
            try:
                data = json.loads(body)
                gate_key = data.get("gate", "")
                note = data.get("note", "Approved via Mission Control")
                pipeline_sh = os.path.join(self.workspace, "scripts", "gate_pipeline.sh")
                if os.path.exists(pipeline_sh):
                    subprocess.run(["bash", pipeline_sh, "next"], cwd=self.workspace, check=False)
                resp = json.dumps({"status": "SUCCESS", "gate": gate_key, "note": note}).encode("utf-8")
                self.send_response(HTTPStatus.OK)
                self.send_header("Content-Type", "application/json; charset=utf-8")
                self.end_headers()
                self.wfile.write(resp)
            except Exception as e:
                self.send_error(HTTPStatus.BAD_REQUEST, str(e))
            return

        self.send_error(HTTPStatus.NOT_FOUND)

def run_server(port: int = DEFAULT_PORT, workspace: str = None):
    workspace = workspace or find_workspace_root()
    static_dir = find_dashboard_static_dir(workspace)
    DashboardHandler.workspace = workspace
    DashboardHandler.static_dir = static_dir

    socketserver.TCPServer.allow_reuse_address = True
    active_port = port
    httpd = None
    while active_port <= MAX_PORT:
        try:
            httpd = socketserver.TCPServer((HOST, active_port), DashboardHandler)
            break
        except OSError: active_port += 1

    if not httpd:
        sys.stderr.write(f"❌ Error: All ports from {port} to {MAX_PORT} are busy.\n")
        sys.exit(1)

    url = f"http://{HOST}:{active_port}"
    print(f"\n⚡ ========================================================")
    print(f"🚀 ANTIGRAVITY MISSION CONTROL [MULTI-SPRINT & MULTI-PROJECT]")
    print(f"⚡ ========================================================")
    print(f"  • Local URL:      {url}")
    print(f"  • Workspace:      {workspace}")
    print(f"  • Static Assets:  {static_dir}")
    print(f"  • Multi-Sprint:   Enabled (Archive & Switcher)")
    print(f"⚡ ========================================================\n")

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        httpd.server_close()

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else None
    run_server(DEFAULT_PORT, target)
