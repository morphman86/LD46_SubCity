extends Node2D

var blob1 = load("res://Instances/Enemies/Blob1.tscn").duplicate()
var blob2 = load("res://Instances/Enemies/Blob2.tscn").duplicate()

func _on_Timer_timeout():
	if get_tree().get_nodes_in_group("player").size() > 0:
		var i_blob = null
		if randi() % 100 > 90:
			i_blob = blob2.instance()
		else:
			i_blob = blob1.instance()
		var width = ProjectSettings.get_setting("display/window/size/width")
		i_blob.position = Vector2(randi() % width, -2)
		add_child_below_node(get_tree().get_root().get_node("Game/Enemies"),i_blob)
	else:
		var reset_button = get_node("GOContainer/GridContainer")
		reset_button.show()
		get_node("Timer").stop()

func _on_Button_pressed():
	get_tree().reload_current_scene()
