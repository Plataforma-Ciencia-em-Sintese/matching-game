#tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]
signal add_cards
#signal failed_attempt

signal start_timer
signal show_panel_information


#  [ENUMS]
enum GameMode {EASY, MEDIUM, HARD}


#  [CONSTANTS]
#const CardButton := preload("res://game/card_button.tscn")


#  [EXPORTED_VARIABLES]


#  [PUBLIC_VARIABLES]
var failed_attempt: int = 0
var successfull_attempt: int = 0
var total_cards: int = 0
#  [PRIVATE_VARIABLES]

var _bullets: Array = Array() \
		setget set_bullets, get_bullets
		
		
var _targets: Array = Array() \
		setget set_targets, get_targets


var _current_mode: int = GameMode.EASY \
		setget set_current_mode, get_current_mode
var turned_cards: Array = Array()
var _timer_has_started: bool = false \
		setget set_timer_has_starded, get_timer_has_started
var _timer_counter: int = int() \
		setget set_timer_counter, get_timer_counter


#  [ONREADY_VARIABLES]
onready var CardButton := preload("res://game/card/card.tscn")
onready var BulletButton := preload("res://game/bullet/bullet.tscn")
onready var TargetButton := preload("res://game/target/target.tscn")
onready var HowToPlay := preload("res://how_to_play/how_to_play.tscn")
#onready var grid := $"MarginContainer/VBoxContainer/GameContainer/MarginContainer/GridContainer"
onready var bullets := $"MarginContainer/VBoxContainer/GameContainer/MarginContainer/VSplitContainer/bullets"

onready var targets := $"MarginContainer/VBoxContainer/GameContainer/MarginContainer/VSplitContainer/targets"
onready var deck = $deck

onready var timer_label := $"MarginContainer/VBoxContainer/BarContainer/Container/Time"
onready var level_label := $"MarginContainer/VBoxContainer/BarContainer/Container/Level"
onready var timer:= $Timer
onready var bar_container := $"MarginContainer/VBoxContainer/BarContainer"
onready var dev_mode = $DevMode
onready var fullscreen = $"MarginContainer/VBoxContainer/BarContainer/FullScreen"
onready var panel_information = $PanelInformation
onready var total_stars = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/CongratulationsContainer/TotalStars
onready var total_time = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/TimeContainer/TotalTime
onready var total_attempts = $PanelInformation/GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/StatisticsContainer/AttemptsContainer/TotalAttempts
onready var show_panel_information := $ShowPanelInformation

onready var tween = $Tween

onready var resultados = $painelDeResultados
#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
func _ready() -> void:
	_load_theme()
	connect("add_cards", self, "_on_add_cards")
	connect("failed_attempt", self, "_on_failed_attempt")
	connect("successfull_attempt", self, "_on_successfull_attempt")
	connect("start_timer", self, "_on_start_timer")
	connect("show_panel_information", self, "_on_show_PanelInformation")
	set_current_mode(ChangeLevel.request_mode)
	
	get_tree().get_root().connect("size_changed", self, "_on_window_size_changed")
	_toggle_fullscreen_button_icon()

	print("rodando...")
#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("dev_mode"):
		dev_mode.visible = !dev_mode.visible


#func _process(_delta: float) -> void:
#	pass


#  [PUBLIC_METHODS]
func set_bullets(new_bullets: Array) -> void:
	print("definindo bullets"+ str(new_bullets.size()))
	for bullet in new_bullets:
		_bullets.append(bullet)

func get_bullets() -> Array:
	return _bullets
	
func set_targets(new_targets: Array) -> void:
	for target in new_targets:
		_targets.append(target)

func get_targets() -> Array:
	return _targets

func set_current_mode(mode: int) -> void:
	_current_mode = mode
		
	get_bullets().clear()
	get_targets().clear()

	print("pre-removendo resultados")
	for child in resultados.get_children():
		print("removendo resultados")
		child.queue_free()
	print("pre-removendo bullets")
	for child in bullets.get_children():
		print("removendo bullets")
		child.queue_free()
	
	for child in targets.get_children():
		print("removendo targets")
		child.queue_free()
		
	print("bullets")
	#print(API.game.get_bullets())
	print("targets")
	#print(API.game.get_targets())
	set_bullets(API.game.get_bullets())
	set_targets(API.game.get_targets())	
	match(mode):
		GameMode.EASY:
			level_label.text = "Fácil"			
			_make_grid(get_current_mode())

		GameMode.MEDIUM:
			level_label.text = "Médio"
			_make_grid(get_current_mode())
			
		GameMode.HARD:
			level_label.text = "Difícil"
			_make_grid(get_current_mode())
	show_cards(0.5)



