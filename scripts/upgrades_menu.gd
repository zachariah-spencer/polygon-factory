extends Control

signal upgrade_purchased(num : int)

@onready var upgrade_1 := $CenterContainer/VBoxContainer/TabContainer/Upgrade1
@onready var upgrade_1_description := $CenterContainer/VBoxContainer/TabContainer/Upgrade1/VerticalList/Description
@onready var upgrade_1_cost_label := $CenterContainer/VBoxContainer/TabContainer/Upgrade1/VerticalList/Cost
@onready var upgrade_1_button := $CenterContainer/VBoxContainer/TabContainer/Upgrade1/Upgrade1Button

@onready var upgrade_2 := $CenterContainer/VBoxContainer/TabContainer/Upgrade2
@onready var upgrade_2_description := $CenterContainer/VBoxContainer/TabContainer/Upgrade2/VerticalList/Description
@onready var upgrade_2_cost_label := $CenterContainer/VBoxContainer/TabContainer/Upgrade2/VerticalList/Cost
@onready var upgrade_2_button := $CenterContainer/VBoxContainer/TabContainer/Upgrade2/Upgrade2Button

@onready var upgrade_3 := $CenterContainer/VBoxContainer/TabContainer/Upgrade3
@onready var upgrade_3_description := $CenterContainer/VBoxContainer/TabContainer/Upgrade3/VerticalList/Description
@onready var upgrade_3_cost_label := $CenterContainer/VBoxContainer/TabContainer/Upgrade3/VerticalList/Cost
@onready var upgrade_3_button := $CenterContainer/VBoxContainer/TabContainer/Upgrade3/Upgrade3Button

@onready var price_notif_timer_1 := $PriceNotificationTimer1
@onready var price_notif_timer_2 := $PriceNotificationTimer2
@onready var price_notif_timer_3 := $PriceNotificationTimer3

@onready var ui_audio_manager := $UIAudioManager

var upgrade_1_cost : int
var upgrade_2_cost : int
var upgrade_3_cost : int

func _ready() -> void:
	modulate.a = 0.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate', Color.WHITE, 0.2)

func load_menu_options(upgrade_1_info, upgrade_2_info, upgrade_3_info):
	if upgrade_1_info[0]:
		upgrade_1.name = upgrade_1_info[1]
		upgrade_1_description.text = upgrade_1_info[2]
		upgrade_1_cost = upgrade_1_info[3]
		upgrade_1_cost_label.text = 'Cost - ' + str(upgrade_1_cost) + ' Polygons'
	else:
		upgrade_1.queue_free()
	
	if upgrade_2_info[0]:
		upgrade_2.name = upgrade_2_info[1]
		upgrade_2_description.text = upgrade_2_info[2]
		upgrade_2_cost = upgrade_2_info[3]
		upgrade_2_cost_label.text = 'Cost - ' + str(upgrade_2_cost) + ' Polygons'
	else:
		upgrade_2.queue_free()
	
	if upgrade_3_info[0]:
		upgrade_3.name = upgrade_3_info[1]
		upgrade_3_description.text = upgrade_3_info[2]
		upgrade_3_cost = upgrade_3_info[3]
		upgrade_3_cost_label.text = 'Cost - ' + str(upgrade_3_cost) + ' Polygons'
	else:
		upgrade_3.queue_free()

func update_purchased_upgrades(upgrades_purchased):
	await get_parent().get_parent().get_parent().ready
	if upgrades_purchased[1]:
		_set_upgrade_purchased(1)
	
	if upgrades_purchased[2]:
		_set_upgrade_purchased(2)
	
	if upgrades_purchased[3]:
		_set_upgrade_purchased(3)

func _set_upgrade_purchased(upgrade_index : int):
	match(upgrade_index):
		1:
			upgrade_1_cost_label.text = ''
			upgrade_1_button.text = 'Purchased'
			upgrade_1_button.disabled = true
		2:
			upgrade_2_cost_label.text = ''
			upgrade_2_button.text = 'Purchased'
			upgrade_2_button.disabled = true
		3:
			upgrade_3_cost_label.text = ''
			upgrade_3_button.text = 'Purchased'
			upgrade_3_button.disabled = true

func _on_upgrade_1_button_pressed() -> void:
	if upgrade_1_cost <= Stats.current_polygons:
		ui_audio_manager.play_tone_1()
		Stats.subtract_polygon(upgrade_1_cost) 
		_set_upgrade_purchased(1)
		
		upgrade_purchased.emit(1)
	else:
		ui_audio_manager.play_tone_2()
		upgrade_1_button.text = 'Not Enough Polygons'
		price_notif_timer_1.start()

func _on_upgrade_2_button_pressed() -> void:
	if upgrade_2_cost <= Stats.current_polygons:
		ui_audio_manager.play_tone_1()
		Stats.subtract_polygon(upgrade_2_cost) 
		_set_upgrade_purchased(2)
		
		upgrade_purchased.emit(2)
	else:
		ui_audio_manager.play_tone_2()
		upgrade_2_button.text = 'Not Enough Polygons'
		price_notif_timer_2.start()

func _on_upgrade_3_button_pressed() -> void:
	if upgrade_3_cost <= Stats.current_polygons:
		ui_audio_manager.play_tone_1()
		Stats.subtract_polygon(upgrade_3_cost) 
		_set_upgrade_purchased(3)
		
		upgrade_purchased.emit(3)
	else:
		ui_audio_manager.play_tone_2()
		upgrade_3_button.text = 'Not Enough Polygons'
		price_notif_timer_3.start()

func _on_price_notification_timer_1_timeout() -> void:
	upgrade_1_button.text = 'Purchase'

func _on_price_notification_timer_2_timeout() -> void:
	upgrade_2_button.text = 'Purchase'

func _on_price_notification_timer_3_timeout() -> void:
	upgrade_3_button.text = 'Purchase'

func _on_tab_container_tab_hovered(_tab: int) -> void:
	if ui_audio_manager:
		ui_audio_manager.play_click()

func _on_tab_container_tab_changed(_tab: int) -> void:
	if ui_audio_manager:
		ui_audio_manager.play_low_click()

func _on_upgrade_1_button_mouse_entered() -> void:
	ui_audio_manager.play_click()

func _on_upgrade_2_button_mouse_entered() -> void:
	ui_audio_manager.play_click()

func _on_upgrade_3_button_mouse_entered() -> void:
	ui_audio_manager.play_click()
