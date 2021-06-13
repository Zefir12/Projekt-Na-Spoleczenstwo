extends Node2D

var outputting_energy = true
var accepting_energy = true
var grid_connection_id = null

var type = 'consumer'
export (float) var energy_consuming_rate = 0
var energy_needed = 0
export (int) var energy_consumption_type = "standard"
var timer_reference = Globals

func actual_energy_consumption():
	return self.energy_consuming_rate * Globals.consumption_types[energy_consumption_type][self.timer_reference.hour]

func handle_consumption():
	self.energy_needed = self.actual_energy_consumption()
	return self.energy_needed
