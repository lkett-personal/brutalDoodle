extends RichTextLabel

func _ready() -> void:
	GameManager.start_round()
	
func _physics_process(_delta: float) -> void:
		text = str(roundi(GameManager.time_remaining))
