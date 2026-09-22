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
	pass
