# Technical Debt 清單

## P0（近期必解）
1. **邊界目前為 clamp**
   - 現況：`employee.gd` 用 `walkable_bounds` 強制夾住位置
   - 風險：遇到障礙物與複雜地圖會不自然
   - 計畫：改為 `NavigationRegion2D + NavigationAgent2D`

2. **行為循環為單員工硬編碼**
   - 現況：`game_manager.gd` 僅對一名員工跑流程
   - 計畫：抽出 `AgentController` 支援多員工

## P1（下階段）
3. **JobGenerator 目前只回傳產能文字/倍率**
   - 計畫：與真工單資料結構整合（難度、時長、回報、壓力影響）

4. **Stats 已有骨架但尚未完全驅動 gameplay**
   - 計畫：把壓力、EQ、knowledge 接入任務成功率與回報

## P2（美術整合期）
5. **素材路徑尚未標準化**
   - 現況：大量沿用外部素材包原始命名
   - 計畫：統一命名後批次重綁 scene/resource
