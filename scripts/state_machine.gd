extends Node3D

@export var initial_state: state_machine

var current_state: state_machine
var states = {}

func _ready():
	for child in get_children():
		if child is state_machine:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter([])
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_update(delta)

func on_child_transition(state,new_state_name,extra_args):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.Exit()
		new_state.Enter(extra_args)
		current_state = new_state
