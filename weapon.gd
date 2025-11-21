extends Node3D

@export var fire_rate: float = 10.0        # schoten per seconde
@export_node_path var muzzle_node_path: NodePath = NodePath("Muzzle")
@export_node_path var muzzle_flash_path: NodePath = NodePath("GPUParticles3D")  # jouw node

var fire_cooldown: float = 0.0             # interne timer

func _process(delta: float) -> void:
	# cooldown aftellen
	if fire_cooldown > 0.0:
		fire_cooldown -= delta

	# als speler schiet
	if Input.is_action_pressed("fire") and fire_cooldown <= 0.0:
		_shoot()
		fire_cooldown = 1.0 / fire_rate


func _shoot() -> void:
	# muzzle flash activeren
	var flash = get_node_or_null(muzzle_flash_path)
	if flash:
		flash.emitting = true
		# kleine "burst" reset zodat hij opnieuw afspeelt
		if flash.has_method("restart"):
			flash.restart()

	# optioneel: je kunt hier later kogels of raycasts toevoegen
