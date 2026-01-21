extends Node2D


##########  Onready Variables Initialization  ##########

@onready var city_1: ParallaxBackground = $Cities/City1
@onready var city_2: ParallaxBackground = $Cities/City2
@onready var city_3: ParallaxBackground = $Cities/City3
@onready var city_4: ParallaxBackground = $Cities/City4
@onready var city_5: ParallaxBackground = $Cities/City5
@onready var city_6: ParallaxBackground = $Cities/City6
@onready var city_7: ParallaxBackground = $Cities/City7
@onready var city_8: ParallaxBackground = $Cities/City8
@onready var music_1: AudioStreamPlayer2D = $BackgroundMusics/Music1
@onready var music_2: AudioStreamPlayer2D = $BackgroundMusics/Music2
@onready var music_3: AudioStreamPlayer2D = $BackgroundMusics/Music3
@onready var music_4: AudioStreamPlayer2D = $BackgroundMusics/Music4
@onready var music_5: AudioStreamPlayer2D = $BackgroundMusics/Music5
@onready var music_6: AudioStreamPlayer2D = $BackgroundMusics/Music6
@onready var music_7: AudioStreamPlayer2D = $BackgroundMusics/Music7
@onready var music_8: AudioStreamPlayer2D = $BackgroundMusics/Music8
@onready var stage_one: AudioStreamPlayer2D = $SFX/StageOne
@onready var stage_two: AudioStreamPlayer2D = $SFX/StageTwo
@onready var stage_three: AudioStreamPlayer2D = $SFX/StageThree
@onready var stage_four: AudioStreamPlayer2D = $SFX/StageFour
@onready var stage_one_titles: Node = $SFX/Stage1
@onready var stage_two_titles: Node = $SFX/Stage2
@onready var stage_three_titles: Node = $SFX/Stage3
@onready var stage_four_titles: Node = $SFX/Stage4
@onready var stages = [stage_one, stage_two, stage_three, stage_four]
@onready var stage_titles = [stage_one_titles, stage_two_titles, stage_three_titles, stage_four_titles]
@onready var inc_score_sfx: AudioStreamPlayer2D = $SFX/IncScore
@onready var inc_score_sfx_2: AudioStreamPlayer2D = $SFX/IncScore2
@onready var sfx_timer: Timer = $SFX/Timer
@onready var sfx_timer2: Timer = $SFX/Timer2
@onready var starting_pillar: AnimatableBody2D = $StartingPillar
@onready var camera: Camera2D = $Camera2D
@onready var health_bar: ProgressBar = $Menu/HealthBar
@onready var score_bar: Label = $Menu/ScoreBar

@onready var cities = [city_1, city_2, city_3, city_4, city_5, city_6, city_7, city_8]
@onready var musics = [music_1, music_2, music_3, music_4, music_5, music_6, music_7, music_8]


##########  Other Variables Initialization  ##########

const STONE = preload("res://Scenes/stone.tscn")
const BOMB = preload("res://Scenes/bomb.tscn")
const MISSLE = preload("res://Scenes/missle.tscn")
const PILLAR = preload("res://Scenes/pillar.tscn")

var STONE_LEVEL: int = randi_range(15, 25)
var MISSLE_LEVEL: int = randi_range(30, 50)
var BOMB_LEVEL: int = randi_range(100, 110)

var color = ["FF2929", "7E1891", "0A97B0", "FF0080", "85F4FF", "E90074", "DA0C81", "0002A1"]
var last_pillar_x: int = 150
var player_score: int = 0
var current_stage: int = 0
var player_saw_stone: bool = false
var player_saw_missle: bool = false
var player_saw_bomb: bool = false



func missle_lunch() -> void:
	"""This function will launch a missle towards the player in every call."""
	
	var new_missle = MISSLE.instantiate()  # Create a new instance of missle class
	
	new_missle.global_position = %Player.global_position  # Set the position to player's position
	new_missle.global_position.x += 1000  # Shift it a bit further so it won't be too easy
	
	var random_scale = randf_range(0.5, 1)  # Choose a random scale for the missle
	new_missle.scale = Vector2(random_scale, random_scale)  # Set the random scale
	
	new_missle.SPEED = randi_range(200, 500)  # Choose a random speed for the missle
	
	add_child(new_missle)  # Finally, add the missle to the scene


