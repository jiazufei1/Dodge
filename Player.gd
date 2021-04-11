extends Area2D


signal hit # 这定义了一个称为 hit 的自定义信号，当 Player 与敌人碰撞时，
#我们将使其 Player 发射（发出）信号。我们将使用 Area2D 来检测碰撞。
#选择 Player 节点，然后点击属性检查器选项卡旁边的“节点”选项卡，以查看 Player 可以发出的信号列表：
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.


func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
	#如果在引擎的碰撞处理过程中发生，禁用区域的碰撞形状可能会导致错误。
	#使用``set_delayed()``告诉Godot等待禁用该形状，直到可以安全地这样做为止。
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
#我们首先将 velocity（速度） 设置为 (0, 0)——默认情况下玩家不应该移动。然后我们检查每个输入并从 velocity（速度）
#中进行加/减以获得总方向。例如，如果您同时按住 right（向右） 和 down（向下），则生成的 velocity（速度） 速度将为 (1, 1)。
#在这种情况下，由于我们同时向水平和垂直两个方向进行移动，因此玩家斜向移动的速度将会比水平移动要 更快。
#只要对速度进行 归一化（normalize），就可以防止这种情况，也就是将速度的 长度（length） 设置为 1 ，然后乘以想要的速度。
#这样就不会有过快的斜向运动了。
func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation	 = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
	


func _on_Player_body_entered(body):
	hide()  # Player disappears after being hit.
	#敌人每次击中 Player 时，都会发出一个信号。我们需要禁用 Player 的碰撞检测，确保我们不会多次触发 hit 信号。
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
