extends Node2D
@onready var nextTileMap = $NextTilemap
@onready var next_tilemap = $NextTilemap
@onready var mainTileMap = $"下落TileMap"
@onready var tick = $Tick
@onready var 平移_tick = $"平移_Tick"
@onready var 快速下落_tick = $"快速下落_Tick"
@onready var 快速下落鼓点 = $"音效/快速下落"
@onready var 樱之诗 = $"音效/樱之诗歌曲"

####################################
@onready var 主方框移动 = $"主方框移动"
@onready var 下落Tilemap = $"下落TileMap"
@onready var 垫底Tilemap = $"垫底tilemap"
@onready var 俄罗斯方块背景 = $"俄罗斯方块背景"
#####################################
@onready var 游戏结束菜单 = $"游戏结束菜单"
@onready var gui = $GUI

var 满行消除中 = false

####################
var 储存生命值 = 3
var 生命值 = 3
@onready var 生命条 = $"GUI/生命条"
@onready var 生命条动画 = $"GUI/生命条/生命条变化"
#####################


const START_POS:Vector2 = Vector2(3,-4)
const DISTANCE:Vector2 = Vector2.DOWN

var 下个方块Index:int = 1 #申明一个整数变量
var 下个方块:Array #array为通用数组，此处用以存储字典

var 当前方块Index:int = 1 #当前形状index
var 当前方块:Array #当前形状
var 已落地形状:Array = []

var 平行_移动:int = 0
var 左边界 = false
var 右边界 = false

var 游戏失败 = false

var 快速下落 = false

var 主方框下落中 = false

var status_index:int = 0 #旋转方块的状态

#最终会显示的样子
var 最终_落地_方块:Array = []

func _ready():
	储存生命值 = 3
	下一个形状()
	删除_下个方块()
	绘制_下个方块()
	获取_当前方块()
	绘制_当前方块()
	落地_位置() #获取方块后检测
	删除_下个方块()
	下一个形状()
	绘制_下个方块()
	tick.start()
	
	gui.reset()
	

func _process(delta):
	生命条.value = 生命值
	if Input.is_action_just_pressed("逆时针") or Input.is_action_just_pressed("顺时针"):
		方块_旋转()
		
	if Input.is_action_just_pressed("快速下落"):
		快速下落 = true
	elif Input.is_action_just_released("快速下落"):
		快速下落 = false
		
	平行_移动 = Input.get_action_strength("右移动") - Input.get_action_strength("左移动")
	检测_游戏_失败()
	
	if Input.is_action_just_pressed("直接落地"):
		获取_直接_落地()
	
	if 满行消除中:
		gui.分数改变动画.play("满行分数动画")
		await get_tree().create_timer(0.1).timeout
		满行消除中 = false
	落地后_主框向下()

func 落地后_主框向下():
	if Input.is_action_just_pressed("直接落地"):
		$"俄罗斯方块背景/振动2".emitting = true
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(俄罗斯方块背景,"position", Vector2(俄罗斯方块背景.position.x,393), 0.1)
		tween.parallel().tween_property(下落Tilemap,"position", Vector2(下落Tilemap.position.x,77), 0.1)
		tween.parallel().tween_property(垫底Tilemap,"position", Vector2(垫底Tilemap.position.x,247), 0.1)
		await tween.finished
		var tween1 = get_tree().create_tween()
		tween1.parallel().tween_property(俄罗斯方块背景,"position", Vector2(俄罗斯方块背景.position.x,373.001), 0.1)
		tween1.parallel().tween_property(下落Tilemap,"position", Vector2(下落Tilemap.position.x,67), 0.1)
		tween1.parallel().tween_property(垫底Tilemap,"position", Vector2(垫底Tilemap.position.x,237), 0.1)
		await get_tree().create_timer(0.5).timeout
		$"俄罗斯方块背景/振动2".emitting = false
		
#下一个形状
func 下一个形状():
	randomize() #每一次随机都将不同
	下个方块Index = randi() % 7 + 1 #变量将等于随机
	下个方块 = Globals.所有方块["方块" + str(下个方块Index)] #通过“xx” + str()这个表达式，将构建索引字典
	
	
func 绘制_下个方块():
	for cell in 下个方块:
		nextTileMap.set_cell(-1, cell, 1,Vector2(0,0))#tilemap绘制cell，XY后是使用的图集
		
func 删除_下个方块():
	for cell in 下个方块:
		nextTileMap.set_cell(-1, cell, 0)#tilemap绘制cell，XY后是使用的图集
		
