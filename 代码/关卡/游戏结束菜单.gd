extends Control

@onready var 结束菜单 = $"结束菜单"
@onready var button = $"结束菜单/Button"
@onready var 失败音乐 = $"../音效/失败音乐"

func _ready():
	结束菜单.hide()

func 结束_游戏_菜单():
	get_tree().paused = true
	结束菜单.show()

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://代码/主菜单/选择关卡界面.tscn")

