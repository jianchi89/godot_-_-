extends Node

var 左边界:int
var 右边界:int

var 所有方块:Dictionary = {"方块1":[Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(1,1)], #O形块
						"方块2":[Vector2(0,1),Vector2(1,1),Vector2(2,1),Vector2(2,0)], #L形
						"方块3":[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)], #J形
						"方块4":[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(2,1)], #z形
						"方块5":[Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(2,0)], #s形
						"方块6":[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)], #I形
						"方块7":[Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(2,1)]} #T形

var 方块2_state:Array = [[Vector2(0,1),Vector2(1,1),Vector2(2,1),Vector2(2,0)],[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(1,2)],
						[Vector2(0,0),Vector2(0,1),Vector2(1,0),Vector2(2,0)],[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(1,2)]]
						
var 方块3_state:Array = [[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(2,1)],[Vector2(1,0),Vector2(1,1),Vector2(1,2),Vector2(0,2)],
						[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(2,1)],[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(1,0)]]
						
var 方块4_state:Array = [[Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(2,1)],[Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(0,2)]]

var 方块5_state:Array = [[Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(2,0)],[Vector2(0,0),Vector2(0,1),Vector2(1,1),Vector2(1,2)]]

var 方块6_state:Array = [[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)],[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(0,3)]]

var 方块7_state:Array = [[Vector2(0,1),Vector2(1,1),Vector2(1,0),Vector2(2,1)],[Vector2(1,0),Vector2(1,1),Vector2(1,2),Vector2(0,1)],
						[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(1,1)],[Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(1,1)]]

#消行增加的分数
var 增加_消行_分数:Array = [500,800,1100,1600]
var 方块落地分数:int = randi_range(50,100)

var 难度等级检测:int
