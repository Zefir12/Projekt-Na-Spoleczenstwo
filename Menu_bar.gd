extends Control

var current_grid = null

onready var main_label = $pnl/vbx/label_part/LineEdit
onready var building_panel = $pnl/vbx/building_part
onready var stats_panel = $pnl/vbx/stats_part
onready var data_panel = $pnl/vbx/data_part
onready var build_temps = $pnl/vbx/building_part/vbx/HBoxContainer/build_temps
onready var build_mode = $pnl/vbx/building_part/vbx/HBoxContainer/build_mode
onready var current_time_label = $"time_panel/vbx/hbx/current time"

onready var total_consumers = $pnl/vbx/stats_part/vbx/numbers/total_consumers
onready var total_producers = $pnl/vbx/stats_part/vbx/numbers/total_producers
onready var total_storages = $pnl/vbx/stats_part/vbx/numbers/total_storages

onready var energy_net = $pnl/vbx/stats_part/vbx/energy/energy_net
onready var energy_consumed = $pnl/vbx/stats_part/vbx/energy/consumed
onready var energy_produced = $pnl/vbx/stats_part/vbx/energy/produced
onready var energy_stored = $pnl/vbx/stats_part/vbx/energy/stored

onready var slider = $time_panel/vbx/hbx2/HSlider
var templates = {}

func _physics_process(_delta: float) -> void:
	current_time_label.text = Globals.get_time()
	if current_grid != null:
		update_stats_from_grid()
	Globals.time_multiplier = slider.value

func _ready() -> void:
	load_templates()
	building_panel.visible = false
	stats_panel.visible = false
	data_panel.visible = false

func take_from_option_button(id):
	return build_temps.items[id * 5]

func update_stats_from_grid():
	total_consumers.text = str(current_grid.energy_consumers.get_child_count())
	total_producers.text = str(current_grid.energy_producers.get_child_count())
	total_storages.text = str(current_grid.energy_storages.get_child_count())
	
	energy_produced.text = str(current_grid.produced)
	energy_consumed.text = str(current_grid.consumed)
	energy_stored.text = str(current_grid.stored)
	energy_net.text = str(current_grid.net_total)

func save(ffilename, dict):
	var saved_stuff = File.new()
	saved_stuff.open("%s//templates/%s" % [OS.get_user_data_dir(), ffilename], File.WRITE)
	saved_stuff.store_line(to_json(dict))

func load_from_file(ffilename):
	var saved_stuff = File.new()
	saved_stuff.open("%s//templates/%s" % [OS.get_user_data_dir(), ffilename], File.READ)
	while saved_stuff.get_position() < saved_stuff.get_len():
		var node_data = parse_json(saved_stuff.get_line())
		return node_data




func load_templates():
	for template in Globals.list_files_in_directory("%s//templates" % [OS.get_user_data_dir()]):
		print(template)
		var data = load_from_file(template)
		if data['type'] == 'consumer':
			var temp = load("res://EnergyConsumer.tscn").instance()
			temp.energy_consumption_type = data['energy_consumption_type']
			temp.energy_consuming_rate = data['energy_consuming_rate']
			templates[template] = temp
		if data['type'] == 'producer':
			var temp = load("res://EnergyProducer.tscn").instance()
			temp.energy_producing_rate = data['energy_producing_rate']
			templates[template] = temp
		if data['type'] == 'storage':
			var temp = load("res://EnergyStorage.tscn").instance()
			temp.max_capacity = data['max_capacity']
			temp.passive_losses = data['passive_losses']
			temp.releasing_speed = data['releasing_speed']
			temp.storing_speed = data['storing_speed']
			temp.output_losses = data['output_losses']
			templates[template] = temp
	
	for template in templates:
		build_temps.add_item(template)

func select_grid(grid):
	current_grid = grid
	main_label.text = str(grid.id)
	building_panel.visible = true
	stats_panel.visible = true
	data_panel.visible = true


