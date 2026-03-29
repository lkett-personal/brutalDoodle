extends RichTextLabel

@export var timer : Timer

func _physics_process(_delta: float) -> void:
	text = str(roundi(timer.time_left))
	
	#if timer.time_left <= 0:
		#pass
