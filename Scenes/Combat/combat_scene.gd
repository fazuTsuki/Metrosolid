##this script is only used for the UI for the combat
##this script shouldn't or partially should be controlling the games combat logic
class_name CombatScene
extends Control

@export var player_stats: playerStats
@export var enemy_stats: EnemyStats


@onready var set_up = $"PlayerPanel/HBoxContainer/ActionPanel/Actions/Set Up"
@onready var meander = $PlayerPanel/HBoxContainer/ActionPanel/Actions/Meander
@onready var punchline = $PlayerPanel/HBoxContainer/ActionPanel/Actions/Punchline

@onready var enemy_happy_point_progress_bar = $EnemyContainer/HappyPointProgressBar
@onready var enemy_happy_point_progress_bar_label = $EnemyContainer/HappyPointProgressBar/Label
@onready var enemy_engagement_progress_bar = $EnemyContainer/EngagementProgressBar
@onready var enemy_engagement_progress_bar_label = $EnemyContainer/EngagementProgressBar/Label

@onready var player_happy_point_progress_bar = $PlayerPanel/HBoxContainer/Textbox/PlayerData/HPProgressBar
@onready var player_happy_point_progress_bar_label = $PlayerPanel/HBoxContainer/Textbox/PlayerData/HPProgressBar/Label
@onready var player_act_label = $PlayerPanel/HBoxContainer/Textbox/PlayerData/Label


@onready var idea_container = $PlayerPanel/HBoxContainer/Textbox/IdeaContainer
@onready var log_data = $PlayerPanel/HBoxContainer/Textbox/LogData
@onready var action_panel = $PlayerPanel/HBoxContainer/ActionPanel
@onready var player_data = $PlayerPanel/HBoxContainer/Textbox/PlayerData

@onready var detail_panel = $DetailPanel
@onready var detail_text = $DetailPanel/DetailText

@onready var combat_manager_:combat_manager = $CombatManager

func _ready():
	player_stats.reset_act()
	set_up.pressed.connect(_on_button_see_idea.bind(set_up.name))
	meander.pressed.connect(_on_button_see_idea.bind(meander.name))
	punchline.pressed.connect(_on_button_see_idea.bind(punchline.name))
	enemy_stats.engagement.points_added.connect(add_log.bind("npc increased engagement"))
	enemy_stats.engagement.points_deducted.connect(add_log.bind("npc decreased engagement"))
	enemy_stats.happy_points.points_added.connect(add_log.bind("npc increased hp"))
	enemy_stats.happy_points.points_deducted.connect(add_log.bind("npc decreased hp"))
	enemy_happy_point_progress_bar.max_value = enemy_stats.happy_points.max_points
	enemy_engagement_progress_bar.max_value = enemy_stats.engagement.max_points
	player_happy_point_progress_bar.max_value = player_stats.happy_points.max_points
	update_player_stats()
	player_turn()
	update_enemy_stats()

func show_log():
	player_data.visible = false
	log_data.visible = true
	idea_container.visible = false
	action_panel.visible = false
	detail_panel.visible = false



func update_enemy_stats():
	enemy_engagement_progress_bar_label.text = "EG: "+str(int(enemy_stats.engagement.current_points))+"/"+str(enemy_stats.engagement.max_points)
	enemy_happy_point_progress_bar_label.text = "HP: "+str(int(enemy_stats.happy_points.current_points))+"/"+str(enemy_stats.happy_points.max_points)
	enemy_happy_point_progress_bar.value = enemy_stats.happy_points.current_points
	enemy_engagement_progress_bar.value = enemy_stats.engagement.current_points

func update_player_stats():
	player_happy_point_progress_bar.value = player_stats.happy_points.current_points
	player_happy_point_progress_bar_label.text = "HP: "+str(int(player_stats.happy_points.current_points))+"/"+str(player_stats.happy_points.max_points)
	player_act_label.text = "ACT: "+str(player_stats.act)

func player_turn():
	if combat_manager_.joke_status == combat_manager_.enum_status.start:
		meander.disabled = true
		punchline.disabled = true
		set_up.disabled = false
	elif combat_manager_.joke_status == combat_manager_.enum_status.in_the_joke:
		meander.disabled = false
		punchline.disabled = false
		set_up.disabled = true

func _on_button_see_idea(type_of_idea):
	player_data.visible = false
	idea_container.visible = true
	log_data.visible = false
	action_panel.visible = false
	detail_panel.visible = true
	match type_of_idea:
		set_up.name:
			show_idea(idea_type.TYPE.SET_UP)
		meander.name:
			show_idea(idea_type.TYPE.MEANDER)
		punchline.name:
			show_idea(idea_type.TYPE.PUNCH_LINE)

#show the ideas in ui
func show_idea(type_of_idea):
	var idea_count: int = 0
	var current_box_container: HBoxContainer
	for idea in player_stats.ideas:
		if idea.type == type_of_idea:
			if idea_count % 2 == 0:
				current_box_container = HBoxContainer.new()
				current_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
				idea_container.add_child(current_box_container)
			var button = Button.new()
			button.name = idea.name
			#button.flat = true
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.text = idea.name
			button.mouse_entered.connect(idea_hover_in.bind(idea))
			button.mouse_exited.connect(idea_hover_out)
			button.pressed.connect(use_idea.bind(idea))
			current_box_container.add_child(button)
			idea_count += 1
	if idea_count % 2 == 0:
		current_box_container = HBoxContainer.new()
		current_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
		idea_container.add_child(current_box_container)
	var button_back = Button.new()
	button_back.name = "back"
	button_back.flat = true
	button_back.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_back.text = "back"
	button_back.pressed.connect(back_to_first)
	current_box_container.add_child(button_back)

#run when using an idea
func use_idea(idea:PlayerIdea):
	
	player_stats.act -= 1
	match idea.type:
		idea_type.TYPE.SET_UP:
			combat_manager_.set_up(player_stats,idea,enemy_stats)
			combat_manager_.joke_status = combat_manager_.enum_status.in_the_joke
		idea_type.TYPE.MEANDER:
			combat_manager_.meander(player_stats,idea,enemy_stats)
		idea_type.TYPE.PUNCH_LINE:
			combat_manager_.punchline(player_stats,idea,enemy_stats)
			combat_manager_.joke_status = combat_manager_.enum_status.start
	update_enemy_stats()
	update_player_stats()
	player_turn()
	show_log()
	await get_tree().create_timer(2)
	back_to_first()

func add_log(value,from:String):
	var log = Label.new()
	var array_from = from.split(" ")
	log.text = array_from[0] + "'s " + array_from[2] + " " + array_from[1] + " by " + str(value)
	log_data.add_child(log)

func back_to_first():
	detail_panel.visible = false
	player_data.visible = true
	idea_container.visible = false
	log_data.visible = false
	action_panel.visible = true
	for child in idea_container.get_children():
		child.queue_free()

#when hovering to the idea button
func idea_hover_in(idea:PlayerIdea):
	detail_text.text = "test " + idea.name

#when hovering out of the idea button
func idea_hover_out():
	detail_text.text = ""

func load_player_stats(new_player_stats : playerStats) -> void : player_stats = new_player_stats
