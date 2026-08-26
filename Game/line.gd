extends Sprite2D

var line = false
var type = 1
signal drawn	# y=ax+b

func _ready():
	var second = $Point.duplicate()	# Point 복제
	add_child(second)
	get_child(1).modulate.a = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (Input.is_action_just_pressed("click_left")):	# 점 하나 찍기 (선 긋기 준비)
		if (not line and self_modulate.a == 0):
			line = true
			position = get_global_mouse_position()
			$Point.visible = true
			get_child(1).visible = true
			for i in range(25):
				$Point.scale.x -= 0.01
				$Point.scale.y -= 0.01
				if (i<15):
					self_modulate.a += 0.5/15
				await get_tree().create_timer(1.0/60).timeout
		
		elif (line and $Point.modulate.a == 1):			# 두 번째 점 찍기 (선 긋기)
			line = false
			drawn.emit(linear(position, get_child(1).global_position))	# y=ax+b
			$Point.scale = Vector2(1, 1)
			self_modulate.a = 1
			get_child(1).modulate.a = 1
			for i in range(25):
				$Point.scale.x -= 0.01
				$Point.scale.y -= 0.01
				get_child(1).scale.x -= 0.01
				get_child(1).scale.y -= 0.01
				await get_tree().create_timer(1.0/60).timeout
			await get_tree().create_timer(0.25).timeout
			for i in range(15):		#초기화
				self_modulate.a -= 1.0/15
				$Point.modulate.a -= 1.0/15
				get_child(1).modulate.a -= (1.0/15)
				await get_tree().create_timer(1.0/60).timeout
			self_modulate.a = 0
			$Point.visible = false
			get_child(1).visible = false
			$Point.scale = Vector2(1, 1)
			get_child(1).scale = Vector2(1, 1)
			$Point.modulate.a = 1
			get_child(1).modulate.a = 0.5
	
	if (line):	# 점 하나가 찍힌 상태 (선 긋기 준비)
		look_at(get_global_mouse_position())
		get_child(1).position = get_local_mouse_position()
		
	if (Input.is_action_just_pressed("click_right")):	# 점 없애기 (선 긋기 취소)
		if (line):
			for i in range(30):
				self_modulate.a -= 0.5/30
				$Point.modulate.a -= 1.0/30
				get_child(1).modulate.a -= 0.5/30
				await get_tree().create_timer(1.0/60).timeout
			line = false
			self_modulate.a = 0
			$Point.visible = false
			get_child(1).visible = false
			$Point.scale = Vector2(1, 1)
			get_child(1).scale = Vector2(1, 1)
			$Point.modulate.a = 1
			get_child(1).modulate.a = 0.5
			
func linear(p,q):
	#var a = (-p.y+q.y)/(p.x-q.x)	# y가 위로 올라갈수록 높아짐
	var a = tan(rotation)
	var b = (-p.y-(a*(p.x)))/80.0	# 화면의 좌표평면의 한 칸은 게임에서 80
	return Vector2(a, b)
