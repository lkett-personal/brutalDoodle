extends Node

enum Phase { IDLE, BUILD, ATTACK, ROUND_END }

var current_phase: Phase = Phase.IDLE
var build_time := 60.0
var attack_time := 30.0
var time_remaining := 0.0

signal phase_changed(new_phase: Phase)
signal round_ended(infiltrator_won: bool)

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	time_remaining -= delta
	if time_remaining <= 0.0:
		_on_timer_expired()

func start_round() -> void:
	_set_phase(Phase.BUILD)

func _set_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	phase_changed.emit(new_phase)
	match new_phase:
		Phase.BUILD:
			time_remaining = build_time
			set_process(true)
		Phase.ATTACK:
			time_remaining = attack_time
			set_process(true)
		Phase.ROUND_END:
			set_process(false)
		Phase.IDLE:
			set_process(false)

func _on_timer_expired() -> void:
	match current_phase:
		Phase.BUILD:
			_set_phase(Phase.ATTACK)
		Phase.ATTACK:
			_end_round(false)

func gem_reached() -> void:
	if current_phase == Phase.ATTACK:
		_end_round(true)

func _end_round(infiltrator_won: bool) -> void:
	_set_phase(Phase.ROUND_END)
	round_ended.emit(infiltrator_won)

func next_round() -> void:
	_set_phase(Phase.IDLE)
