extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_enter_door = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	door_animation()
	pass
	
func door_animation():
	if player_enter_door:
		animated_sprite_2d.play("open")
	else: 
		animated_sprite_2d.play("close")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_enter_door = true
	pass # Replace with function body.

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_enter_door = false
	pass # Replace with function body.
