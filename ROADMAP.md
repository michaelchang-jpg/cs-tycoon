# CS Tycoon (客服物語) 開發路線圖

### 🏁 第一階段：AI 與環境基礎
- [x] 核心 AI 狀態機 (已建立基礎腳本：閒晃與休息邏輯)
- [x] 導航系統與辦公室邊界設定（v1: clamp 邊界）
- [x] 互動點實作（辦公桌、飲水機）
- [ ] 導航系統 v2（NavigationRegion2D + NavigationAgent2D 正式啟用）

### 🧠 第二階段：數值與工作循環
- [~] 員工屬性系統 (EQ、壓力值、專業知識)（已建立 `stats.gd` 骨架）
- [~] 工單自動產生器（已建立 `job_generator.gd` 骨架，待與 `ticket.gd` 整合）
- [~] 經濟系統 (賺取金錢以升級設備)（已接入即時產能累積，待升級機制）

### 📊 第三階段：管理介面與 UI
- [~] 主控面板 (Dashboard)（已有基礎資訊與 Debug Overlay）
- [ ] 員工招募系統

### 🏢 第四階段：辦公室佈置
- [ ] 建設模式 (自由擺放家具)
- [ ] 設施 Buff/Debuff 影響範圍
- [ ] **Godot 4.6 優化**: 使用 `TileMapLayer` 提升辦公室地圖效能，並開啟 2D Transform 插值以優化小人移動流暢度。

### 🌟 第五階段：事件與優化
- [ ] 奧客與重大客訴 Boss 戰
- [x] **美術風格確立**: 採用 LimeZu Modern Office (16x16 Pixel Art) 風格。
- [~] 正式美術素材替換與打磨（已改為 Sprite2D 素材，待動畫化與全面替換）

---

## 最近更新（2026-02-26）
- 完成夜間可驗收最小迴圈：工作 ↔ 喝水 ↔ 壓力變化。
- 新增 `TEST_FLOW.md`、`TECH_DEBT.md`、`ARCHITECTURE.md`、`NEXT_UP.md` 便於持續推進。
- 導航系統已完成骨架，但仍預設使用穩定 fallback（clamp mode）。
