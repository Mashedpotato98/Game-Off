extends Node
class_name  state_machine

signal Transitioned(state,new_state_name,extra_args)

func Enter(_args:Array):
	pass

func Exit():
	pass

func update(_delta:float):
	pass

func Physics_update(_delta:float):
	pass
