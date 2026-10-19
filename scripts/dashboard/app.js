// =============================================================================
// Neobrutalism Mission Control Client Script [Multi-Sprint & Multi-Project]
// Pure Vanilla ES6 — Zero external build step or bundle dependency.
// =============================================================================

let currentData = null;
let selectedSprintId = "current";
let eventSource = null;

function updateClock() {
  const el = document.getElementById("terminal-clock");
  if (el) el.textContent = new Date().toTimeString().split(" ")[0];
}
setInterval(updateClock, 1000);

function logTerminal(tag, message) {
  const body = document.getElementById("terminal-body");
  if (!body) return;
  const now = new Date().toTimeString().split(" ")[0];
  const line = document.createElement("div");
  line.className = "terminal-line";
  line.innerHTML = `<span class="t-time">[${now}]</span> <span class="t-tag">[${tag}]</span> ${escapeHtml(message)}`;
  body.appendChild(line);
  body.scrollTop = body.scrollHeight;
}

function escapeHtml(str) {
  if (!str) return "";
  return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function renderUI(data) {
  if (!data) return;
  currentData = data;

  // 1. Header & Project Metadata
  const pName = data.project?.project_name || data.project_name || "PROJECT";
  document.getElementById("proj-title").textContent = `${pName.toUpperCase()} // MISSION CONTROL`;

  // 2. Sprint Selector Dropdown
  const sprintSelect = document.getElementById("sprint-select");
  if (sprintSelect && data.available_sprints) {
    const currentVal = sprintSelect.value;
    sprintSelect.innerHTML = "";
    data.available_sprints.forEach(s => {
      const opt = document.createElement("option");
      opt.value = s.id;
      opt.textContent = s.name;
      if (s.id === data.selected_sprint_id) opt.selected = true;
      sprintSelect.appendChild(opt);
    });
  }

  // 3. Hero KPIs
  document.getElementById("kpi-progress").textContent = `${data.sprint.progress_percent}%`;
  document.getElementById("kpi-sp").textContent = `${data.sprint.completed_sp} / ${data.sprint.committed_sp} SP Completed`;

  const activeGateObj = data.gates.find(g => g.key === String(data.current_gate)) || data.gates[0];
  document.getElementById("kpi-gate").textContent = `GATE ${data.current_gate}`;
  document.getElementById("kpi-gate-role").textContent = activeGateObj ? activeGateObj.name : "Quality Gate";

  document.getElementById("kpi-tasks").textContent = `${data.stats.done_tasks} / ${data.stats.total_tasks}`;
  document.getElementById("kpi-tasks-sub").textContent = `${data.stats.in_progress_tasks} In Progress • ${data.stats.todo_tasks} Queued`;

  document.getElementById("kpi-git-branch").textContent = data.git.branch;
  document.getElementById("kpi-git-commit").textContent = `${data.git.uncommitted_count} uncommitted • ${data.git.last_commit}`;

  // 4. Render 9 Sub-Agents Squad
  const agentsContainer = document.getElementById("agents-container");
  if (agentsContainer) {
    agentsContainer.innerHTML = "";
    let activeCount = 0;

    data.agents.forEach(agent => {
      if (agent.status === "WORKING") activeCount++;
      const card = document.createElement("div");
      card.className = "agent-card";
      const statusBadgeClass = agent.status === "WORKING" ? "badge-working" : (agent.status === "BLOCKED" ? "badge-blocked" : "badge-idle");

      card.innerHTML = `
        <div class="agent-top">
          <div class="agent-profile">
            <div class="agent-avatar" style="background-color: ${agent.color || '#FFF'}">${agent.avatar}</div>
            <div class="agent-name-group">
              <span class="agent-name">${agent.name} — ${agent.title}</span>
              <span class="agent-persona">${agent.tag}</span>
            </div>
          </div>
          <span class="neo-badge ${statusBadgeClass}">${agent.status}</span>
        </div>
        <div class="agent-task"><strong>Task:</strong> ${escapeHtml(agent.current_task)}</div>
      `;
      agentsContainer.appendChild(card);
    });
    document.getElementById("agent-active-count").textContent = `${activeCount} ACTIVE`;
  }

  // 5. Render Quality Gates Stepper
  const gatesContainer = document.getElementById("gates-container");
  if (gatesContainer) {
    gatesContainer.innerHTML = "";
    data.gates.forEach(gate => {
      const gCard = document.createElement("div");
      gCard.className = `gate-card gate-${gate.status}`;
      const icon = gate.status === "COMPLETED" ? "✅" : (gate.status === "IN_PROGRESS" ? "⚡" : "⏳");
      gCard.innerHTML = `
        <span class="gate-key">G${gate.key}</span>
        <span class="gate-status-icon">${icon}</span>
        <span class="gate-badge">${gate.badge}</span>
      `;
      gCard.title = `${gate.name} (${gate.status})`;
      gatesContainer.appendChild(gCard);
    });
  }

  // 6. Render Kanban Board
  renderKanbanColumn("col-todo", data.sprint.tasks.todo);
  renderKanbanColumn("col-in-progress", data.sprint.tasks.in_progress);
  renderKanbanColumn("col-done", data.sprint.tasks.done);

  document.getElementById("todo-count").textContent = data.sprint.tasks.todo.length;
  document.getElementById("in-progress-count").textContent = data.sprint.tasks.in_progress.length;
  document.getElementById("done-count").textContent = data.sprint.tasks.done.length;
  document.getElementById("kanban-total-badge").textContent = `${data.stats.total_tasks} TASKS`;
}

function renderKanbanColumn(containerId, tasks) {
  const container = document.getElementById(containerId);
  if (!container) return;
  container.innerHTML = "";
  if (!tasks || tasks.length === 0) {
    container.innerHTML = `<div style="color:#777; font-size:12px; text-align:center; padding:16px;">(No tasks in this lane)</div>`;
    return;
  }
  tasks.forEach(task => {
    const card = document.createElement("div");
    card.className = "task-sticker";
    card.innerHTML = `
      <div class="task-top">
        <span class="task-id">${task.id}</span>
        <span class="neo-badge">${task.gate}</span>
      </div>
      <div class="task-desc">${escapeHtml(task.desc)}</div>
      <div class="task-bottom">
        <span>👤 <code>${task.agent}</code></span>
        <span><strong>${task.sp} SP</strong></span>
      </div>
    `;
    container.appendChild(card);
  });
}

async function switchSprint(sprintId) {
  selectedSprintId = sprintId;
  logTerminal("SPRINT", `Switching view to: ${sprintId}`);
  try {
    const res = await fetch(`/api/status?sprint=${encodeURIComponent(sprintId)}`);
    const data = await res.json();
    renderUI(data);
  } catch (err) {
    logTerminal("ERR", `Failed to load sprint: ${err.message}`);
  }
}

async function handleArchiveSprint() {
  if (!confirm("Bạn có chắc chắn muốn LƯU TRỮ (Archive) Sprint hiện tại và khởi tạo Sprint mới không?")) return;
  try {
    const res = await fetch("/api/sprint/archive", { method: "POST" });
    const result = await res.json();
    if (result.status === "SUCCESS") {
      logTerminal("ARCHIVE", `Archived Sprint ${result.archived_sprint} to ${result.archive_file}. Initialized Sprint ${result.next_sprint}!`);
      manualRefresh();
    } else {
      alert("Lỗi: " + result.message);
    }
  } catch (e) {
    alert("Lỗi lưu trữ Sprint: " + e.message);
  }
}

async function handleGateApprove() {
  if (!currentData) return;
  const activeGate = currentData.current_gate || "0";
  if (!confirm(`Bạn có chắc chắn muốn KÝ DUYỆT (Sign-off) Gate ${activeGate} cho dàn Agent?`)) return;
  try {
    const res = await fetch("/api/gate/signoff", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ gate: activeGate, note: "Approved via Mission Control" })
    });
    const result = await res.json();
    if (result.status === "SUCCESS") {
      logTerminal("GATE", `Human Commander signed off Gate ${activeGate}! Hand-off dispatched.`);
      manualRefresh();
    }
  } catch (e) {
    alert("Lỗi khi ký duyệt: " + e.message);
  }
}

