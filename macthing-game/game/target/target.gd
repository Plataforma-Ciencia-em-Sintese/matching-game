extends TextureRect
class_name Target

var dropped_on_target : bool = false
var matching_id: int \
		setget set_matching_id, get_matching_id
var _front_image = null \
		setget set_front_image, get_front_image
		
# Called when the node enters the scene tree for the first time.
func _ready():
	#add_to_group("DRAGGABLE")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	if (self.matching_id == data["bullet"].matching_id):
		return true
	else:
		return false	

		
func drop_data(position, data):
	print(data)
	texture = (data["origin_texture"])
	
	#data["bullet"].set_position(self.get_position() + Vector2(100, 0))
	data["bullet"].texture = null
	print("mudando posicao de " + str(self.get_position() + Vector2(100, 0)))
	pass
	
