extends Area2D


##########  Onready Variables Initialization  ##########

@onready var missle_sound_effect: AudioStreamPlayer2D = $"../SFX/MissleOnTheWay"
@onready var explosion_1: AudioStreamPlayer2D = $"../SFX/BombExplosion1"
@onready var explosion_2: AudioStreamPlayer2D = $"../SFX/BombExplosion2"
@onready var timer: Timer = $Timer


##########  Other Variables Initialization  ##########

var SPEED: int = 200



func _ready() -> void:
	"""This function is called once when the object is initialized."""
	
	global_position.y /= 3  # Scale the position with camera pos
	missle_sound_effect.playing = true  # Play the sound effect


func _physics_process(delta: float) -> void:
	"""Called in every tick of the game. We make the rocket move in here!"""
	
	global_position.x -= SPEED * delta  # Make the missle go backward (to left)


func _on_body_entered(body: Node2D) -> void:
	"""When the missle collides with something, this function is called."""
	
	# If we pass the screen without touching anything, missle should get eliminated
	if body.name == "Backwall":
		timer.start()  # Start the 0.5s timer
	
	# If we touch a pillar, or a bomb or a stone, nothing should happen
	if not (body is CharacterBody2D):
		return
	
	missle_sound_effect.playing = false  # Stop the sound effect
	
	# Flip a coin and play one of two sound effects with 50% chance
	if randf() < 0.5:
		explosion_1.playing = true
	else:
		explosion_2.playing = true
	
	body.take_missle_damage()  # Make the player take the damage
	queue_free()  # Delete the missle from game using Godot's builtin function


func _on_timer_timeout() -> void:
	"""After the 0.5s timer has ran out, this function is called."""
	
	missle_sound_effect.playing = false  # Stop the sound effect
	
	queue_free()  # Delete the object from the scene
