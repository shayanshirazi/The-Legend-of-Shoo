extends Area2D


##########  Onready Variables Initialization  ##########

@onready var explosion_effect: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = %Player
@onready var timer: Timer = $Timer
@onready var player_health_bar: ProgressBar = $"../Player/HealthBar"
@onready var bomb_falling_1: AudioStreamPlayer2D = $"../SFX/BombFalling1"
@onready var bomb_falling_2: AudioStreamPlayer2D = $"../SFX/BombFalling2"
@onready var bomb_explosion_1: AudioStreamPlayer2D = $"../SFX/BombExplosion1"
@onready var bomb_explosion_2: AudioStreamPlayer2D = $"../SFX/BombExplosion2"


##########  Other Variables Initialization  ##########

var SPEED: int = 500
var is_exploding: bool = false
var is_damaging_char: bool = false



func _ready() -> void:
	""""This function is only called once, when the object is initialized in the game."""
	
	explosion_effect.hide()  # Hide the explosion picture
	sprite_2d.show()  # Show the bomb
	randomize()  # Randomise the seed for later
	
	# Flip a coin, and with 50% chance play one of the available sounds
	if randf() < 0.5:
		bomb_falling_1.playing = true
	else:
		bomb_falling_2.playing = true


func _physics_process(delta: float) -> void:
	"""This function is called in every tick of the game. Here's where we apply gravity to our bomb!"""
	
	# If it's not already exploded, make the bomb fall down
	if not is_exploding:
		position.y += SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	"""This function is called whenever the bomb touches something. 
	We check if it's actually a valid collision and if so, explooosion!"""
	
	# Check if the bomb touched the player's body
	if body is CharacterBody2D:
		is_damaging_char = true
	
	# Stop the animation and hide the bomb body
	animation_player.stop()
	sprite_2d.hide()
	
	# Stop the sounds, both of them
	bomb_falling_1.playing = false
	bomb_falling_2.playing = false
	
	# Flip a coin, and with 50% chance play one of explosion sound effects
	if randf() < 0.5:
		bomb_explosion_1.playing = true
	else:
		bomb_explosion_2.playing = true
	
	# Set a flag variable, so other parts of code know that this bomb has exploded
	is_exploding = true
	
	# Play related animations 
	explosion_effect.show()
	explosion_effect.play()
	
	# After all these, if we touched the player, it should take the BOMB DAMAGE!
	if is_damaging_char:
		body.take_bomb_damage()
	
	# Start a 0.25s timer to make the graphic more realistic, and then vanish into the air
	timer.start()


func _on_timer_timeout() -> void:
	"""This function is called after the 0.25s timer is done. It makes the bomb disappear into the air"""
	
	queue_free()  # A builtin function that removes the object from the game