func unselect_grid():
	current_grid = null
	main_label.text = ""
	building_panel.visible = false
	stats_panel.visible = false
	data_panel.visible = false


func _on_record_data_pressed() -> void:
	current_grid.record_data = !current_grid.record_data
	if $pnl/vbx/data_part/vbx/hbx/record_data.text == "Start recording Data":
		$pnl/vbx/data_part/vbx/hbx/record_data.text = "Stop recording Data"
	else:
		$pnl/vbx/data_part/vbx/hbx/record_data.text = "Start recording Data"


func _on_save_data_pressed() -> void:
	current_grid.save_stored_data()


func _on_copy_data_pressed() -> void:
	var stringg = "Day;Hour;Produced;Consumed;Stored/20.0;Net_total\n"
	for line in current_grid.data_stored:
		stringg += line + "\n"
	OS.set_clipboard(stringg)


func _on_reset_button_pressed() -> void:
	current_grid.data_stored  =[]


func _on_create_template_pressed() -> void:
	$WindowDialog.popup_centered()


func _on_WindowDialog_about_to_show() -> void:
	var cons_types = $WindowDialog/PanelContainer/TabContainer/Consumer/VBoxContainer/HBoxContainer2/LineEdit
	for con_typ in Globals.consumption_types:
		cons_types.add_item(con_typ, cons_types.get_child_count())






func _on_LineEdit_pressed() -> void:
	var dict = {}
	dict["type"] = "consumer"
	var option = $WindowDialog/PanelContainer/TabContainer/Consumer/VBoxContainer/HBoxContainer2/LineEdit
	dict["energy_consumption_type"] = option.get_item_text(option.selected)
	dict["energy_consuming_rate"] = int($WindowDialog/PanelContainer/TabContainer/Consumer/VBoxContainer/HBoxContainer/LineEdit.text)
	var saved_stuff = File.new()
	saved_stuff.open("%s//templates/%s" % [OS.get_user_data_dir(), $WindowDialog/PanelContainer/TabContainer/Consumer/VBoxContainer/HBoxContainer4/LineEdit.text], File.WRITE)
	saved_stuff.store_line(to_json(dict))




func _on_ok_button_pressed() -> void:
	var saved_stuff = File.new()
	saved_stuff.open("%s//consumption/%s.txt" % [OS.get_user_data_dir(), $"WindowDialog/PanelContainer/TabContainer/Consumption Type/Button/WindowDialog/LineEdit".text], File.WRITE)
	for point in $"WindowDialog/PanelContainer/TabContainer/Consumption Type/NinePatchRect/Line2D".points:
		saved_stuff.store_line(str((100 - point.y) / 100.0) + "\r")




func _on_create_producer_pressed() -> void:
	var dict = {}
	dict["type"] = "producer"
	dict["energy_producing_rate"] = int($WindowDialog/PanelContainer/TabContainer/Producer/VBoxContainer/HBoxContainer/LineEdit.text)
	var saved_stuff = File.new()
	saved_stuff.open("%s//templates/%s" % [OS.get_user_data_dir(), $WindowDialog/PanelContainer/TabContainer/Producer/VBoxContainer/HBoxContainer3/LineEdit.text], File.WRITE)
	saved_stuff.store_line(to_json(dict))


func _on_create_storage_pressed() -> void:
	var dict = {}
	dict["type"] = "storage"
	dict["max_capacity"] = int($WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer/LineEdit.text)
	dict["passive_losses"] = int($WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer2/LineEdit.text)
	dict["releasing_speed"] = int($WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer3/LineEdit.text)
	dict["storing_speed"] = int($WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer4/LineEdit.text)
	dict["output_losses"] = int($WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer5/LineEdit.text)
	var saved_stuff = File.new()
	saved_stuff.open("%s//templates/%s" % [OS.get_user_data_dir(), $WindowDialog/PanelContainer/TabContainer/Storage/VBoxContainer/HBoxContainer6/LineEdit.text], File.WRITE)
	saved_stuff.store_line(to_json(dict))
