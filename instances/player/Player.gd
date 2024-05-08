extends CharacterBody2D

@onready var jump_check = $JumpCheck
@onready var fall_check = $FallCheck
@onready var floor_check = $FloorCheck

@onready var left_check = $LeftCheck
@onready var right_check = $RightCheck

const grid_size = Vector2(16, 16)

var is_moving = false

func _physics_process(_delta):
	if is_moving:
		return
	
	if not floor_check.is_colliding():
		fall()
		return
	
	elif Input.is_action_pressed("ui_down"):
		descend()
	elif Input.is_action_pressed("ui_up"):
		move_up()
	elif get_input() != 0:
		move_horizontal(get_input())



func move_horizontal(dir):
	var check : RayCast2D = [left_check, right_check][min(dir + 1, 1)]
	
	if check.is_colliding(): 
		return 
	
	move(Vector2(dir, 0) * grid_size) 
 

func descend():
	if fall_check.is_colliding():
		return
	
#	move(Vector2(0, 1) * grid_size)
	move(Vector2(0, grid_size.y), 0.2)


func move_up():
	if not jump_check.is_colliding(): 
		return 
	
	move(Vector2(0, -grid_size.y), 0.2)
	
	is_moving = true


func fall():
	move(Vector2(0, 1) * grid_size) 


func move(move_pos, duration : float = 0.2):
	var tween = create_tween()
	
	tween.tween_property(self, "position", position + move_pos, duration)
	tween.play()
	tween.finished.connect(_on_tween_finished)
	
	is_moving = true


func _on_tween_finished():
	is_moving = false


func jump():
	if !jump_check.is_colliding():
		return
	


func get_input():
	return Input.get_axis("ui_left", "ui_right")






