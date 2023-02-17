extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mousepos = Vector2.ZERO
var texture = ImageTexture.new()
var curve = Curve2D.new()
var click = false
var ready_process = true
export var curves = []

var remote_curves = {}

var image = Image.new()

signal curve_done(curve)
signal curve_clear()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Replace with function body.
	image.load("res://icon.png")
	texture.create_from_image(image)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(ready_process):
		if Input.is_action_pressed("click"):
			click = true
		if(click):
			mousepos = get_viewport().get_mouse_position()
			curve.add_point(mousepos)
		if Input.is_action_just_released("click"): # 松开，bao
			click = false
			curves.append(curve.get_baked_points())
			
			emit_signal("curve_done", curve.get_baked_points())

			curve = Curve2D.new()
	update()
	
func _draw():
	get_canvas_item()
	for c in curves:
		draw_polyline(c, Color.cadetblue, 2.0)
	
	var point_pool = curve.get_baked_points()
	if(len(point_pool) >= 2):
		draw_polyline(point_pool, Color.burlywood , 3.0)
	
	for i in remote_curves:
		for c in remote_curves[i]:
			draw_polyline(c, Color.chocolate , 2.0)
	


func _on_Button_pressed():
	click = false
	curves.clear()
	emit_signal("curve_clear")

func _on_Button_mouse_entered():
	ready_process = false

func _on_Button_mouse_exited():
	ready_process = true

func _on_LobbyPanel_new_id(id):
	remote_curves[id] = []

func _on_LobbyPanel_new_curve(id, curve):
	remote_curves[id].append(curve)

func _on_LobbyPanel_clear_curve(id):
	remote_curves[id] = []
