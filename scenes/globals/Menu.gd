extends Control


func _on_Close_Menu_Button_button_up():
	GUI.open_hud()


func _on_Save_Button_button_up():
	Global.save_data()


func _on_Load_Button_button_up():
	Global.load_data()
