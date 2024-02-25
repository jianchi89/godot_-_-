extends Control

@onready var 游戏暂停菜单 = $"暂停菜单"
@onready var 恢复游戏按钮 = $"恢复游戏"

func  _ready():
	游戏暂停菜单.visible = false

func _on_暂停按钮_pressed():
	get_tree().paused = true
	游戏暂停菜单.visible = true


func _on_恢复游戏_pressed():
	get_tree().paused = false
	游戏暂停菜单.visible = false


func _on_返回关卡_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://代码/主菜单/选择关卡界面.tscn")