function connectSSE() {
  const connBadge = document.getElementById("conn-badge");
  if (window.EventSource) {
    eventSource = new EventSource("/api/stream");
    eventSource.onopen = () => {
      if (connBadge) {
        connBadge.textContent = "● LIVE SSE";
        connBadge.className = "neo-badge badge-done";
      }
    };
    eventSource.onmessage = (event) => {
      try {
        if (selectedSprintId === "current") {
          const payload = JSON.parse(event.data);
          renderUI(payload);
        }
      } catch (e) { console.error("SSE parse error:", e); }
    };
    eventSource.onerror = () => {
      if (connBadge) {
        connBadge.textContent = "⚠ RECONNECTING...";
        connBadge.className = "neo-badge badge-working";
      }
      eventSource.close();
      setTimeout(connectSSE, 3000);
    };
  } else {
    setInterval(manualRefresh, 2000);
  }
}

async function manualRefresh() {
  try {
    const res = await fetch(`/api/status?sprint=${encodeURIComponent(selectedSprintId)}`);
    const data = await res.json();
    renderUI(data);
    logTerminal("SYNC", "Refreshed snapshot.");
  } catch (err) {
    logTerminal("ERR", `Sync failed: ${err.message}`);
  }
}

window.addEventListener("DOMContentLoaded", () => {
  updateClock();
  manualRefresh();
  connectSSE();
});
