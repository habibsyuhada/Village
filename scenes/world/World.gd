extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var indicator_tile = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("char_vel_moved", self, "char_vel_moved")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	pass
	
func char_vel_moved(player_velocity):
	var player_position = $Player.global_transform.origin
	var indicator_position = $Player.global_transform.origin
	
	indicator_position.x = (ceil(player_position.x / indicator_tile) - 0.5) * indicator_tile
	indicator_position.z = (ceil(player_position.z / indicator_tile) - 0.5) * indicator_tile
	if player_velocity.x > 0 :
		indicator_position.x = (ceil(player_position.x / indicator_tile) + 0.5) * indicator_tile
	elif player_velocity.x < 0 :
		indicator_position.x = (ceil(player_position.x / indicator_tile) - 1.5) * indicator_tile
	if player_velocity.z > 0 :
		indicator_position.z = (ceil(player_position.z / indicator_tile) + 0.5) * indicator_tile
	elif player_velocity.z < 0 :
		indicator_position.z = (ceil(player_position.z / indicator_tile) - 1.5) * indicator_tile
		
	$Indicator.global_transform.origin = indicator_position