func 获取_当前方块():
	status_index = 0
	当前方块Index = 下个方块Index
	#当前方块 = 下个方块
	当前方块 = []
	for cell in 下个方块:
		当前方块.append(Vector2(cell.x + START_POS.x, cell.y + START_POS.y))
	
func 绘制_当前方块():
	for cell in 当前方块:
		mainTileMap.set_cell(-1, cell, 0,Vector2(0,0))#tilemap绘制cell，XY后是使用的图集
		

func 删除_上个方块():
	for cell in 当前方块:
		mainTileMap.set_cell(-1, cell, 0)#tilemap绘制cell，XY后是使用的图集

func 绘制_落地_形状():
	for cell in 已落地形状:
		mainTileMap.set_cell(-1, cell, 0,Vector2(0,0))
	gui.增加_落地_得分()

func 检查_X轴边界(copy):
	var 左右边界:int = 0
	var min_x:int = 获取_最小_X值(copy)
	if min_x < 0:
		左右边界 = -1
	var max_x:int = 获取_最大_X值(copy)
	if max_x >9:
		左右边界 = 1
		
	return 左右边界

func 生命值_变更():
	if 储存生命值 == -15:
		生命值 = 2
	elif 储存生命值 == -16:
		生命值 = 2
	elif 储存生命值 == -14:
		生命值 = 2
		
	if 储存生命值 == -33:
		生命值 = 1
	elif 储存生命值 == -34:
		生命值 = 1
	elif 储存生命值 == -35:
		生命值 = 1
		
	if 储存生命值 == -52:
		生命值 = 0
	elif 储存生命值 == -51:
		生命值 = 0
	elif 储存生命值 == -53:
		生命值 = 0
	
	if 生命值 == 2:
		生命条动画.play("生命条受伤")
	if 生命值 == 1:
		生命条动画.play("生命条受伤")
	if 生命值 == 0:
		生命条动画.play("生命条受伤")
	


#检测是否满行
func 检测_是否_满行():
	var 行_块数 = 0 #检测一行有多少块
	var 行 = 17 #第几行，一共18行
	var 砖块index:Array = [] #检测砖块数据位置
	var 满行数 = 0 #会满几行
	
	while 行 > -1:  #17-0一直检测，共18行
		行_块数 = 0
		砖块index = []
		for i in 已落地形状.size():   #存储所有已落地形状的数据
			var cell:Vector2 = 已落地形状[i] #cell的xy等于已落地形状的xy
			if cell.y == 行:  #如果cell的y在17-0行，就代表这一行有块
				行_块数 += 1 #此行块数+1，最多不会超过10，因为一行只有10
				砖块index.append(i) #为砖块增加块所在的数据
				
		if 行_块数 == 10:
			满行数 += 1
			删除_落地方块_数据(砖块index, 行) #一个方法，传递给这个方法砖块的数据，以及行数
		else:
			行 -= 1  #如果这一行删了，还要检测这一行，直到这一行未满才检测下一行，避免19落20不检测
			
		
		if 满行数 > 0:
			删除_落地_Tilemap()
			绘制_落地_形状()
			绘制_当前方块()
			$"音效/满行消除".play()
			gui.增加_消行_总数(满行数)
			满行消除中 = true

func 检测_失败后_多少行():
	var 行_块数 = 0 #检测一行有多少块
	var 行 = 17 #第几行，一共18行
	var 砖块index1:Array = [] #检测砖块数据位置
	var 满行数 = 0 #会满几行
	
	while 行 > -3:  #17-0一直检测，共18行
		行_块数 = 0
		砖块index1 = []
		for i in 已落地形状.size():   #存储所有已落地形状的数据
			var cell:Vector2 = 已落地形状[i] #cell的xy等于已落地形状的xy
			if cell.y == 行:  #如果cell的y在17-0行，就代表这一行有块
				行_块数 += 1 #此行块数+1，最多不会超过10，因为一行只有10
				砖块index1.append(i) #为砖块增加块所在的数据
				
		if 行_块数 >= 1:
			满行数 += 1
			储存生命值 -= 1
			删除_已有方块_数据(砖块index1, 行) #一个方法，传递给这个方法砖块的数据，以及行数
		else:
			行 -= 1  #如果这一行删了，还要检测这一行，直到这一行未满才检测下一行，避免19落20不检测
			
