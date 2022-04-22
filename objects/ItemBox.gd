extends ColorRect

var sprite_texture = null

var can_drag = false
var grabbed_offset = Vector2()
var default_position = Vector2()

func _ready():
	default_position = $Sprite.position

func _on_ItemBox_gui_input(event):
	if event is InputEventMouseButton:
		can_drag = event.pressed
		grabbed_offset = $Sprite.position - get_global_mouse_position()
		if !event.pressed :
			var closest_distance = null
			var closest_itembox = null
			for member in get_tree().get_nodes_in_group("ItemBox"):
				if member != self :
					var distance = ($Sprite.get_global_transform().origin - member.get_node("Sprite").get_global_transform().origin).length()
					if distance < rect_size.x / 2 :
						if closest_distance == null or closest_distance > distance :
							closest_distance = distance
							closest_itembox = member
			if closest_itembox != null :
				var old_sprite_texture = sprite_texture
				sprite_texture = closest_itembox.sprite_texture
				closest_itembox.sprite_texture = old_sprite_texture
			$Sprite.position = default_position

func _process(delta):
	if $Sprite.texture != null :
		if $Sprite.texture.resource_path != sprite_texture :
			if sprite_texture != null :
				$Sprite.texture = load(sprite_texture)
			else :
				$Sprite.texture = null
	else :
		if sprite_texture != null :
			$Sprite.texture = load(sprite_texture)
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_drag:
		$Sprite.position = get_global_mouse_position() + grabbed_offset

