# Developer Log - CS Tycoon

## ✅ Current State: [Night Build Ready]
- **Status**: 第一階段缺口補完（導航邊界＋互動點）
- **Build Focus**: 晚上可快速驗收的最小可玩循環

## 📝 Session Update (2026-02-26)
- **Navigation/Boundary**:
  - 在 `employee.gd` 新增 `walkable_bounds`，移動時會 clamp 到可走區域，避免穿出場景。
- **Interaction Points**:
  - 保留 `Desk` 互動點。
  - 新增 `WaterCooler` 互動點與腳本 `water_cooler.gd`。
- **Behavior Loop**:
  - 員工行為改為：`待命 -> 前往辦公桌 -> 工作 -> 待命` 或 `待命 -> 前往飲水機 -> 喝水 -> 待命`。
  - 壓力高於門檻會優先去喝水。
- **Stress System (MVP)**:
  - 工作時壓力持續上升、喝水時壓力持續下降，範圍 0~100。
- **UI Update**:
  - 新增 `StressLabel` 與 `ActionLabel`，即時顯示壓力值與目前行為。

## 📁 Files Changed
- `scenes/main.tscn`
- `scripts/employee.gd`
- `scripts/game_manager.gd`
- `scripts/water_cooler.gd` (new)

## ⏭️ Next Actions
1. 將目前簡單邊界升級為 Godot NavigationRegion2D + NavigationAgent2D。
2. 桌子/飲水機加入動畫（坐下、喝水）與簡單音效。
3. 接第二階段：EQ/專業值與工單系統重新整合。
