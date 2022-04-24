extends StaticBody


func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"global_transform" : global_transform,
	}
	return save_dict
