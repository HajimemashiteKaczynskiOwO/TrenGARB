extends Label


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))


func _on_talk_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Talk"), linear_to_db(value))
	AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Talk"))
