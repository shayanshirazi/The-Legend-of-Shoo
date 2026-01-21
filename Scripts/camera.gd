extends Camera2D


##########  Variable Initialization  ##########

var shake_intensity = 0.0
var shake_decay = 0.1



func shake_screen(intensity: float, decay: float = 0.1) -> void:
	"""This function shakes the screen with specific decay and intensity. It's used when a
	bomb is exploded or player gets damaged anyhow. In the function inputs, decay is optional."""
	
	# Change corresponding variables so _process function will apply the changes
	shake_intensity = intensity
	shake_decay = decay


func _process(_delta: float) -> void:
	"""This function is called in every tick of the game. It shakes the screen if necessary."""
	
	# Check if the screen should shake, and do it if necessary
	if shake_intensity > 0:
		# Choose a shake vector randomly to make it look more realistic
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		
		# As we're shaking, decrease the intensity by decay
		shake_intensity -= shake_decay
		 
		# Shake intensity cannot get negative, it'll cause problems if later on it's increased
		if shake_intensity < 0:
			shake_intensity = 0
	else:
		offset = Vector2.ZERO  # If there is no shake intensity, set the screen offset to zero
