extends CharacterBody2D


##########  Onready Variables Initialization  ##########

@onready var walk_animation: AnimationPlayer = $movement
@onready var player_body: Node2D = $Body
@onready var leg: Sprite2D = $Body/Leg
@onready var other_leg: Sprite2D = $Body/Leg2
@onready var camera: Camera2D = $"../Camera2D"
@onready var insvisible_backwall: CollisionShape2D = $"../Walls/Backwall"
@onready var main: Node2D = $".."
@onready var point_light: PointLight2D = $PointLight
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var health_bar: ProgressBar = $HealthBar
@onready var hit_timer: Timer = $Timer
@onready var menu: CanvasLayer = $"../Menu"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var killzone: Area2D = $"../Killzone"
@onready var stone_hit_effect: AudioStreamPlayer2D = $"../SFX/StoneHit"


##########  Other Variables Initialization  ##########

const SPEED: int = 250
const JUMP_VELOCITY: Vector2 = Vector2(-700, -500)

var is_flying: bool = false
var can_double_jump: bool = false
var last_pillar_distance: int = 0
var health = 1000


func set_hat_colour(hex_colour: String) -> void:
	"""This function will change the colour of Shoo's hat. As everything about Shoo is
	implemented from scratch, changing colours and adjusting attributes it's possible."""
	
	var new_colour = Color(hex_colour)  # Convert colour from String type to Color 
	
	# Change the colour of different parts of the hat
	%Body.get_node("Hat").color = new_colour
	%Body.get_node("HatCorner1").color = new_colour
	%Body.get_node("HatCorner2").color = new_colour
	%Body.get_node("HatCornerInWind").color = new_colour
	
	# Change the light source colour. Many might not notice this, but if you watch close,
	# There is a shadow of player on the pillars, here we change its colour
	point_light.color = new_colour


func _ready() -> void:
	"""This function is called once in the beggining of the game. Nothing special going
	on in here."""
	
	health_bar.hide()  # Hide the health bar as player's health is initially full


func legs_movement(flag: int) -> void:
	"""This function will move Shoo's legs while jumping. Numbers are founded after brute forcing
	all values and there is no logical reason behind them (!)"""
	
	leg.position.y += 12 - 24 * flag  # Move it up
	other_leg.position.y += 12 - 24 * flag  # Move the other game up as well
	is_flying = flag  # Save the current status in a flag variable


func _physics_process(delta: float) -> void:
	"""This function is called in every tick of the game, and is meant to handle physic
	aspect of Shoo like gravity, etc."""
	
	# If there's nothing under his feet, he should fall!
	if not is_on_floor():
		# Get the gravity vector from setting and add it to Shoo's y
		velocity += get_gravity() * delta
	
	# If Shoo is going to jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():  # If it's first time, no problem!
			velocity.y = JUMP_VELOCITY.x  # Add to it's velocity
			can_double_jump = true  # Enable the double jump ability
		elif can_double_jump:  # If Shoo is in the air and double jump is enabled
			velocity.y = JUMP_VELOCITY.y  # Add to velocity, but a bit less
			can_double_jump = false  # No more double jump!
	
	# Get the direction axis of Shoo's horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:  # Going forward
		player_body.scale.x = 1  # Scale the flip of x-axis of Shoo's body
		player_body.position.x = 0  # Set it back
		
		# Move the camera if Shoo gets far enough from the left border of game
		if (abs(global_position.x - camera.global_position.x) < 300):
			camera.position.x += SPEED * delta  # Make camera go forward
			insvisible_backwall.position.x += SPEED * delta  # Make the invisible wall to go forward
	elif direction < 0:  # Going backward
		player_body.scale.x = -1  # Reverse scale the x-axis flip of Shoo's body
		player_body.position.x = 60  # Move Shoo's body so it looks more realistic
	
	# Here we handle animations
	if is_on_floor():
		if is_flying:  # If just landed on the floor
			legs_movement(0)  # Legs come down
		
		
		if direction != 0 and ((not walk_animation.is_playing()) or walk_animation.current_animation == "idle"):
			# If it's moving and wrong animation is being played play walk animation
			walk_animation.play("walk")
		elif direction == 0 and ((not walk_animation.is_playing()) or walk_animation.current_animation != "idle"):
			# If it's not moving and wrong animation is being played, correct it
			
			walk_animation.stop()  # Stop the prev one
			walk_animation.play("idle")  # Play the idle animation
	elif not is_flying:
		# We're not in the floor and we're not flying hmmm
		# This means we just jumped!
		
		walk_animation.play("RESET")
		legs_movement(1)  # Legs going up (!)
	
	# Handle the movement
	if direction:
		velocity.x = direction * SPEED  # Move if direction is not zero
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Make movement smoother (kinda works like gravity)
	
	move_and_slide()  # Godot's builtin function to apply velocity to the object


func show_anger() -> void:
	"""This function makes Shoo angry (lmao)."""
	
	modulate = Color("FF4545")  # Change his colour to a bit red
	hit_timer.start()  # Start the 0.3s timer and continue after the timer is finished


func _on_timer_timeout() -> void:
	"""This function is called after the 0.3s timer of Shoo's anger has finished.
	It reset his colour to usual. Shoo is no more angry :)"""
	
	modulate = Color(1, 1, 1, 1)  # Reset the modular effect


func check_life() -> void:
	"""Check if Shoo is alive or not. If not, GAAAME OVER!"""
	
	if health <= 0:  # If health is non-positive
		killzone.game_over()  # Call the game_over function


func take_missle_damage() -> void:
	"""This function is called when Shoo is hit by a missile. It applies changes
	to health, and makes him angry!"""
	
	health_bar.show()  # Show the healthbar if already not shown
	
	health -= 5  # Deduct his health
	health_bar.value = health  # Update the health bar value
	
	# Apply the hit to menu as well, so other health bar will also get updated
	menu.take_hit(5)
	
	explosion.start()  # Start the explosion animation
	camera.shake_screen(3, 0.1)  # Shake the screen a bit
	show_anger()  # Make Shoo angry
	
	check_life()  # Check if he died or not


func take_bomb_damage() -> void:
	"""This function is called when Shoo is hit by a bomb. It applies changes
	to health, and makes him angry!"""
	
	health_bar.show()  # Show the healthbar if already not shown
	
	health -= 10  # Deduct his health
	health_bar.value = health  # Update the health bar value
	
	menu.take_hit(10)  # Apply changes to menu as well
	camera.shake_screen(6, 0.1)  # Shake the screen a bit
	show_anger()  # Make Shoo angry
	
	check_life()  # Check if he died or not


func take_stone_damage() -> void:
	"""This function is called when Shoo is hit by a stone. It applies changes
	to health, and makes Shoo angry!"""
	
	health_bar.show()  # Show the healthbar if already not shown
	
	health -= 2  # Deduct life
	health_bar.value = health  # Update health
	menu.take_hit(2)  # Apply changes to the menu
	stone_hit_effect.playing = true  # Play the sound effect 
	camera.shake_screen(1, 0.1)  # Shake the screen a bit
	show_anger()  # Make Shoo angry
	
	check_life()  # Check if he's still alive