func get_current_mode() -> int:
	return _current_mode


func set_timer_has_starded(new_value: bool) -> void:
	_timer_has_started = new_value


func get_timer_has_started() -> bool:
	return _timer_has_started


func set_timer_counter(new_value: int) -> void:
	_timer_counter = new_value


func get_timer_counter() -> int:
	return _timer_counter

func get_target_by_matching_id(matching_id) -> Dictionary:
	print("buscando "+ str(matching_id))
	var alvo
	for target in get_targets():
		if target["matching_id"] == matching_id:
			alvo = target
		
	
	return alvo

func random_bullet() -> Dictionary:
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.randomize()
	
	var random_index: int = random.randi_range(0, get_bullets().size() -1)

	var result: Dictionary = get_bullets()[random_index]
	get_bullets().remove(random_index)
	
	return result # {subtitle: String, texture: ImageTexture}


func random_target() -> Dictionary:
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.randomize()
	
	var random_index: int = random.randi_range(0, get_targets().size() -1)

	var result: Dictionary = get_targets()[random_index]
	get_targets().remove(random_index)
	
	return result # {subtitle: String, texture: ImageTexture}
	
func shuffle_cards() -> void:
	var steps: int = 2
	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	
	for _i in range(0, steps):
		for card in bullets.get_children():
			var temporary_position: Vector2 = Vector2(0.0, 0.0)
			
			#var ramdom_card := grid.get_child(random_number(0, grid.get_children().size()-1))
			randomize()
			random.randomize()
			var ramdom_card := bullets.get_child(random.randi_range(0, bullets.get_children().size()-1))
			
			temporary_position = card.get_position()
			card.set_position(ramdom_card.get_position())
			ramdom_card.set_position(temporary_position)
			
			var temporary_index: int = card.get_position_in_parent()
			bullets.move_child(card, ramdom_card.get_position_in_parent())
			bullets.move_child(ramdom_card, temporary_index)
			
			
		for card in targets.get_children():
			var temporary_position: Vector2 = Vector2(0.0, 0.0)			
			randomize()
			random.randomize()
			var ramdom_card := targets.get_child(random.randi_range(0, targets.get_children().size()-1))
			
			temporary_position = card.get_position()
			card.set_position(ramdom_card.get_position())
			ramdom_card.set_position(temporary_position)
			
			var temporary_index: int = card.get_position_in_parent()
			targets.move_child(card, ramdom_card.get_position_in_parent())
			targets.move_child(ramdom_card, temporary_index)
			

func show_cards(time: float) -> void:
	
	print("mostrando cartas")
	yield(get_tree().create_timer(time), "timeout")
	print(targets.get_children())
	for card in targets.get_children():
		print("mostrando targets")
		#if card.get_state() == card.State.FRONT:
		#	card.turn_animation()
	for card in bullets.get_children():
		print("mostrando bullets")
		#if card.get_state() == card.State.FRONT:
		#	card.turn_animation()

#  [PRIVATE_METHODS]
func _load_theme() -> void:
	timer_label.set("custom_colors/font_color", API.theme.get_color(API.theme.PD1))
	var state_normal: StyleBoxFlat = timer_label.get("custom_styles/normal")
	state_normal.set("border_color", API.theme.get_color(API.theme.PD1))




func _make_grid(mode: int):
	var card_size: Vector2 = Vector2.ZERO
	
	resultados.visible = false
	match(mode):
		GameMode.EASY:
			#grid.columns = 4
			total_cards = 4
			targets.columns = 2
			bullets.columns = 2
			card_size = Vector2(300, 300) #Vector2(256, 256)
		GameMode.MEDIUM:
			#grid.columns = 5
			targets.columns = 4
			bullets.columns = 4
			total_cards = 16
			card_size = Vector2(300, 200) #Vector2(200, 200)
		GameMode.HARD:
			#grid.columns = 6
			targets.columns = 5
			bullets.columns = 5
			total_cards = 20
			card_size = Vector2(250,200) #Vector2(180, 180)
			
	print("limpando deck")
	deck.get_children().clear()
# warning-ignore:integer_division
	for i in range(0, (total_cards/2)): # number of cards divided by 2 insertions		
		var bullet: Dictionary = random_bullet()		
		
		var new_card := BulletButton.instance()
		bullets.add_child(new_card)
		new_card.rect_min_size = card_size
		new_card.set_matching_id(bullet["matching_id"])
		if bullet.has("image"):
			new_card.set_front_image(bullet["image"])
			
			new_card.connect("card_moved", self, "_on_card_moved")		
			
	
		var target: Dictionary =  get_target_by_matching_id(bullet["matching_id"])# random_target()		
		
		var new_card_target := TargetButton.instance()
		targets.add_child(new_card_target)
		new_card_target.rect_min_size = card_size
		new_card_target.set_matching_id(target["matching_id"])
		if target.has("image"):
			new_card_target.set_front_image(target["image"])
			new_card_target.connect("failed_attempt", self, "_on_failed_attempt")	
			new_card_target.connect("successfull_attempt", self, "_on_successfull_attempt")	
		if target.has("subtitle"):	
			print("definindo legenda")
			new_card_target.set_subtitle(target["subtitle"])	
			#new_card_target.connect("card_moved", self, "_on_card_moved")		
	emit_signal("add_cards")