func 检测_游戏_失败():
	for cell in 已落地形状: #检测已落地形状的所有事件
		if cell.y == 0:
			检测_失败后_多少行()
			删除_上个方块()
			删除_落地_位置()
			删除_落地_Tilemap()
			生命值_变更()
		
	if 生命值 == 0:
		删除_上个方块()
		删除_落地_位置()
		tick.stop()
		平移_tick.stop()
		快速下落_tick.stop()
		当前方块 = []
		$"音效/樱之诗歌曲".stop()
		$"音效/落地".stop()
		游戏结束菜单.结束_游戏_菜单()
		$"音效/失败音乐".play()
		$"音效/游戏失败人声".play()
		gui.动漫_小人_死了()
		
		

##################################
#假如有1 2 3行，如果2行满了，3行会掉一个Y轴-1下去，从后往前删，这为正常
#如果从前往后删，数据就会错乱
##################################
func 删除_已有方块_数据(砖块index1:Array, 行):
	#var last:int = 砖块index.size() - 1 #获得砖块最后一个数据
	while 砖块index1.size() > 0:
		已落地形状.remove_at(砖块index1.pop_back()) #pop back意思是删除并返回最后一条数据 直到数组为空
	
			
func 删除_落地方块_数据(砖块index:Array, 行):
	#var last:int = 砖块index.size() - 1 #获得砖块最后一个数据
	while 砖块index.size() > 0:
		已落地形状.remove_at(砖块index.pop_back()) #pop back意思是删除并返回最后一条数据 直到数组为空
	#用 i 不用 cell 的原因是vector2是简单的值，而非引用，如果用cell就会无关，所以用i
	for i in 已落地形状.size():   
		if 已落地形状[i].y < 行:
			已落地形状[i].y += 1

func 删除_落地_Tilemap():  #删除tilemap中的格子
	var cells:Array = mainTileMap.get_used_cells_by_id(0)
	for cell in cells:
		mainTileMap.set_cell(-1, cell, -1)#-1为删除


func 获取_直接_落地():
	var 深度:int = 1
	var 当前方块下落:Array = [] #当前方块下落数组，刷新位置
	for cell in 当前方块:  #让当前方块加上距离 
		cell.y += 深度 #让Y轴加上深度
		当前方块下落.append(cell)

	var 在_地面:bool = 检查_触底(当前方块下落)
	while 在_地面 == false:  #同时没在地面，深度就继续往下探索
		深度 += 1
		当前方块下落 = [] #清空下落数据
		for cell in 当前方块:
			cell.y += 深度
			当前方块下落.append(cell)
		在_地面 = 检查_触底(当前方块下落) #获取条件不再成立的数据，如重叠与触底, = ture
	for i in 当前方块下落.size():
		当前方块下落[i].y -= 1
		mainTileMap.set_cell(-1, 当前方块下落[i], 0,Vector2(0,0))
	已落地形状.append_array(当前方块下落) #为已落地形状追加当前方块下落
		
	删除_上个方块()
	获取_当前方块()
	绘制_当前方块()
	删除_下个方块()
	下一个形状()
	绘制_下个方块()
	检测_是否_满行()
	落地_位置()
	绘制_落地_形状()
	检测_游戏_失败()
	$"音效/直接落地".play()
	
#下落
func 移动_当前方块():
	删除_上个方块()
	var 当前方块下落:Array = [] #当前方块下落数组，刷新位置
	for cell in 当前方块:  #让当前方块加上距离 
		cell += DISTANCE 
		当前方块下落.append(cell)
	
	var 在_地面:bool = 检查_触底(当前方块下落)
	if 在_地面:
		已落地形状.append_array(当前方块) #让已落地形状获取当前方块的位置
		删除_上个方块()
		获取_当前方块()
		删除_下个方块()
		下一个形状()
		绘制_下个方块()
		检测_是否_满行()
		落地_位置() #所有获取之前都要检测以下
		绘制_当前方块()
		绘制_落地_形状()
		$"音效/落地".play()
	else:
		当前方块 = 当前方块下落 #让当前方块获取上边数组的数据
	
#检查是否触底
func 检查_触底(copy):  #我们只需让他能获取到17这个值，并返回bool
	#一，落在地面
	var 在_地面 = false
	var max_Y:int = 获取_最大_Y值(copy)
	if max_Y > 17:
		在_地面 = true
		
	#二，叠加形状
	var 形状重叠 = 检查_形状重叠(copy)
	
	return 在_地面 or 形状重叠  #发生这两个时都会返回true

func 检查_形状重叠(copy):  #寻找copy数据是否与落地格子有重叠
	var 形状重叠 = false
	for cell in copy:
		if 已落地形状.find(cell) > -1:
			形状重叠 = true
			break
	
	return 形状重叠

