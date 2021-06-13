extends Node2D

var grid_count = 0
var selected_grid = null
onready var timer = $Timer
onready var grids = $grids

signal selected(object)

func _ready():
	for child in grids.get_children():
		grid_count += 1
		child.id = grid_count
		child.system_reference = self

func handle_system(time_multiplier):
	for _b in range(time_multiplier):
		Globals.add_minute()
		for grid in grids.get_children():
			grid.handle_energy()

func _physics_process(_delta: float) -> void:
	handle_system(Globals.time_multiplier)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('l_click'):
		var _last_selected = selected_grid
		for child in grids.get_children():
			child.unselect()
		emit_signal("selected", null)
		for child in grids.get_children():
			if child.active:
				selected_grid = child
				child.select()
				emit_signal("selected", child)
