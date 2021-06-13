extends Node

var standard_type = {
					0: 0.4,
					1: 0.5,
					2: 0.4,
					3: 0.6,
					4: 0.8,
					5: 0.9,
					6: 1.6,
					7: 1.9,
					8: 2.1,
					9: 2.2,
					10: 2.3,
					11: 2.1,
					12: 1.9,
					13: 1.7,
					14: 1.9,
					15: 1.7,
					16: 1.3,
					17: 1.6,
					18: 1.8,
					19: 1.7,
					20: 1.5,
					21: 1.2,
					22: 0.9,
					23: 0.7,
				}

var solars_type = {
					0: 1.4,
					1: 1.5,
					2: 1.4,
					3: 1.6,
					4: 1.8,
					5: 2.9,
					6: 3.6,
					7: 3.9,
					8: 4.1,
					9: 3.2,
					10: 2.3,
					11: 1.1,
					12: 0.1,
					13: -1.7,
					14: -2.2,
					15: -1.7,
					16: 1.3,
					17: 1.6,
					18: 1.8,
					19: 1.7,
					20: 1.5,
					21: 1.2,
					22: 0.9,
					23: 0.7,
				}

var consumption_types = {}

var time_multiplier = 1

var minute = 0
var hour = 0
var day = 0

func add_minute():
	self.minute += 1
	self._handle_time()

func _handle_time():
	if self.minute > 59:
		self.hour += 1
		self.minute = 0
	if self.hour > 23:
		self.hour = 0
		self.day += 1

func get_time():
	if minute < 10:
		return "Day: [%s], %s:0%s" % [day, hour, minute]
	else:
		return "Day: [%s], %s:%s" % [day, hour, minute]


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	return files