func _on_card_moved(card_instance) -> void:
	emit_signal("start_timer")
	print("movendo card")	
	card_instance.modulate.a = 0

func _on_failed_attempt(bullet, target) -> void:
	print("nao combinou")	
	bullet.modulate.a = 1
	failed_attempt += 1
	

func _on_successfull_attempt(bullet, target) -> void:
	bullets.remove_child(bullet)
	targets.remove_child(target)
	resultados.add_child(target)
	resultados.add_child(bullet)
	
	
	bullet.modulate.a = 1
	successfull_attempt += 1
	#bullet.set_position(Vector2(-220,0))
	#bullet.set_position(target.get_position())
	
	var timeTween = create_tween()
	print(self.rect_global_position)
	
	timeTween.tween_property(bullet, "rect_global_position", OS.get_screen_size()/2 + Vector2(0,-250), 0.1)
	timeTween.tween_property(target, "rect_global_position", OS.get_screen_size()/2 + Vector2(-450,-250), 0.1)
	timeTween.parallel().tween_property(bullet, "rect_size",  Vector2(400,400), 0.1)
	timeTween.parallel().tween_property(target, "rect_size",  Vector2(400,400), 0.1)
	timeTween.tween_property(bullet, "rect_global_position", OS.get_screen_size()/2 + Vector2(0,-250), 0.2)
	timeTween.tween_property(target, "rect_global_position", OS.get_screen_size()/2 + Vector2(-450,-250), 0.2)
	timeTween.tween_property(bullet, "modulate:a",0.0 , 0.2)
	timeTween.tween_property(target, "modulate:a",0.0 , 0.2)
	#timeTween.tween_property(bullet, "rect_global_position",  Vector2(-2200,-2050), 0.001)
	#timeTween.tween_property(target, "rect_global_position",  Vector2(-2200,-2050), 0.001)

	resultados.visible = true
	#yield(timeTween, 'tween_completed')
	#bullet.set_position(Vector2(-2200,-2000))
	
	yield(get_tree().create_timer(1), "timeout")
	resultados.visible = false
	resultados.remove_child(target)
	resultados.remove_child(bullet)
	deck.add_child(target)
	deck.add_child(bullet)
	
	#target.set_position(Vector2(-220,0))
	print("combinou" + str(successfull_attempt)+ " de "+  str(total_cards/2) )
	is_full_level()
		
	#var restart_button: Button = $MarginContainer/VBoxContainer/BarContainer/Restart
	
func _reset_counters() -> void:
	timer.stop()
	set_timer_has_starded(false)
	set_timer_counter(0)
	yield(get_tree().create_timer(1.0), "timeout") # temporary until set theme template
	timer_label.text = "00:00"
	failed_attempt = 0
	successfull_attempt = 0

func _toggle_fullscreen_button_icon() -> void:
	var fullscreen_on: String = ""
	var fullscreen_off: String = ""
	match(OS.window_fullscreen):
		true:
			fullscreen.text = fullscreen_off
		false:
			fullscreen.text = fullscreen_on

func _scoring_rules() -> int:
	var target_attempt: int = 0
	var margin_attempt: int = 0
	var target_time: int = 0
	var margin_time: int = 0
	var stars: int = 0
	var stars_check: bool = false
	
	match(get_current_mode()):
		GameMode.EASY:
			target_attempt = 10
			margin_attempt = 5
			target_time = 40
			margin_time = 10
			
		GameMode.MEDIUM:
			target_attempt = 20
			margin_attempt = 5
			target_time = 70
			margin_time = 10
			
		GameMode.HARD:
			target_attempt = 30
			margin_attempt = 5
			target_time = 90
			margin_time = 10
	
	# three stars
	if get_timer_counter() < target_time and failed_attempt < target_attempt:
		if not stars_check:
			stars = 3
			stars_check = true
	
	# two stars
	elif get_timer_counter() < (target_time + margin_time) and failed_attempt < (target_attempt + margin_attempt):
		if not stars_check:
			stars = 2
			stars_check = true
	
	# one stars
	elif (get_timer_counter() < (target_time + margin_time) and failed_attempt > (target_attempt + margin_attempt)) or \
			(get_timer_counter() > (target_time + margin_time) and failed_attempt < (target_attempt + margin_attempt)):
		if not stars_check:
			stars = 1
			stars_check = true
	
	# zero stars
	elif get_timer_counter() > (target_time + margin_time) and failed_attempt > (target_attempt + margin_attempt):
		if not stars_check:
			stars = 0
			stars_check = true
	
	var first_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/First")
	var second_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/Second")
	var third_star: Label = panel_information.get_node("GlobalContainer/MarginContainer/VBoxContainer/HBoxContainer/ResultContainer/RecordContainer/Stars/Third")
	match(stars):
		0:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		1:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		2:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.LIGHTGRAY))
		3:
			first_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			second_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
			third_star.set("custom_colors/font_color", API.theme.get_color(API.theme.GREEN))
	
	return stars


