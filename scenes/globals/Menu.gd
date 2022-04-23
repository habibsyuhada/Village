extends Control


signal _on_Close_Menu_Button_button_up()

func _on_Close_Menu_Button_button_up():
	emit_signal("_on_Close_Menu_Button_button_up")


func _on_Save_Button_button_up():
	Global.save_data()


func _on_Load_Button_button_up():
	pass # Replace with function body.