func bomb_lunch() -> void:
	"""This function will launch a bomb towards the player in every call."""
	
	var new_bomb = BOMB.instantiate()  # Create a new instance of the bomb class
	
	new_bomb.global_position = %Player.global_position  # Set the position to player's position
	new_bomb.global_position.y -= 1000  # Take it higher so it will fall down on player's head
	new_bomb.global_position.x += 10  # And a bit further as the player is probably on the move
	
	var random_scale = randf_range(0.8, 1.4)  # Choose a random scale for it
	new_bomb.scale = Vector2(random_scale, random_scale)  # Set the random scale
	
	add_child(new_bomb)  # Add the bomb object to the scene


func stone_lunch() -> void:
	"""This function will launch a stone towards the player in every call. """
	
	var new_stone = STONE.instantiate()  # Create a new instance of the stone class
	
	# Set the position to players position plus a randomized delta
	new_stone.global_position = %Player.global_position + Vector2(randi_range(700, 1000), -1000)
	
	var random_scale = randf_range(3, 5)  # Choose a random scale for it
	new_stone.scale = Vector2(random_scale, random_scale)  # Set the random scale
	
	new_stone.SPEED = randi_range(250, 500)  # Choose a randomised speed for the stone
	
	add_child(new_stone)  # Add the stone to the scene so it's initialized
	
	# Then shoot the stone toward the current position of the player plus a randomised delta
	new_stone.shoot(%Player.global_position + Vector2(randi_range(200, 500), 0))


func clear_background() -> void:
	"""This function will clear the game's background."""
	
	for bg in $Cities.get_children():  # Iterate overall backgrounds
		bg.visible = false  # Hide them one by one


func clear_music() -> void:
	"""This function will clear the background music (if there is any)."""
	
	for mc in musics:  # Iterater overall background music
		mc.playing = false  # Stop them (even if they're already stopped)


func set_theme(ind: int) -> void:
	"""This function is called to set a new theme for the game. A theme includes
	background music, background city, and the player's hat colour. The input of this
	function is ind which is an integer in range 0 to 8 inclusive."""
	
	clear_background()  # Clear any current background
	clear_music()  # Clear any current sound effect
	
	cities[ind].visible = true  # Show the ind_th city
	musics[ind].playing = true  # Play the ind_th music
	$Player.set_hat_colour(color[ind])  # Change player's hat colout


func create_new_pillar() -> void:
	"""This function will create a new pillar in every call."""
	
	var new_pillar = PILLAR.instantiate()  # Create a new instance of the pillar class
	
	new_pillar.position.y += randi_range(-50, 50)  # Take it up/down randomly
	
	# Move it horizontally after the next pillar plus a randomized vector which is affected by player score
	# This means the more the player score is, the more the distance of pillars are going to be :D
	new_pillar.position.x += last_pillar_x + randi_range(150+player_score, 220+player_score*0.8)
	last_pillar_x = new_pillar.position.x  # Keep track of x position of last pillar in a flag variable
	
	var random_scale = randf_range(0.2, 0.3)  # Choose a randomised scale for the pillar
	new_pillar.scale = Vector2(random_scale, random_scale)  # Set the randomised scale of the pillar
	
	add_child(new_pillar)  # Add the pillar to the scene so it's initialized
	
	new_pillar.set_skin(randi_range(0, 3))  # Choose a custom skin for it randomly


func increase_score() -> void:
	"""This function is called to increase the player's score."""
	
	player_score += 60  # Updater the score variable
	
	score_bar.show()  # Make sure the score bar is not hidden
	score_bar.text = str(player_score/60)  # Update the value of the score bar
	
	
	# Flip a coin and with 50% chance play one of the related sound effects
	if randf() < 0.5:
		inc_score_sfx.playing = true
	else:
		inc_score_sfx_2.playing = true
	
	# Every five level, 6 new pillars are added to the game
	if (player_score%5 == 0):
		for i in 5:
			create_new_pillar()  # Use above function to create a new pillar


