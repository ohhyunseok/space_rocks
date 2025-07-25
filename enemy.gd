extends Area2D

@export var bullet_scene : PackedScene
@export var speed = 150
@export var rotation_speed = 120
@export var health = 3
@export var bulluet_spread = 0.2

var follow = PathFollow2D.new()
var target = null

func _ready():
	$Sprite2D.frame = randi() % 3
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
	follow.loop = false

func _physics_process(delta: float) -> void:
	rotation += deg_to_rad(rotation_speed) * delta
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()

func shoot():
	var dir = global_position.direction_to(target.global_position)
	dir = dir.rotated(randf_range(-bulluet_spread, bulluet_spread))
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.start(global_position, dir)


func _on_gun_cooldown_timeout() -> void:
	shoot_pulse(3, 0.15)

func shoot_pulse(n, delay):
	for i in n:
		shoot()
		await get_tree().create_timer(delay).timeout
