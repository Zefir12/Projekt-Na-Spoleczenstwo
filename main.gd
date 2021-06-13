extends Control

var last_r_click_pos = Vector2(0, 0)
var last_camera_click_pos = Vector2(0, 0)
var building = false
onready var r_click_menu = $CanvasLayer/menu
onready var energy_system = $EnergySystem
onready var menu_bar = $CanvasLayer/Menu_bar

var buildings = {   0: 'res://EnergyProducer.tscn',
					1: 'res://EnergyConsumer.tscn',
					2: 'res://EnergyStorage.tscn'}


func _ready() -> void:
	_first_run_check()


func _first_run_check():
	var path = OS.get_user_data_dir()
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir("templates")
	dir.make_dir("saved_data")
	dir.make_dir("consumption")
	for consump in Globals.list_files_in_directory("%s//consumption" % [OS.get_user_data_dir()]):
		load_consumption(consump)


func load_consumption(ffilename):
	var saved_stuff = File.new()
	var consumption = {}
	var counter = 0
	saved_stuff.open("%s//consumption/%s" % [OS.get_user_data_dir(), ffilename], File.READ)
	while saved_stuff.get_position() < saved_stuff.get_len():
		var node_data = parse_json(saved_stuff.get_line())
		if counter < 24:
			consumption[counter] = node_data
			counter += 1
	Globals.consumption_types[ffilename.rstrip(".txt")] = consumption


func _physics_process(_delta: float) -> void:
	if building:
		place_template()

func place_template():
	var id = menu_bar.build_temps.selected
	var item_name = menu_bar.take_from_option_button(id)
	if item_name != 'Nothing':
		place_object(menu_bar.templates[item_name], energy_system.selected_grid)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('r_click'):
		last_r_click_pos = get_global_mouse_position()
		var screenSize = Vector2(0,0)
		screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
		screenSize.y = get_viewport().get_visible_rect().size.y # Get Height
		last_camera_click_pos = ($Camera2D.get_local_mouse_position() / $Camera2D.zoom)  + screenSize/Vector2(2, 2)
		#r_click_menu.rect_position = last_camera_click_pos
		#r_click_menu.popup()
	if event.is_action_pressed('l_click'):
		if menu_bar.build_mode.pressed:
			building = true
		else:
			place_template()
	if event.is_action_released("l_click"):
		building = false


func place_object(template, parent):
		var instance = template.duplicate(8)
		instance.position = get_global_mouse_position()
		if instance.type == 'consumer':
			parent.energy_consumers.add_child(instance)
		if instance.type == 'producer':
			parent.energy_producers.add_child(instance)
		if instance.type == 'storage':
			parent.energy_storages.add_child(instance)

func _on_menu_id_pressed(_id: int) -> void:
	pass
	#place_object(id, energy_system.selected_grid)



func _on_EnergySystem_selected(object) -> void:
	if object == null:
		menu_bar.unselect_grid()
	else:
		menu_bar.select_grid(object)
