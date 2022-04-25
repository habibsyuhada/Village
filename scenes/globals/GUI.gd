extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var HUD
export (PackedScene) var Menu
export (PackedScene) var ItemBox
var itembox_placement = Vector2(64, 64)
var itembox_spacing = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	toogle_hud(true)
	setup_quick_access_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toogle_menu(status):
	if status == true:
		var menu = Menu.instance()
		add_child(menu)
	else:
		var menu = get_node_or_null("Menu")
		if menu != null:
			menu.queue_free()
		
func toogle_hud(status):
	if status == true:
		var hud = HUD.instance()
		add_child(hud)
	else: 
		var hud = get_node_or_null("HUD")
		if hud != null:
			hud.queue_free()

func setup_inventory():
	if get_node_or_null("Menu") != null:
		var itembox_data = ItemBox.instance()
		var no = 0
		for v in 3:
			var itembox_position = itembox_placement
			itembox_position.y = itembox_placement.y + v*itembox_data.rect_size.y + v*itembox_spacing
			for h in 6:
				no += 1
				var itembox = ItemBox.instance()
				itembox.name = "itembox"+str(no)
				itembox_position.x = itembox_placement.x + h*itembox.rect_size.x + h*itembox_spacing
				itembox.rect_position = itembox_position
				itembox.itembox_index = no
				itembox.isdragable = true
				itembox.item_id = Global.inventory[no]["item_id"]
				itembox.item_qty = Global.inventory[no]["item_qty"]
				$Menu/Inventory.add_child(itembox)
		itembox_data.queue_free()
		
func setup_quick_access_inventory():
	itembox_placement = Vector2(16, 16)
	if get_node_or_null("HUD") != null:
		var itembox_data = ItemBox.instance()
		var no = 0
		for v in 1:
			var itembox_position = itembox_placement
			itembox_position.y = itembox_placement.y + v*itembox_data.rect_size.y + v*itembox_spacing
			for h in 6:
				no += 1
				var itembox = ItemBox.instance()
				itembox.name = "itembox"+str(no)
				itembox_position.x = itembox_placement.x + h*itembox.rect_size.x + h*itembox_spacing
				itembox.rect_position = itembox_position
				itembox.itembox_index = no
				itembox.isshowplayerused = true
				itembox.item_id = Global.inventory[no]["item_id"]
				itembox.item_qty = Global.inventory[no]["item_qty"]
				$HUD/Quick_Access_Item.add_child(itembox)
		itembox_data.queue_free()


func open_menu():
	toogle_hud(false)
	toogle_menu(true)
	setup_inventory()
	$Backgroud.visible = true

func open_hud():
	toogle_hud(true)
	toogle_menu(false)
	setup_quick_access_inventory()
	$Backgroud.visible = false
