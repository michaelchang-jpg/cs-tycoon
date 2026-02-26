# CS Tycoon - Architecture Snapshot

## Runtime Graph (current)
- `Main (Node2D)`
  - `game_manager.gd`：主循環、UI 更新、產能累積
- `World/Entities/Employee (CharacterBody2D)`
  - `employee.gd`：有限狀態機（工作/喝水）+ 邊界約束
- `World/Entities/Desk (Area2D)`
  - `desk.gd`：提供工作互動座標
- `World/Entities/WaterCooler (Area2D)`
  - `water_cooler.gd`：提供休息互動座標
- `DebugOverlay (CanvasLayer)`
  - `debug_overlay.gd`：除錯可視化

## Supporting Modules
- `stats.gd` (`EmployeeStats`): 第二階段數值骨架（EQ/knowledge/stress）
- `job_generator.gd` (`JobGenerator`): 產能倍率與狀態文字策略
- `ticket.gd` (`Ticket`): 舊工單資料結構（待重新整合）

## Current Behavior Loop
1. 員工待命
2. 若壓力低於門檻 -> 去桌子工作
3. 若壓力高於門檻 -> 去飲水機喝水
4. 工作提高壓力、喝水降低壓力
5. UI/Debug Overlay 即時反映狀態

## Known Transitional Design
- 邊界控制目前用 `Rect2 clamp`，是過渡方案。
- 下一步應切換到 `NavigationRegion2D + NavigationAgent2D`。
