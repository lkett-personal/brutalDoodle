extends Node

enum Phase { IDLE, BUILD_DEFENSE, BUILD_ATTACK, SIMULATE, ROUND_END }

var current_phase: Phase = Phase.IDLE
var build_defense_time := 60.0
var build_attack_time := 60.0
var simulate_time := 30.0
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
	_set_phase(Phase.BUILD_DEFENSE)

func _set_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	phase_changed.emit(new_phase)
	match new_phase:
		Phase.BUILD_DEFENSE:
			time_remaining = build_defense_time
			set_process(true)
		Phase.BUILD_ATTACK:
			time_remaining = build_attack_time
			set_process(true)
		Phase.SIMULATE:
			time_remaining = simulate_time
			set_process(true)
		Phase.ROUND_END, Phase.IDLE:
			set_process(false)

func _on_timer_expired() -> void:
	match current_phase:
		Phase.BUILD_DEFENSE:
			_set_phase(Phase.BUILD_ATTACK)
		Phase.BUILD_ATTACK:
			_set_phase(Phase.SIMULATE)
		Phase.SIMULATE:
			_end_round(false)

func gem_reached() -> void:
	if current_phase == Phase.SIMULATE:
		_end_round(true)

func _end_round(infiltrator_won: bool) -> void:
	_set_phase(Phase.ROUND_END)
	round_ended.emit(infiltrator_won)

func next_round() -> void:
	_set_phase(Phase.IDLE)