#下落时间
func _on_tick_timeout(): #原本修改计时器的方法会有延迟，因为改了后他还是要完成一秒的waittime
	if 快速下落 == false:
		移动_当前方块()
		绘制_当前方块()


func _on_快速下落_tick_timeout(): #直接换帅将不会有这种问题
	if 快速下落 == true:
		移动_当前方块()
		绘制_当前方块()




func 平行_移动_当前方块():
	删除_上个方块()
	var 当前方块下落:Array = [] #当前方块下落数组，刷新位置
	for cell in 当前方块:  #让当前方块加上距离 
		cell.x += 平行_移动
		当前方块下落.append(cell)

	var 左右边界 = 检查_X轴边界(当前方块下落) #将x轴边界函数绑定至当前方块下落，已确定函数数据运算
	var 已重叠 = 检查_形状重叠(当前方块下落)
	if 左右边界 == 0 and 已重叠 == false:
		当前方块 = 当前方块下落
		$"音效/移动".play()
		
	if 左右边界 == -1:
		主方框移动.play("左边界")
	elif 左右边界 == 1:
		主方框移动.play("右边界")
	else:
		主方框移动.play("普通不移动")
	
func 方块_旋转():
	删除_上个方块()
	旋转_当前方块()
	落地_位置()
	绘制_当前方块()
	
func 旋转_当前方块():
	if 当前方块Index != 1:
		var min_x:int = 获取_最小_X值(当前方块) #获得当前方块最小的xy坐标
		var min_y:int = 获取_最小_Y值(当前方块)
		
		var status_list:Array
		match 当前方块Index:
			2:
				status_list = Globals.方块2_state
			3:
				status_list = Globals.方块3_state
			4:
				status_list = Globals.方块4_state
			5:
				status_list = Globals.方块5_state
			6:
				status_list = Globals.方块6_state
			7:
				status_list = Globals.方块7_state
		
		var temp_index = status_index + 1
		if temp_index >= status_list.size():
			temp_index = 0

		var status:Array = status_list[temp_index].duplicate()  #让status获取备份数组
		for i in status.size():
			status[i].x += min_x   #让status里的新数组得到x与y
			status[i].y += min_y
		
		var 左右边界:int = 检查_X轴边界(status)
		var 触底 = 检查_触底(status)
		if 左右边界 == 0 and not 触底:
			当前方块 = status
			status_index = temp_index
			$"音效/旋转".play()

#会出现的落地位置
func 落地_位置():
	删除_落地_位置()
	var 深度:int = 1
	var 当前方块下落:Array = [] #当前方块下落数组，刷新位置
	for cell in 当前方块:  #让当前方块加上距离 
		cell.y += 深度 #让Y轴加上深度
		当前方块下落.append(cell)

	var 在_地面:bool = 检查_触底(当前方块下落)
	while 在_地面 == false:  #同时没在地面，深度就继续往下探索
		深度 += 1
		当前方块下落 = [] #清空下落数据
		for cell in 当前方块:
			cell.y += 深度
			当前方块下落.append(cell)
		在_地面 = 检查_触底(当前方块下落) #获取条件不再成立的数据，如重叠与触底
	最终_落地_方块 = [] #清空数据
	for cell in 当前方块下落:
		cell.y -= 1
		最终_落地_方块.append(cell)
	
	绘制_预测落地_方块()
		
func 删除_落地_位置():
	for cell in 最终_落地_方块:
		mainTileMap.set_cell(-1, cell, -1)#tilemap绘制cell，XY后是使用的图集

func 绘制_预测落地_方块():
	for cell in 最终_落地_方块:
		mainTileMap.set_cell(-1, cell, 2,Vector2(0,0))
		

func 获取_最小_X值(copy:Array):
	var min_x:int = 100
	for cell in copy:
		if cell.x < min_x:
			min_x = cell.x
	return min_x
	
func 获取_最大_X值(copy:Array):
	var max_x:int = 0
	for cell in copy:
		if cell.x > max_x:
			max_x = cell.x
	return max_x

func 获取_最大_Y值(copy):
	var max_Y:int = 0
	for cell in copy:
		if cell.y > max_Y:
			max_Y = cell.y
	return max_Y

func 获取_最小_Y值(copy:Array):
	var min_y:int = 100
	for cell in copy:
		if cell.y < min_y:
			min_y = cell.y
	return min_y


func _on_平移_tick_timeout():
	if 平行_移动 != 0:
		平行_移动_当前方块()
		落地_位置() #平移时检测
		绘制_当前方块()

