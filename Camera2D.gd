extends Camera2D

var last_pos = Vector2(0, 0)
var camera_moving = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 4:
			zoom *= 0.97
		if event.button_index == 5:
			zoom *= 1.03
		if event.button_index == 3:
			if event.pressed:
				last_pos = get_global_mouse_position()
				camera_moving = true
			if not event.pressed:
				camera_moving = false

func _physics_process(_delta: float) -> void:
	if camera_moving:
		global_position -= get_global_mouse_position() - last_pos
		last_pos = get_global_mouse_position() - (get_global_mouse_position() - last_pos)
		
