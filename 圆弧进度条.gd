extends Control


var progress = 0.15  #度，范围在 0 到 1 之间
var radius = 50  # 圆形进度条的半径
var thickness = 10  # 圆形进度条的厚度
var color_progress = Color(155.0,155.0,155.0)

func _draw():
	# 计算圆弧的起始角度和结束角度
	var start_angle = -PI / 2  # 从圆的上方开始
	var end_angle = -PI / 2 + progress * (2 * PI)  # 根据进度计算结束角度

	# 绘制圆形进度条的进度
	draw_circle_arc(Vector2(0, 0), radius, color_progress, start_angle, end_angle, thickness)

func draw_circle_arc(center, radius, color, start_angle, end_angle, thickness):
	color = Color(155.0,155.0,155.0)
	# 绘制圆弧
	var num_segments = 1000  # 分段数，控制圆弧的平滑度
	var angle_step = (end_angle - start_angle) / num_segments
	for i in range(num_segments + 1):
		var angle = start_angle + angle_step * i
		var x1 = center.x + radius * cos(angle)
		var y1 = center.y + radius * sin(angle)
		var x2 = center.x + (radius - thickness) * cos(angle)
		var y2 = center.y + (radius - thickness) * sin(angle)
		draw_line(Vector2(x1, y1), Vector2(x2, y2), color)






