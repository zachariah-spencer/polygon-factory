extends Node2D


func save():
	var save_dict = {
		'filename' : get_scene_file_path(),
		'parent' : get_parent().get_path(),
		'pos_x' : position.x,
		'pos_y' : position.y,
		'polygons' : Stats.current_polygons,
		'total_polygons' : Stats.total_polygons,
		'upgrade_tier' : Stats.upgrade_tier,
		'polygons_per_minute' : Stats.polygons_per_minute
	}
	return save_dict

func load(node_data : Dictionary):
	print(node_data)
# Now we set the remaining variables.
	#for i in node_data.keys():
		#if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			#continue
		#set(i, node_data[i])
	Stats.current_polygons = node_data['polygons']
	Stats.total_polygons = node_data['total_polygons']
	Stats.upgrade_tier = node_data['upgrade_tier']
	Stats.polygons_per_minute = node_data['polygons_per_minute']
	Stats.polygons_changed.emit()
