extends Node2D



func _on_开始_pressed():
	get_tree().change_scene_to_file("res://代码/主菜单/选择关卡界面.tscn")
	
func _on_退出_pressed():
	get_tree().quit()
