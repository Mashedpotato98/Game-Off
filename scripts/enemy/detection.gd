extends Area3D

signal detection_entered(entity:CollisionObject3D)
signal detection_exited

var entities = []

@onready var wall_detector = $WallDetector

func _process(_delta:float):
	if not wall_detector.enabled:
		return

	for entity in get_overlapping_bodies():
		wall_detector.target_position = to_local(entity.global_position)
		wall_detector.force_raycast_update()

		var hit:bool = wall_detector.is_colliding()
		if not hit:
			if not entities.has(entity):
				see(entity)
		elif entities.has(entity):
			lose(entity)

func see(entity:Node3D):
	entities.append(entity)
	detection_entered.emit(entity)

func lose(entity:Node3D):
	entities.erase(entity)
	detection_exited.emit()

func _on_body_entered(_body:Node3D):
	wall_detector.enabled = true

func _on_body_exited(body:Node3D):
	if get_overlapping_bodies().size() <= 0:
		wall_detector.enabled = false
	if entities.has(body):
		lose(body)
