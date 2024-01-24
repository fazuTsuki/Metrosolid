extends Control

@export var player_stats: playerStats
#@export var enemy_stats: Enemy

enum enum_status {start, in_the_joke}
@export var joke_status: enum_status = enum_status.start

@export var queue_idea: Array[PlayerIdea]

@onready var set_up = $"PlayerPanel/HBoxContainer/ActionPanel/Actions/Set Up"
@onready var meander = $PlayerPanel/HBoxContainer/ActionPanel/Actions/Meander
@onready var punchline = $PlayerPanel/HBoxContainer/ActionPanel/Actions/Punchline

@onready var idea_container = $PlayerPanel/HBoxContainer/Textbox/IdeaContainer
@onready var log_data = $PlayerPanel/HBoxContainer/Textbox/LogData
@onready var action_panel = $PlayerPanel/HBoxContainer/ActionPanel
@onready var player_data = $PlayerPanel/HBoxContainer/Textbox/PlayerData

@onready var detail_panel = $DetailPanel
@onready var detail_text = $DetailPanel/DetailText


func _ready():
	set_up.pressed.connect(_on_button_see_idea.bind(set_up.name))
	meander.pressed.connect(_on_button_see_idea.bind(meander.name))
	punchline.pressed.connect(_on_button_see_idea.bind(punchline.name))
	player_turn()
	



func player_turn():
	if joke_status == enum_status.start:
		meander.disabled = true
		punchline.disabled = true
		set_up.disabled = false
	elif joke_status == enum_status.in_the_joke:
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
			current_box_container.add_child(button)
			idea_count += 1
	if idea_count % 2 == 0:
		current_box_container = HBoxContainer.new()
		current_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
		idea_container.add_child(current_box_container)
	var button_back = Button.new()
	button_back.name = "back"
	#button_back.flat = true
	button_back.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_back.text = "back"
	button_back.pressed.connect(back_to_first)
	current_box_container.add_child(button_back)

#run when using an idea
func use_idea(idea:PlayerIdea):
	match idea.type:
		idea_type.TYPE.SET_UP:
			joke_status = enum_status.in_the_joke
		idea_type.TYPE.MEANDER:
			show_idea(idea_type.TYPE.MEANDER)
		idea_type.TYPE.PUNCH_LINE:
			joke_status = enum_status.start

func back_to_first():
	detail_panel.visible = false
	player_data.visible = true
	idea_container.visible = false
	log_data.visible = true
	action_panel.visible = true
	for child in idea_container.get_children():
		child.queue_free()

#when hovering to the idea button
func idea_hover_in(idea:PlayerIdea):
	detail_text.text = "test " + idea.name

#when hovering out of the idea button
func idea_hover_out():
	detail_text.text = ""

func insert_queue_idea(idea: PlayerIdea):
	queue_idea.append(idea)
	
func empty_queue_idea():
	queue_idea.clear()
