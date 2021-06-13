extends Node2D

func _ready() -> void:
	pass


func _on_Area2D_mouse_entered() -> void:
	print('in')


func _on_Area2D_mouse_exited() -> void:
	print('out')
