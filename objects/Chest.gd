extends KinematicBody

var slot = {}

func _ready():
	for i in 18:
		slot[(i+1)] = {
			"item_id": null,
			"item_qty": 0,
		}

func interact():
	GUI.open_chest(self)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"global_transform" : global_transform,
		"slot" : slot,
	}
	return save_dict
