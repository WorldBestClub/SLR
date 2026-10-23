extends Node2D


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_key_pressed(KEY_1):		# 색깔 바꾸기 (R)
		select(0)
	elif Input.is_key_pressed(KEY_2):		# 색깔 바꾸기 (G)
		select(1)
	elif Input.is_key_pressed(KEY_3):		# 색깔 바꾸기 (B)
		select(2)
	
	for i in range(3):
		if (Backend.points[i] is Array):
			get_child(i).modulate.a = 1
		else:
			get_child(i).modulate.a = 0.5
		

func select(color):
	for i in range(3):
		if (i==color):
			get_child(i).texture = load("res://Game/Objects/"+str(i)+".png")
		else:
			get_child(i).texture = load("res://Game/Objects/0"+str(i)+".png")
	
