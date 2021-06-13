extends Node2D


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
