extends Node2D

var score = 0
var points = [0,0,0]	# 점의 좌표 (색깔별)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (get_parent().get_node("Score") != null):
		if (get_parent().get_node("Score").modulate.a > 0.5):
			get_parent().get_node("Score").modulate.a -= 0.01


func _on_points_score_change(changed):
	Backend.score += changed
	get_parent().get_child(5).text = str(roundi(Backend.score))
	get_parent().get_child(5).modulate.a = 1
