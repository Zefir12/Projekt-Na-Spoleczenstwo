extends Node2D

var outputting_energy = true
var accepting_energy = true
var grid_connection_id = null

var type = 'producer'

export (float) var energy_producing_rate = 0
var energy_produced = 0
var menu_reference

func handle_production():
	self.energy_produced = self.energy_producing_rate
	return self.energy_produced

func show_menu(pos: Vector2):
	menu_reference.rect_position = pos
	menu_reference.popup()
