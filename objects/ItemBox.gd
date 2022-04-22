extends ColorRect


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
			$Sprite.position = default_position

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_drag:
		$Sprite.position = get_global_mouse_position() + grabbed_offset

