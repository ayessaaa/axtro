 #extends Area2D
#
#
#func _process(delta: float) -> void:
	#if position.x < -200:
		#queue_free()
#
#func _on_area_entered(area: Area2D) -> void:
	#if Global.is_angle_dash:
		#if area.player:
			#print("brush")
