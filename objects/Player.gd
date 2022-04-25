extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3.ZERO
var speed = 500
var gravity = 100

var isholdsomething = false
var hold_node = null
var isinaction = false
var item_index_used = 1

onready var indicator = get_node("/root/World/Indicator")
onready var indicator_front = get_node("/root/World/Indicator/Indicator_Front")
onready var indicator_front_lower = get_node("/root/World/Indicator/Indicator_Front_Lower")
onready var grid_map = get_node("/root/World/Dynamic_Node/GridMap")

signal char_vel_moved(velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !isinaction :
		get_input_move()
		if !is_on_floor():
			velocity.y -= gravity *delta
		move_and_slide(velocity * delta * speed)
		if velocity.x != 0 or velocity.z != 0 :
			$AnimatedCharacter/AnimationPlayer.play("Run")
			emit_signal("char_vel_moved", velocity)
		else:
			$AnimatedCharacter/AnimationPlayer.play("Idle")
		if hold_node != null and isholdsomething:
			hold_node.global_transform.origin = $Position_Hold_Item.global_transform.origin
			
		get_input_action()
	
func get_input_move():
	velocity = Vector3.ZERO
	if Input.is_action_pressed("D"):
		velocity.x = 1
	if Input.is_action_pressed("A"):
		velocity.x = -1
	if Input.is_action_pressed("S"):
		velocity.z = 1
	if Input.is_action_pressed("W"):
		velocity.z = -1
	if velocity != Vector3.ZERO :
		rotation_degrees.y = rad2deg(Vector2(0, 0).angle_to_point(Vector2(-velocity.x, velocity.z)))

func get_input_action() :
	var scan_indicator_front = indicator_front.get_overlapping_bodies()
	var scan_indicator_front_lower = indicator_front_lower.get_overlapping_bodies()
	if Input.is_action_just_released("E"):
		if !isholdsomething :
			if scan_indicator_front.size() == 0 and scan_indicator_front_lower.size() > 0 :
				if Global.inventory[Global.player["item_index_used"]]["item_id"] == "hoe" :
					isinaction = true
					$AnimatedCharacter/AnimationPlayer.play("HeavyAttack")
					yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
					var cell_pos = indicator_front_lower.global_transform.origin
					cell_pos -= Vector3(0.5, 0, 0.5)
					var cell_item = grid_map.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z)
					if grid_map.mesh_library.get_item_name(cell_item) == "Tile_Grass":
						grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, grid_map.mesh_library.find_item_by_name("Tile_Dirt"))
					isinaction = false
				elif Global.inventory[Global.player["item_index_used"]]["item_id"] == "watercan" :
					isinaction = true
					$AnimatedCharacter/AnimationPlayer.play("Attack(1h)")
					yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
					var cell_pos = indicator_front_lower.global_transform.origin
					cell_pos -= Vector3(0.5, 0, 0.5)
					var cell_item = grid_map.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z)
					if grid_map.mesh_library.get_item_name(cell_item) == "Tile_Dirt":
						grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, grid_map.mesh_library.find_item_by_name("Tile_Wet_Dirt"))
					isinaction = false
	elif Input.is_action_just_released("ui_select"):
		var take_item = null
		for body in scan_indicator_front:
			if body != self:
				take_item = body
		if take_item != null and take_item.has_method("interact"):
			take_item.interact()
		else:
			if !isholdsomething :
				if take_item != null:
					isinaction = true
					$AnimatedCharacter/AnimationPlayer.play("PickUp")
					yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
					isholdsomething = true
					hold_node = take_item
					isinaction = false
			else :
				if scan_indicator_front.size() == 0 and scan_indicator_front_lower.size() > 0 :
					isinaction = true
					$AnimatedCharacter/AnimationPlayer.play("PickUp")
					yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
					isholdsomething = false
					hold_node.global_transform.origin = indicator_front.global_transform.origin
					hold_node = null
					isinaction = false
