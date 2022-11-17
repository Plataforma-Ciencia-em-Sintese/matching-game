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
onready var level_title: Label = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Options/Panel/Tittle
onready var game_name: Label = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/GameName
onready var logo_background: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer2/Circle
onready var logo_api: TextureRect = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer/Image
onready var panel_logo_api: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer
onready var panel_logo_placeholder: PanelContainer = $MarginContainer/AspectRatioContainer/MarginContainer/GlobalVBoxContainer/Logo/PanelContainer2

#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	
	game_title.text = API.common.get_short_title().to_upper()


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]


#  [PRIVATE_METHODS]
func _load_theme() -> void:
	if API.common.get_game_logo() == null:
		panel_logo_api.visible = false
		panel_logo_placeholder.visible = true
		var logo_background_style: StyleBoxFlat = logo_background.get("custom_styles/panel")
		logo_background_style.set("bg_color", API.theme.get_color(API.theme.PB))
	else:
		panel_logo_api.visible = true
		panel_logo_placeholder.visible = false
		logo_api.texture = API.common.get_game_logo()
			
	var game_name_font: Font = game_name.get("custom_fonts/font")
	game_name_font.set("outline_color", API.theme.get_color(API.theme.PD1))
	
	game_title.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var game_title_state_normal: StyleBoxFlat = game_title.get("custom_styles/normal")
	game_title_state_normal.set("border_color", API.theme.get_color(API.theme.PD1))
	
	level_title.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var level_title_state_normal: StyleBoxFlat = game_title.get("custom_styles/normal")
	level_title_state_normal.set("border_color", API.theme.get_color(API.theme.PD1))

 

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


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://credits/credits.tscn")
