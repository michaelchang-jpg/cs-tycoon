# Developer Log - CS Tycoon

## ✅ Current State: [Night Build Plus]
- **Status**: 在不改壞夜測版本的前提下，補完工程基礎建設
- **Build Focus**: 減少反覆驗收依賴，先鋪可持續開發軌道

## 📝 Session Update (2026-02-26)
- **參數化完成**
  - `employee.gd`：新增可調參數（壓力門檻、工作/喝水時長、移速、邊界）
- **Debug Overlay**
  - 新增 `scripts/debug_overlay.gd`
  - 顯示 State / Position / Target / Stress 每秒變化
- **第二階段骨架**
  - 新增 `scripts/stats.gd`（EmployeeStats Resource）
  - 新增 `scripts/job_generator.gd`（產能倍率與文字輸出）
  - `game_manager.gd` 已接入上述骨架（不改核心玩法）
- **流程與規範文件**
  - `TEST_FLOW.md`：固定 2 分鐘回歸流程
  - `ASSET_NAMING.md`：素材命名與路徑規範草案
  - `TECH_DEBT.md`：技術債分級清單
  - `ARCHITECTURE.md`：目前系統拓樸與過渡設計說明
  - `NEXT_UP.md`：可無審批先做的 backlog 批次
- **工程便利性**
  - `project.godot` 補上 `ui_debug_toggle`（F3）

## 📁 Files Changed
- `scenes/main.tscn`
- `scripts/employee.gd`
- `scripts/game_manager.gd`
- `scripts/debug_overlay.gd` (new)
- `scripts/stats.gd` (new)
- `scripts/job_generator.gd` (new)
- `TEST_FLOW.md` (new)
- `ASSET_NAMING.md` (new)
- `TECH_DEBT.md` (new)
- `PLAN.md` (new)

## 🔧 Additional Progress (2026-02-26, batch-2)
- `main.tscn` 新增 `NavigationRegion2D` 與 `NavigationPolygon`（辦公室可走區域）
- `Employee` 新增 `NavigationAgent2D` 節點
- `employee.gd` 新增 `use_navigation_agent` feature flag（預設關閉，避免影響現有驗收）
- 已支援在相同行為迴圈中切換：`clamp mode` / `navigation mode`

## ⏭️ Next Actions
1. 在你驗收完穩定版後，將 `use_navigation_agent` 設為預設 true 並調路徑參數。
2. 多員工化（抽離 agent controller）。
3. 將 Stats / JobGenerator 正式綁定工單難度與成功率。
