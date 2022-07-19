#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var game_title: Label = $"MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/Tittle"


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	game_title.text = GameResources.get_game_tittle().to_upper()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
 

#  [SIGNAL_METHODS]


func _on_Easy_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.EASY
	get_tree().change_scene("res://game/game.tscn")


func _on_Medium_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.MEDIUM
	get_tree().change_scene("res://game/game.tscn")


func _on_Hard_pressed() -> void:
	ChangeLevel.request_mode = ChangeLevel.GameMode.HARD
	get_tree().change_scene("res://game/game.tscn")
