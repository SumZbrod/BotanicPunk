class_name HurtAreaNode extends Area2D


signal damage_signal(hurt:float) 


func damage(hurt:float):
	damage_signal.emit(hurt)
