extends TextureRect

class_name Bullet
signal card_moved(card)

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

	
func get_drag_data(_position: Vector2):
	emit_signal("card_moved", self)
	
	if not dropped_on_target:
		var data = {}
		data["origin_texture"] = texture
		
		data["bullet"] = self
		
		data["original_position"] = get_global_mouse_position()
		
		#var dragPreview = DragPreview.new()
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.rect_size = Vector2(100,100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size	
		set_drag_preview(control)
		return data

func can_drop_data(position, data):
	return true
	
	
func drop_data(position, data):
	#texture = null

	pass
	

	
