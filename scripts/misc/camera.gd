extends Camera2D

var _target_zoom: float = 1.0
var _target_position: Vector2 = Vector2(0, 0)

const MAX_ZOOM: float = 3.0
const MIN_ZOOM: float = 0.6
const ZOOM_INCREMENT: float = 0.2
const ZOOM_RATE: float = 8.0
const TRANSLATE_RATE: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		_target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)

	position = lerp(
		position,
		_target_position,
		TRANSLATE_RATE * delta
	)

	set_physics_process(
		not is_equal_approx(zoom.x, _target_zoom) or position != _target_position
	)

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_O:
			_target_position = Vector2(0, 0)
			set_physics_process(true)

	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position.x = max(min(
					position.x - (event.relative.x / zoom.x),
					5000
				),
				-5000
			)
			position.y = max(min(
					position.y - (event.relative.y / zoom.y),
					5000
				),
				-5000
			)

			_target_position = position

	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

	elif event is InputEventMagnifyGesture:
		if event.factor < 1:
			zoom_in()
		elif event.factor > 1:
			zoom_out()
