extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var chest_is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("close")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	chest_animation()
	pass
	
func chest_animation():
	if chest_is_open:
		animated_sprite_2d.play("open")
	pass
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player") and not chest_is_open:
		chest_is_open = true
	pass # Replace with function body.
