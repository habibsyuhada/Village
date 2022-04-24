extends Node

var inventory = {}
var save_path = "user://file2.save"

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
	var save_file = {
		"inventory": inventory,
		"dynamic_node": [],
	}
	
	var save_nodes = get_tree().get_nodes_in_group("Saved Object")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		var node_data = node.call("save")
		save_file["dynamic_node"].push_back(node_data)
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_var(save_file)
	file.close()
	print("GAME FILE SAVED")

func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var save_file = file.get_var()
		file.close()
		inventory = save_file["inventory"]
		
		# We need to revert the game state so we're not cloning objects
		# during loading. This will vary wildly depending on the needs of a
		# project, so take care with this step.
		# For our example, we will accomplish this by deleting saveable objects.
		var save_nodes = get_tree().get_nodes_in_group("Saved Object")
		for i in save_nodes:
			i.queue_free()
		# Load the file line by line and process that dictionary to restore
		# the object it represents.
		for node_data in save_file["dynamic_node"]:
			# Firstly, we need to create the object and add it to the tree and set its position.
			var new_object = load(node_data["filename"]).instance()
			get_node(node_data["parent"]).add_child(new_object)
			new_object.global_transform = node_data["global_transform"]
			# Now we set the remaining variables.
			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, node_data[i])
		
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
