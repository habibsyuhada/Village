extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var ItemBox
var itembox_placement = Vector2(64, 64)
var itembox_spacing = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup_inventory():
	var itembox_data = ItemBox.instance()
	for v in 3:
		var itembox_position = itembox_placement
		itembox_position.y = itembox_placement.y + v*itembox_data.rect_size.y + v*itembox_spacing
		for h in 6:
			var itembox = ItemBox.instance()
			itembox.name = "itembox"+str(h)
			itembox_position.x = itembox_placement.x + h*itembox.rect_size.x + h*itembox_spacing
			itembox.rect_position = itembox_position
			if h == 0 :
				itembox.get_node("Sprite").texture = load("res://assets/sprites/Hoe.png")
			$Inventory.add_child(itembox)
	itembox_data.queue_free()
