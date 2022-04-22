extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector3.ZERO
var speed = 750

var isholdsomething = false
var hold_node = null
var isinaction = false

onready var indicator = get_node("/root/World/Indicator")

signal char_vel_moved(velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !isinaction :
		get_input_move()
		move_and_slide(velocity * delta * speed)
		if velocity != Vector3.ZERO :
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
	if Input.is_action_just_released("ui_select"):
		if !isholdsomething :
			var scan_bodies = indicator.get_overlapping_bodies()
			var take_item = null
			for body in scan_bodies:
				if body != self:
					take_item = body
			
			if take_item != null:
				isinaction = true
				$AnimatedCharacter/AnimationPlayer.play("PickUp")
				yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
				isholdsomething = true
				hold_node = take_item
				isinaction = false
		else :
			var scan_bodies = indicator.get_overlapping_bodies()
			if scan_bodies.size() == 0 :
				isinaction = true
				$AnimatedCharacter/AnimationPlayer.play("PickUp")
				yield($AnimatedCharacter/AnimationPlayer, "animation_finished")
				isholdsomething = false
				hold_node.global_transform.origin = indicator.global_transform.origin
				hold_node = null
				isinaction = false
