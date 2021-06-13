extends Node2D



onready var collision = $Area2D/CollisionPolygon2D
onready var polygon = $Polygon2D
onready var line2d = $Line2D

var system_reference
var active = false
var selected = false
var record_data = false

var id = -1
var connected_grids = []
onready var energy_producers = $producers
onready var energy_consumers = $consumers
onready var energy_storages = $storages
var produced = 0
var consumed = 0
var stored = 0
var net_total = 0

var data_stored = []

func _ready() -> void:
	var new_pos = []
	for data in collision.polygon:
		new_pos.append(data + collision.position)
	polygon.polygon = new_pos
	new_pos.append(new_pos[0])
	line2d.points = new_pos


func _physics_process(_delta: float) -> void:
	if selected:
		polygon.color = Color.aquamarine

func _produce_from_producers(net_totalii):
	var net_totalt = net_totalii
	for energy_producer in self.energy_producers.get_children():
		net_totalt += energy_producer.handle_production()
	return net_totalt

func _consume_from_consumers(net_totalii):
	var net_totalt = net_totalii
	for energy_consumer in self.energy_consumers.get_children():
		net_totalt -= energy_consumer.handle_consumption()
	return net_totalt

func _handle_storages(net_totalii):
	var net_totalt = net_totalii
	for storage in self.energy_storages.get_children():
		net_totalt = storage.handle_storing(net_totalt)
	return net_totalt

func handle_energy():
	if record_data and Globals.minute == 0:
		store_data()
	var net_totalt = 0
	net_totalt = self._consume_from_consumers(net_totalt)
	net_totalt = self._produce_from_producers(net_totalt)
	self.net_total = self._handle_storages(net_totalt)
	self.stored = self._get_total_in_storages()
	self.consumed = self._get_total_consumers()
	self.produced = self._get_total_producers()

func store_data():
	var text_to_store = "%s;%s:00;%s;%s;%s;%s" % [Globals.day, Globals.hour, produced, consumed, stored/20.0, net_total]
	text_to_store = text_to_store.replace('.', ',')
	data_stored.append(text_to_store)


func save_stored_data():
	var file = File.new()
	file.open('%s//saved_data/%s.txt' % [OS.get_user_data_dir(), id], File.WRITE)
	for line in data_stored:
		file.store_line(line)

func _get_total_in_storages():
	var total = 0
	for storage in self.energy_storages.get_children():
		total += storage.stored_energy
	return total

func _get_total_consumers():
	var total = 0
	for consumer in self.energy_consumers.get_children():
		total += consumer.actual_energy_consumption()
	return total

func _get_total_producers():
	var total = 0
	for producer in self.energy_producers.get_children():
		total += producer.energy_producing_rate
	return total

func data():
	return "[ID]: {round_to(self.id)}, net: {round_to(self.net_total)},  stored: {round_to(self.stored)}, produced: {round_to(self.produced)}, consumed: {round_to(self.consumed)}"

func select():
	selected = true
	#print(id)

func unselect():
	selected = false
	polygon.color = Color.white

func _on_Area2D_mouse_entered() -> void:
	polygon.color = Color.wheat
	active = true

func _on_Area2D_mouse_exited() -> void:
	polygon.color = Color.white
	active = false
