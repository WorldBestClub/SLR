extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	while (true):
		await get_tree().create_timer(1).timeout
		for i in range(60):
			$Xyz/Coord.modulate.a -= 0.25/60
			await get_tree().create_timer(1.0/60).timeout
		await get_tree().create_timer(1).timeout
		for i in range(60):
			$Xyz/Coord.modulate.a += 0.25/60
			await get_tree().create_timer(1.0/60).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ($Score.modulate.a > 0.0):
		$Score.modulate.a -= 0.01
	if ($Energy.modulate.a > 0):
		$Energy.modulate.a -= 0.01

func _on_points_calculated(changed):	# 에너지 계산이 끝났을 때
	if (changed > -20):
		Backend.energy += changed
	else:
		Backend.energy += -20
	if (Backend.energy < 0):
		Backend.energy = 0
	
	if (changed >= -5):
		Backend.score += len(Backend.points[0])
		$Score.text = str(Backend.score)
		$Score.modulate.a = 1
	
	$Energy.value = Backend.energy
	$Energy.modulate.a = 1
	$Energy/Energy.text = str(round(10*Backend.energy)/10.0)
	if (Backend.energy >= 50):
		$Energy/Energy.position.y = -9.8*(round(10*Backend.energy)/10.0)+980
		$Energy/Energy.modulate.v = 0
	else:
		$Energy/Energy.position.y = -9.8*(round(10*Backend.energy)/10.0)+941
		$Energy/Energy.modulate.v = 1