func _on_sfx_timer_timeout() -> void:
	"""After the player enters a new stage, and the title of the stage is introduced, 
	this function is called to randomly choose an appropriate name for the current stage
	and announce it to the user via my beautiful voice."""
	
	sfx_timer.stop()  # Stop the timer
	
	# Select the children of current stage sound effects
	var available_titles = stage_titles[current_stage-1].get_children()
	
	# Randomly play one of the available titles based on the number of children
	available_titles[randi() % available_titles.size()].playing = true


func _on_timer_2_timeout() -> void:
	"""This function is called when the player enters a new stage.
	In here we first introduce the number of the current stage, and then
	start the countdown to introduce the title of the stage in the above function."""
	
	sfx_timer2.stop()  # Stop the current timer
	stages[current_stage-1].playing = true  # Play the sound effect of the current stage
	sfx_timer.start()  # Start the countdown for announcing the randomised title


func new_stage() -> void:
	"""This function is called immediately after the player enters a new stage.
	To make the environment of the game more realistic, we give a 1.5s delay and then
	introduce the new stage using above functions."""
	
	sfx_timer2.start()  # Start the 1.5s timer


func _ready() -> void:
	"""This function is called once in the beginning of the game. In here
	we do some initializations and definitions."""
	
	randomize()  # Randomise the seed of Godot as we'll use random nums a lot in here (!)
	
	starting_pillar.set_skin(randi_range(0, 3))  # Set a random skin for the starting pillar
	score_bar.hide()  # Hide the score bar (it will show as soon as player score will increase)
	
	# Delete all the collision shapes of the starting pillar so it won't count toward player score :D
	for child in starting_pillar.get_children():  # Iterate over children
		if child is Area2D:  # If they are collision detector
			child.queue_free()  # Eliminate them
	
	# Initialy we create 20 pillars, as the screen width of the user might differ
	# And our game needs to be responsive for all screen ratios
	for i in 20:
		create_new_pillar()  # Use this functoin to create a new pillar
	
	set_theme(randi_range(0, 7))  # Set a random theme for the scene
	
	current_stage = 1  # Set the current stage to 1 as the game has just begun
	new_stage()  # Introduce this new stage


func _physics_process(_delta: float) -> void:
	"""This function is for sure the most important part of the game.
	In here we manage the attacks. This function is called in every tick 
	of the game."""
	
	# If it's time for stage 2, we give a demo of stones to player :D
	if player_score == STONE_LEVEL and not player_saw_stone:
		player_saw_stone = true  # Keep track if player saw stones before
		current_stage = 2  # Update the current stage
		new_stage()  # Introduce the new stage title
		
		stone_lunch()  # Launch a stone for player to see one
	
	# Launch stones if we have passed the stone stage using a randomised formula which is affected by player score
	# This again means that the higher the player score is, the higher chance of stones showing up will be :D
	if player_score > STONE_LEVEL and randf() < 0.001 * player_score / STONE_LEVEL:
		stone_lunch()  # Launch a stone
	
	# If it's time for stage 3, we give a demo of missles to player :D
	if player_score == MISSLE_LEVEL and not player_saw_missle:
		player_saw_missle = true  # Keep track if player saw missles before
		current_stage = 3  # Update the current stage
		new_stage()  # Introduce the new stage title
		
		missle_lunch()  # Launch a stone for player to see one
	
	# Launch missles if we have passed the missle stage using a randomised formula which is affected by player score
	# This again means that the higher the player score is, the higher chance of missles showing up will be :D
	if player_score > MISSLE_LEVEL and randf() < 0.0025 * player_score / MISSLE_LEVEL:
		missle_lunch()  # Launch a missle
	
	# If it's time for stage 4, we give a demo of bombs to player :D
	if player_score == BOMB_LEVEL and not player_saw_bomb:
		player_saw_bomb = true  # Keep track if player saw missles before
		current_stage = 4  # Update the current stage
		new_stage()  # Introduce the new stage title
		
		bomb_lunch()  # Launch a stone for player to see one
	
	# Launch a bomb if we have passed the bomb stage using a randomised formula which is affected by player score
	# This again means that the higher the player score is, the higher chance of bombs showing up will be :D
	if player_score > BOMB_LEVEL and randf() < 0.004 * player_score / BOMB_LEVEL:
		bomb_lunch()  # Launch a bomb
