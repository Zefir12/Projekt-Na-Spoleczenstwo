extends NinePatchRect

var pressed = false

onready var line = $Line2D

func _ready() -> void:
	pass


func _on_NinePatchRect_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("l_click"):
		pressed = true
	if event.is_action_released("l_click"):
		pressed = false
	var point = get_closest_point(line.points)
	if pressed:
		line.points[point].y = get_local_mouse_position().y


func get_closest_point(arr):
	var closest = arr[0]
	var counter = 0
	var count = 0
	for point in arr:
		if abs(get_local_mouse_position().x - point.x) < abs(get_local_mouse_position().x - closest.x):
			closest = point
			count = counter
		counter += 1
	return count
