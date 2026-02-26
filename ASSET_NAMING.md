# 資產命名與路徑規範（草案）

## 目錄規則
- `assets/environment/`：地板、牆面、場景物件
- `assets/characters/`：角色與動畫
- `assets/ui/`：UI icon、面板素材

## 命名規則
- 全小寫 + 底線：`office_desk_ne.png`
- 方向尾碼固定：`_n`, `_s`, `_e`, `_w`, `_ne`, `_nw`, `_se`, `_sw`
- 角色動畫：`employee_walk_down_00.png`

## 目前遷移策略
- 現階段保留 `kenney_furniture-kit` 原路徑，不強制重命名。
- 新增素材一律遵守上方命名規則。
- 待美術整合期再做一次性搬移（避免現在破壞引用）。
