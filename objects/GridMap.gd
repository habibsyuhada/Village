extends GridMap

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"global_transform" : global_transform,
		"grid_cells" : [],
	}
	var cell_item = get_used_cells()
	for cell in cell_item:
		save_dict["grid_cells"].push_back({
			"cell_pos" : cell,
			"cell_item" : get_cell_item(cell.x, cell.y, cell.z),
		})
	return save_dict
