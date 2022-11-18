extends TextureRect
class_name Target

signal failed_attempt(bullet, target)
signal successfull_attempt(bullet, target)

var matching_id: int \
		setget set_matching_id, get_matching_id
var _front_image = null \
		setget set_front_image, get_front_image
var _subtitle: String = "#legenda" \
		setget set_subtitle, get_subtitle 
		

onready var subtitle_label := $Subtitle

# Called when the node enters the scene tree for the first time.
func _ready():
	#add_to_group("DRAGGABLE")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_subtitle(new_subtitle: String) -> void:
	_subtitle = new_subtitle
	subtitle_label.visible = true
	subtitle_label.text =  new_subtitle

func get_subtitle() -> String:
	return _subtitle
	
func set_matching_id(id):
	matching_id = id
	
func get_matching_id():
	return matching_id 
	
func set_front_image(new_front_image) -> void:
	_front_image = new_front_image
	texture = new_front_image


func get_front_image():
	return _front_image

	
func can_drop_data(position, data):
	return true

		
func drop_data(position, data):
	if (self.matching_id == data["bullet"].matching_id):
		data["bullet"].dropped_on_target = true
		print("match")
		emit_signal("successfull_attempt",data["bullet"], self)
	else:
		print(data["original_position"])
		#data["bullet"].set_position(data["original_position"])
		emit_signal("failed_attempt",data["bullet"], self)
		
	print(data)
	#texture = (data["origin_texture"])
	
	
	pass
	