func _update_panel_information() -> void:
	var color_bbtext: String = str(API.theme.get_color(API.theme.PB).to_html(false))
	total_stars.bbcode_text = str("Você completou o nível!\nConseguiu [color=#" + color_bbtext + "][b]" + str(_scoring_rules()) + "[/b][/color] estrelas.")
	total_time.text = timer_label.text
	total_attempts.text = str(failed_attempt)


#  [SIGNAL_METHODS]
func _on_window_size_changed() -> void:
	dev_mode.visible = false
	_toggle_fullscreen_button_icon()


func _on_add_cards() -> void:
	shuffle_cards()

func _on_start_timer() -> void:
	if not get_timer_has_started():
		set_timer_has_starded(true)
		timer.start()

func mostra_resultados():
	resultados.visible = false
	print("o deck")		
	for i in deck.get_children():
		print("adding resultados final")
		i.modulate.a = 1
		i.visible = true
		deck.remove_child(i)
		resultados.add_child(i)

func esconde_resultados():
	resultados.visible = false
	print("o deck")		
	for i in resultados.get_children():
		print("escondendo resultados final")
		i.modulate.a = 0		
		resultados.remove_child(i)
		deck.add_child(i)
		
func is_full_level() -> void:
	if successfull_attempt == total_cards/2:				
		mostra_resultados()
		emit_signal("show_panel_information")
		


func _on_Restart_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_bullets(Array())
		set_targets(Array())
		set_current_mode(get_current_mode())


func _on_Timer_timeout() -> void:
	var seconds: int = get_timer_counter()
	seconds += 1
	set_timer_counter(seconds)
	
# warning-ignore:integer_division
# warning-ignore:integer_division
# warning-ignore:integer_division
	timer_label.text = "%02d:%02d" % [(seconds/60) % 60, seconds % 60]


func _on_Home_pressed() -> void:
	get_tree().change_scene("res://home/home.tscn")


func _on_DevLevel1_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.EASY)


func _on_DevLevel2_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.MEDIUM)


func _on_DevLevel3_pressed() -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_current_mode(GameMode.HARD)


func _on_FullScreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
	_toggle_fullscreen_button_icon()


func _on_show_PanelInformation() -> void:
	timer.stop()

	_update_panel_information()
	panel_information.visible = true


func _on_PanelInformation_Restart_pressed() -> void:
	panel_information.visible = false
	yield(get_tree().create_timer(0.5), "timeout")
	if turned_cards.empty():
		_reset_counters()
		set_bullets(Array())
		set_targets(Array())
		set_current_mode(get_current_mode())


func _on_PanelInformation_Skip_pressed() -> void:
	_reset_counters()
	
	match(get_current_mode()):
		GameMode.EASY:
			set_current_mode(GameMode.MEDIUM)
		GameMode.MEDIUM:
			set_current_mode(GameMode.HARD)
		GameMode.HARD:
			set_current_mode(GameMode.EASY)
	
	panel_information.visible = false


func _on_Hide_pressed() -> void:
	for child in bar_container.get_children():
		if child is Button:
			child.disabled = true
			
	panel_information.visible = false
	show_panel_information.visible = true
	print("mostrando rsults")
	mostra_resultados()


func _on_ShowPanelInformation_pressed() -> void:
	for child in bar_container.get_children():
		if child is Button:
			child.disabled = false
	show_panel_information.visible = false
	panel_information.visible = true
	
	print("escondendo rsults")
	esconde_resultados()


func _on_Help_pressed() -> void:
	timer.stop()
	var how_to_play := HowToPlay.instance()
	add_child(how_to_play)
	how_to_play.connect("close", self, "_on_HowToPlay_close")


func _on_HowToPlay_close() -> void:
	if get_timer_counter() > 0:
		timer.start()
