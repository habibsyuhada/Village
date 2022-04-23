extends Node

var inventory = {}
var dynamic_node = null
var save_path = "user://file.save"
var save_path_dynamic_node = "user://dynamic_node.save"

func _ready():
	var file = File.new()
	if file.file_exists(save_path):
		load_data()
	else:
		first_setup()
	
func first_setup():
	for i in 18:
		if i == 0 :
			inventory[(i+1)] = {
				"item_id": "hoe",
				"item_qty": 1,
			}
		elif i == 1 :
			inventory[(i+1)] = {
				"item_id": "watercan",
				"item_qty": 1,
			}
		else:
			inventory[(i+1)] = {
				"item_id": null,
				"item_qty": 0,
			}

func save_data():
	dynamic_node = get_node("/root/World/Dynamic_Node")
	
	var save_file = {
		"inventory": inventory,
	}
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_var(save_file)
	file.close()
	
	file.open(save_path_dynamic_node, File.WRITE)
	file.store_var(dynamic_node, true)
	print(dynamic_node)
	file.close()
	print("GAME FILE SAVED")

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var save_file = file.get_var()
		file.close()
		inventory = save_file["inventory"]
		print("GAME FILE LOADED")
	
	if file.file_exists(save_path_dynamic_node):
		file.open(save_path_dynamic_node, File.READ)
		var save_file = file.get_var(true)
		file.close()
		print(save_file)
		print("GAME FILE LOADED")

func waits(s):
	var t = Timer.new()
	t.one_shot = true
	self.add_child(t)
	t.start(s)
	yield(t, "timeout")
	t.queue_free()

func update_invetory(data):
	if data.has("key") :
		var form_data = {
			"item_id" : "",
			"item_qty" : null,
		}
		if data.has("item_id") :
			form_data["item_id"] = data["item_id"]
		if data.has("item_qty") :
			form_data["item_qty"] = data["item_qty"]
		
		inventory[data["key"]] = {
			"item_id": form_data["item_id"],
			"item_qty": form_data["item_qty"],
		}
		
func save_inventory_local():
	for member in get_tree().get_nodes_in_group("ItemBox"):
		print(member.name)
