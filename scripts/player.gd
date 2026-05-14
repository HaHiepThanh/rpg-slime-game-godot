extends CharacterBody2D

const SPEED = 100.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var atk_cooldown: Timer = $atk_cooldown
@onready var atk_delay: Timer = $atk_delay
@onready var regen_timer: Timer = $regen_timer
@onready var healthbar_progress: ProgressBar = $healthbar

var direction = "down"

var enemy_in_atk_range = false
var enemy_atk_cooldown = true

var player_alive = true

var atk_in_progess = false

func _physics_process(delta: float) -> void:
	if atk_in_progess:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	player_movement(delta)
	enemy_atk()
	player_atk()
	update_health()
	
	if global.player_health <= 0:
		player_alive = false
		global.player_health = 0
		self.queue_free()
	
func player_movement(delta):
	var input_vector = Vector2.ZERO
	
	# Nhân vật đi thẳng
	if Input.is_action_pressed("go_right"):
		direction = "right"
		player_animation(1)
		input_vector.x = 1
	if Input.is_action_pressed("go_left"):
		direction = "left"
		player_animation(1)
		input_vector.x -= 1
	if Input.is_action_pressed("go_up"):
		direction = "up"
		player_animation(1)
		input_vector.y -= 1
	if Input.is_action_pressed("go_down"):
		direction = "down"
		player_animation(1)
		input_vector.y += 1
	
	## Xét nhân vật đi chéo
	#if input_vector.x < 0 && input_vector.y < 0:
		#direction = "up"
		#player_animation(1)
		#print("top-left")
		#input_vector.y -= 1
		#input_vector.x -= 1
		
	#if input_vector.x > 0 && input_vector.y < 0:
		#direction = "up"
		#player_animation(1)
		#print("top-right")
		#
	#if input_vector.x > 0 && input_vector.y > 0:
		#direction = "down"
		#player_animation(1)
		#print("below-right")
		#
	#if input_vector.x < 0 && input_vector.y > 0:
		#direction = "down"
		#player_animation(1)
		#print("below-left")
		
	if input_vector == Vector2.ZERO:
		player_animation(0)
		#direction = "none"
		
	input_vector = input_vector.normalized()
	velocity = input_vector * SPEED
		
	move_and_slide()
	
func player_animation(movement):
	var dir = direction
	var animation = animated_sprite_2d
	
	match dir:
		"right":
			animation.flip_h = false
			match movement:
				1: animation.play("side-walk")
				0: if not atk_in_progess:
					animation.play("side-idle")
		"left":
			animation.flip_h = true
			match movement:
				1: animation.play("side-walk")
				0: if not atk_in_progess:
					animation.play("side-idle")
		"up":
			animation.flip_h = false
			match movement:
				1: animation.play("back-walk")
				0: if not atk_in_progess:
					animation.play("back-idle")
		"down":
			animation.flip_h = true
			match movement:
				1: animation.play("front-walk")
				0: if not atk_in_progess:
					animation.play("front-idle")
		
	pass

func player():
	pass
	
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atk_range = true
	pass # Replace with function body.

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_atk_range = false
	pass # Replace with function body.
	
func enemy_atk():
	if enemy_in_atk_range and enemy_atk_cooldown:
		global.player_health -= 10
		enemy_atk_cooldown = false
		print("player health: ",global.player_health)
		atk_cooldown.start()
		
		if global.player_health > 0 and not regen_timer.is_stopped():
			regen_timer.stop()  # reset timer nếu đang chạy
		regen_timer.start()
	pass
	
func _on_atk_cooldown_timeout() -> void:
	enemy_atk_cooldown = true
	pass # Replace with function body.
	
func player_atk():
	if atk_in_progess:
		return
		
	var dir = direction
	var animation = animated_sprite_2d
	
	if Input.is_action_pressed("attack"):
		global.player_current_atk = true
		atk_in_progess = true
		match dir:
			"right":
				animation.flip_h = false
				animation.play("side-atk")
			"left":
				animation.flip_h = true
				animation.play("side-atk")
			"down":
				animation.play("front-atk")
			"up":
				animation.play("back-atk")
		atk_delay.start()
			
func _on_atk_delay_timeout() -> void:
	atk_delay.stop()
	global.player_current_atk = false
	atk_in_progess = false
	pass # Replace with function body.
	

func update_health():
	var healthbar = healthbar_progress
	healthbar.value = global.player_health
	
	if global.player_health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
	pass
	

func _on_regen_timer_timeout() -> void:
	if global.player_health < 100:
		global.player_health += 5
		if global.player_health >= 100:
			global.player_health = 100
			regen_timer.stop()  
	else:
		regen_timer.stop()
