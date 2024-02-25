extends Node2D
@onready var 主菜单动画 = $"主菜单动画"
@onready var 樱之诗关卡 = $"Control/樱之诗关卡"
@onready var 樱之诗_关卡介绍 = $"Control/关卡介绍"
@onready var 关卡图标管理动画 = $"Control/关卡图标管理动画"
@onready var 樱之诗_开始按钮 = $"Control/关卡介绍"
@onready var 按钮音效 = $"按钮音效"
@onready var 主菜单背景音乐 = $AudioStreamPlayer2D
@onready var 预览樱之诗 = $"预览樱之诗"

########
@onready var Recall关卡 = $"Control/Recall关卡"
@onready var 素晴日关卡 = $"Control/素晴日关卡"
@onready var recall关卡介绍 = $"Control/Recall关卡介绍"
@onready var 素晴日关卡介绍 = $"Control/素晴日关卡介绍"


var 按下 = false
var re按下 = false
var 素晴日按下 = false

var 难度等级:int = 0
var 难度切换:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	主菜单动画.play("主菜单动画")
	樱之诗_关卡介绍.hide()
	recall关卡介绍.hide()
	素晴日关卡介绍.hide()
	

func _process(delta):
	难度_变更_检测()
	

func _on_樱之诗关卡_toggled(toggled_on):
	if toggled_on:
		按下 = true
	else:
		按下 = false
	樱_关卡介绍_弹出()

func _on_recall关卡_toggled(toggled_on):
	if toggled_on:
		re按下 = true
	else:
		re按下 = false
	RE_关卡介绍_弹出()

func _on_素晴日关卡_toggled(toggled_on):
	if toggled_on:
		素晴日按下 = true
	else:
		素晴日按下 = false
	素_关卡介绍_弹出()
		
		
func 樱_关卡介绍_弹出():
	if 按下 == true:
		难度切换 = 3
		樱之诗_关卡介绍.show()
		主菜单背景音乐.volume_db = -50
		关卡图标管理动画.play("移动至介绍")
		预览樱之诗.play()
		
	else:
		主菜单背景音乐.volume_db = -10
		关卡图标管理动画.play("返回至列表")
		预览樱之诗.stop()
		
func RE_关卡介绍_弹出():
	if re按下 == true:
		难度切换 = 5
		recall关卡介绍.show()
		主菜单背景音乐.volume_db = -50
		关卡图标管理动画.play("recall移动至介绍")
		$"预览recall".play()
		
	else:
		主菜单背景音乐.volume_db = -10
		关卡图标管理动画.play("recall返回至列表")
		$"预览recall".stop()

func 素_关卡介绍_弹出():
	if 素晴日按下 == true:
		难度切换 = 1
		素晴日关卡介绍.show()
		主菜单背景音乐.volume_db = -50
		关卡图标管理动画.play("素晴日移动至介绍")
		$"预览素晴日".play()
		
	else:
		主菜单背景音乐.volume_db = -10
		关卡图标管理动画.play("素晴日返回至列表")
		$"预览素晴日".stop()
		
func _on_关卡介绍_pressed():
	按钮音效.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://代码/关卡/樱之诗_关卡.tscn")

func _on_recall关卡介绍_pressed():
	$"探索区域".play()


func _on_素晴日关卡介绍_pressed():
	$"探索区域".play()


func _on_检测位置_pressed():
	樱之诗关卡.button_pressed = false
	Recall关卡.button_pressed = false
	素晴日关卡.button_pressed = false


func 难度_变更_检测():
	Globals.难度等级检测 = 难度切换
	if 难度切换 == 1:
		$"Control/弹出难度菜单/难度1-2/难度1".show()
	else:
		$"Control/弹出难度菜单/难度1-2/难度1".hide()
	if 难度切换 == 2:
		$"Control/弹出难度菜单/难度1-2/难度2".show()
	else:
		$"Control/弹出难度菜单/难度1-2/难度2".hide()
	if 难度切换 == 3:
		$"Control/弹出难度菜单/难度1-2/难度3".show()
	else:
		$"Control/弹出难度菜单/难度1-2/难度3".hide()
	if 难度切换 == 4:
		$"Control/弹出难度菜单/难度1-2/难度4".show()
	else:
		$"Control/弹出难度菜单/难度1-2/难度4".hide()
	if 难度切换 == 5:
		$"Control/弹出难度菜单/难度1-2/难度5".show()
	else:
		$"Control/弹出难度菜单/难度1-2/难度5".hide()
		

	

func _on_难度1_pressed():
	难度切换 = 2


func _on_难度2_pressed():
	难度切换 = 1


func _on_难度3_pressed():
	难度切换 = 4

func _on_难度4_pressed():
	难度切换 = 3
