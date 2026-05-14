
extends CharacterBody2D
@onready var healthbar_progress: ProgressBar = $ProgressBar
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var SPEED = 40
var direction = "none"

var player_chase = false
var player: Node2D = null

var health = 50
var player_in_atk_zone = false

@onready var take_damage_cooldown: Timer = $take_damage_cooldown
var damage_intake = true

func _ready() -> void:
	animated_sprite_2d.play("front_idle")
	
func _physics_process(delta: float) -> void:
	dealed_damage()
	update_health()
	
	if player_chase and player:
		var dir = (player.position - position).normalized()
		var motion = dir * SPEED * delta
		var collision = move_and_collide(motion)
		
		#Xử lý va chạm khi enemy dính với player
		if collision:
			# Nếu va chạm player thì dừng lại
			if collision.get_collider().is_in_group("Player"):
				velocity = Vector2.ZERO
				enemy_animation(0)
				return
	# Nếu không va chạm player thì cứ đi bình thường
		velocity = dir * SPEED
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0: 
				direction = "right" 
				enemy_animation(1) 
			else: 
				direction = "left" 
				enemy_animation(1) 
		else: 
			if dir.y > 0: 
				direction = "down" 
				enemy_animation(1) 
			else: 
				direction = "up" 
				enemy_animation(1)
	else:
		velocity = Vector2.ZERO
		enemy_animation(0)

func enemy_animation(movement):
	var dir = direction
	var animation = animated_sprite_2d
	
	match dir:
		"right": 
			animation.flip_h = false
			match movement:
				1: animation.play("side_movement")
				0: animation.play("side_idle")
		"left":
			animation.flip_h = true
			match movement:
				1: animation.play("side_movement")
				0: animation.play("side_idle")
		"down":
			animation.flip_h = true
			match movement:
				1: animation.play("front_movement")
				0: animation.play("front_idle")
		"up":
			animation.flip_h = false
			match movement:
				1: animation.play("back_movement")
				0: animation.play("back_idle")
		
	pass

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atk_zone = true
	pass # Replace with function body.
	
func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_atk_zone = false
	pass # Replace with function body.
	
func dealed_damage():
	var dir = direction
	var animation = animated_sprite_2d
	
	if player_in_atk_zone and global.player_current_atk:
		if damage_intake:
			health -= global.player_damge
			take_damage_cooldown.start()
			damage_intake = false
			print("slime heatlh: ",health)
			if health <= 0:
				self.queue_free()
			pass
			

func _on_take_damage_cooldown_timeout() -> void:
	damage_intake = true
	pass # Replace with function body.


func update_health():
	var healthbar = healthbar_progress
	healthbar.value = health
	
	if health >= 50:
		healthbar.visible = false
	else:
		healthbar.visible = true
	pass
