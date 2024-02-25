extends Control

@onready var 分数文本 = $"分数框/分数文本"
@onready var 速度动画 = $"速度显示框/速度动画"
@onready var 分数改变动画 = $"分数框/分数改变动画"

####################
@onready var 时间倒计时 = $"圆弧进度条/倒计时"
@onready var 倒数时间 = $"圆弧进度条/倒数时间"
@onready var 进度条倒计时 = $"圆弧进度条/进度条倒计时"
@onready var 时间进度条 = $"圆弧进度条/时间进度条"
#####################
@onready var 达到2000分 = $"动画小人/不错不错，2000分了"

@onready var 小人动画 = $"../GUI/动画小人/动漫小人动画"
#动画小人状态切换
var 受伤中 = false

var 增加得分中 = false

var 得分:int = 0
var lines:int = 0
var 增加得分 = 0
var 统计值:int = 0
	
func _ready():
	统计值 = 0
	时间倒计时.start()
	$"分数框/振动".emitting = false
	时间进度条.value = 统计值
	
func _process(delta):
	$"../游戏暂停菜单/暂停菜单/暂停菜单得分".text = str(得分)
	分数文本.text = str(得分) 
	倒数时间.text = "%02d:%02d" % 左侧_时间_倒计时()  #%是取模操作，%02d在字符串中是占位符
	时间进度条.value = 统计值
	小人_动画_改变()
	
func 左侧_时间_倒计时():
	var 左侧_时间 = 时间倒计时.time_left #time left可取出剩余时间
	var 分钟 = floor(左侧_时间 / 60) #分钟是剩余时间除以60
	var 秒 = int(左侧_时间) % 60 #秒是取模出60
	return [分钟, 秒]

func _on_进度条倒计时_timeout():
	统计值 += 1
	if 统计值 >= 237:
		进度条倒计时.stop()

#消行之后显示已消行的数
func 增加_消行_总数(value): #这个value将被满行数传递
	lines = value
	增加得分 += Globals.增加_消行_分数[value - 1] #因为是0123 
	
	if 增加得分 == 8000:
		得分 += 500
	if 增加得分 == 14900:
		得分 += 800
	if 增加得分 == 21100:
		得分 += 1100
	if 增加得分 == 31200:
		得分 += 1600

	
	await get_tree().create_timer(0.1).timeout
	增加得分 = 0
		
func 增加_落地_得分():
	得分 += Globals.方块落地分数
	分数改变动画.play("分数改变")
		
func reset():
	lines = 0
	得分 = 0
	分数文本.text = str(得分)

func 小人_动画_改变():
	if 得分 > 2000 and 得分 < 5000:
		if !受伤中:
			动漫_小人_默认2()
	if 得分 >= 5000:
		if !受伤中:
			动漫_小人_鼓舞()
			
	
	
func 动漫_小人_鼓舞():
	小人动画.play("鼓舞")
func 动漫_小人_死了():
	小人动画.play("死了")
func 动漫_小人_受伤了():
	小人动画.play("受伤了")
func 动漫_小人_给力点():
	小人动画.play("给力点")
func 动漫_小人_默认2():
	小人动画.play("默认2")

func 正_受伤中():
	受伤中 = true
	小人动画.play("受伤了")
	
func 没_受伤了():
	小人动画.play("给力点")
	await 小人动画.animation_finished
	小人动画.play("默认无状态")
	await get_tree().create_timer(5).timeout
	受伤中 = false



func _on_闲聊计时器_timeout():
	$"动画小人/闲聊".play()
