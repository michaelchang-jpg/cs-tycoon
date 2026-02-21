class_name Ticket
extends Resource

## 工單資源腳本 (Ticket)
## 定義每一個客戶需求的資料結構

enum Type { GENERAL, TECHNICAL, COMPLAINT } # 一般、技術、客訴

@export var title: String = "重設密碼"
@export var type: Type = Type.GENERAL
@export var difficulty: float = 1.0 # 難度係數 (影響處理時間)
@export var reward: int = 100 # 完成後的獎金
@export var stress_impact: float = 5.0 # 對員工造成的壓力

# 靜態方法：快速產生一個隨機工單
static func generate_random() -> Ticket:
	var ticket = Ticket.new()
	var type_roll = randf()
	
	if type_roll < 0.6:
		ticket.type = Type.GENERAL
		ticket.title = "一般諮詢"
		ticket.difficulty = randf_range(0.8, 1.2)
		ticket.reward = 50
		ticket.stress_impact = 2.0
	elif type_roll < 0.9:
		ticket.type = Type.TECHNICAL
		ticket.title = "技術支援"
		ticket.difficulty = randf_range(1.5, 2.5)
		ticket.reward = 150
		ticket.stress_impact = 10.0
	else:
		ticket.type = Type.COMPLAINT
		ticket.title = "客訴案件"
		ticket.difficulty = randf_range(2.0, 4.0)
		ticket.reward = 300
		ticket.stress_impact = 25.0
		
	return ticket
