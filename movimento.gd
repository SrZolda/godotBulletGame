extends CharacterBody2D

@onready var sprite: Sprite2D = $Marker2D/Sprite2D  
@onready var animation_player: AnimationPlayer = $AnimationPlayer  
@onready var position2d: Marker2D = $Marker2D  


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_walking: bool = false  
var facing_left: bool = false 

var life = 100  # Player's health
@onready var life_label = $Camera2D/Label 

func _ready():
	update_life_text()
   

func update_life_text():
	life_label.text = "Life: %d" % life





func _physics_process(delta: float) -> void:
	# Aplicar gravidade se não estiver no chão
	if not is_on_floor():
		velocity.y += get_gravity().y * delta 

	# Lidar com salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")
		return  # Sair para evitar sobrepor a animação de salto

	# Lidar com movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_action_pressed("ui_left"):
		is_walking = true
		animation_player.play("walk")
		velocity.x = direction * SPEED
		position2d.scale.x = -1  # Virar sprite horizontalmente
	elif Input.is_action_pressed("ui_right"):
		is_walking = true
		animation_player.play("walk")
		velocity.x = direction * SPEED
		position2d.scale.x = 1  # Virar sprite horizontalmente
	else:
		velocity.x = 0

	# Atualizar animações de andar
	if direction != 0:
		if direction < 0 and not facing_left:
			facing_left = true
		elif direction > 0 and facing_left:
			facing_left = false

		
	else:
		if is_walking:
			is_walking = false

	
	if not is_walking and is_on_floor() and velocity.y == 0:
		animation_player.play("idle")

	# Mover o personagem
	move_and_slide()
