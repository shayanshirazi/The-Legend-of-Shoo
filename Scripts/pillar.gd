extends AnimatableBody2D


##########  Onready Variables Initialization  ##########

@onready var collision_1: CollisionShape2D = $Collision1
@onready var collision_2: CollisionShape2D = $Collision2
@onready var collision_3: CollisionShape2D = $Collision3
@onready var collision_4: CollisionShape2D = $Collision4
@onready var face_1: Node2D = $Face1
@onready var face_2: Node2D = $Face2
@onready var face_3: Node2D = $Face3
@onready var face_4: Node2D = $Face4
@onready var main: Node2D = $".."
@onready var collision_detector: Area2D = $CollisionDetector


##########  Other Variables Initialization  ##########

var collisions = []
var faces = []



func clear_skin() -> void:
	"""This function is called to clear the face of pillar."""
	
	# Disable all the collision objects
	for item in collisions:
		item.disabled = true
	
	# Hide all the skins
	for item in faces:
		item.visible = false


func _ready() -> void:	
	"""This function is called once in the beginning of the scene. It's meant
	to initialize some basic vars and properties that we'll use later."""
	
	# Add collision shapes and skins to lists to iterate over them later
	collisions = [collision_1, collision_2, collision_3, collision_4]
	faces = [face_1, face_2, face_3, face_4] 
	
	clear_skin()  # Clear any previous skin


func set_skin(ind: int) -> void:
	"""This function is called to set a new skin for the pillar. The input is 'ind'
	which must be an integer between 0 and 6 inclusive."""
	
	clear_skin()  # Clear any previous skin first
	
	collisions[ind].disabled = false  # Enable the collision of ind_th skin
	faces[ind].visible = true  # Show the skin of ind_th skin

 
func _on_collision_detector_body_entered(body: Node2D) -> void:
	"""When an object touches the pillar. This function is called every time that an
	object enters the top of pillar, and it's used to determine when to increase the
	player score."""
	
	# If it's not our player, it doesn't matter
	if not (body is CharacterBody2D):
		return
	
	main.increase_score()  # Increase the player score
	
	# Delete the collision detector so increasing happens only once
	collision_detector.queue_free() 
