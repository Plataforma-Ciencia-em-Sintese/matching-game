#tool
#class_name Name #, res://class_name_icon.svg
extends Node


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	Api.connect("all_requests_completed", self, "_on_Api_all_requests_completed")


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float)%VOID_RETURN:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]
func _on_Api_all_requests_completed() -> void:
	if Api.get_skip_article():
		get_tree().change_scene("res://game/game.tscn")
	else:
		get_tree().change_scene("res://opening/opening.tscn")
