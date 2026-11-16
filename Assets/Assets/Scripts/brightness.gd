extends HSlider



func _on_value_changed(value: float) -> void:
	WorldEnvironmentGlobal.environment.adjustment_brightness = value
