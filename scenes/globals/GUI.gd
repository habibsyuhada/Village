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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func toogle_menu(status):
	if status == true:
		var menu = Menu.instance()
		add_child(menu)
		menu.connect("_on_Close_Menu_Button_button_up", self, "_on_Close_Menu_Button_button_up")
	else:
		var menu = get_node_or_null("Menu")
		if menu != null:
			menu.disconnect("_on_Close_Menu_Button_button_up", self, "_on_Close_Menu_Button_button_up")
			menu.queue_free()
		
func toogle_hud(status):
	if status == true:
		var hud = HUD.instance()
		add_child(hud)
		hud.connect("_on_Menu_Button_button_up", self, "_on_Menu_Button_button_up")
	else: 
		var hud = get_node_or_null("HUD")
		if hud != null:
			hud.disconnect("_on_Menu_Button_button_up", self, "_on_Menu_Button_button_up")
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
				itembox.item_id = Global.inventory[no]["item_id"]
				itembox.item_qty = Global.inventory[no]["item_qty"]
				$Menu/Inventory.add_child(itembox)
		itembox_data.queue_free()


func _on_Menu_Button_button_up():
	toogle_hud(false)
	toogle_menu(true)
	setup_inventory()

func _on_Close_Menu_Button_button_up():
	toogle_hud(true)
	toogle_menu(false)
