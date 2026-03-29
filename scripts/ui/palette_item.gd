extends Button

@export var scene_to_place: PackedScene
@export var display_name: String = "Item"
@export var icon_texture: Texture2D

var _dragging := false
var _preview: Node = null

func _ready() -> void:
	self.text = display_name
	if icon_texture:
		self.icon = icon_texture

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if event.pressed:
		_dragging = true
		_spawn_preview()
	elif _dragging:
		_dragging = false
		_commit_place()
		if _preview:
			_preview.queue_free()
			_preview = null

func _process(_delta: float) -> void:
	if _dragging and _preview:
		_preview.global_position = _get_world_mouse()

func _spawn_preview() -> void:
	if not scene_to_place:
		return
	_preview = scene_to_place.instantiate()
	get_tree().current_scene.add_child(_preview)
	_preview.modulate = Color(1.0, 1.0, 1.0, 0.5)
	_set_preview_frozen(_preview, true)
	_preview.global_position = _get_world_mouse()

func _commit_place() -> void:
	if not scene_to_place:
		return
	var obj = scene_to_place.instantiate()
	get_tree().current_scene.add_child(obj)
	obj.global_position = _get_world_mouse()
	_set_preview_frozen(obj, false)

func _set_preview_frozen(node: Node, frozen: bool) -> void:
	# Recurse through the scene to catch all RigidBody2D nodes
	for child in node.get_children():
		if child is RigidBody2D:
			child.freeze = frozen
		_set_preview_frozen(child, frozen)  # recurse for nested bodies

func _get_world_mouse() -> Vector2:
	# get_global_mouse_position() from a game scene node = world coords
	return get_tree().current_scene.get_global_mouse_position()
