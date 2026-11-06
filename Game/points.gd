extends Node2D

var colors = [0,1,2]	# (현재 웨이브에서 나타날 수 있는) 점의 색깔
# 0=빨간색, 1=초록색, 3=파란색
#var numbers = [0,0,0]	# 점의 개수
#	var points = [0,0,0]	# 점의 좌표 (색깔별)
var allpoints = []		# 전체 점의 좌표 (중복 방지용)
var LoF = [0,0,0]		# 적합선 (y=ax+b)
var loss = [0,0,0]	# 손실함수 최솟값

signal calculated

func _ready():
	point(0)
	#point(1)
	#point(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func point(color):
	var origin = get_child(color).duplicate()
	#numbers[color] = randi_range(3, 4)
	#var coords = []
	Backend.points[color] = []
	var pos
	for i in range(randi_range(3, 4)):	# 복제값
		get_child(color).add_child(origin.duplicate())	# duplicate()를 한 노드는 한 번 추가되면 null이 된다.
		while ((pos in allpoints) or (pos == null)):	# 중복을 피하기 위함
			pos = Vector2(randi_range(1, 2),randi_range(1, 2))
		Backend.points[color].append(pos)
		allpoints.append(pos)
		get_child(color).get_child(i).position = Vector2(80*Backend.points[color][i].x, -80*Backend.points[color][i].y)
		get_child(color).get_child(i).modulate = Color(1.0, 1.0, 1.0, 1.0)
		get_child(color).get_child(i).self_modulate.a = 1
	#Backend.points[color] = coords
	LoF[color] = find(Backend.points[color])
	
	for i in range(len(Backend.points[color])):	# 오차의 제곱의 합 찾기
		loss[color] += ( Backend.points[color][i].y - ( LoF[color][0]*(Backend.points[color][i].x) + LoF[color][1] ))**2
	print("손실의 최솟값",loss[color])
	
func find(coords):		# 적합선 찾기
	var sum = [0,0,0,0]		# 각각 x총합, y총합, xy총합, x^2총합
	for i in range(len(coords)):
		sum[0] += coords[i].x
		sum[1] += coords[i].y
		sum[2] += coords[i].x * coords[i].y
		sum[3] += coords[i].x ** 2
	#적합선
	var result = [ ((len(coords)*sum[2])-(sum[0]*sum[1]))/((len(coords)*sum[3])-(sum[0]**2)) , ((sum[3]*sum[1])-(sum[0]*sum[2]))/((len(coords)*sum[3])-(sum[0]**2)) ]
	print("적합선",result)
	return result


func _on_line_drawn(equ, col):		# 선이 그어졌을 때
	print("그은 선",equ)
	var accuracy = 0.0	#그은 선의 손실의 합
	if (Backend.points[col] is Array):
		for i in range(len(Backend.points[col])):
			accuracy += ( Backend.points[col][i].y - ( equ[0]*(Backend.points[col][i].x) + equ[1] ))**2
		print("그은 선의 손실",accuracy)

	calculated.emit((loss[col]-accuracy))
