extends Node
#实例化的 Mob 场景。
export (PackedScene) var Mob
var score
func _ready():
	randomize()
	#new_game()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group('mobs','queue_free')
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

#在 _on_MobTimer_timeout() 中，我们将创建一个 mob 实例，
#沿着 Path2D 随机选择一个起始位置，然后让 mob 移动。PathFollow2D 节点将沿路径移动，
#因此会自动旋转，所以我们将使用它来选择怪物的方向及其位置。
func _on_MobTimer_timeout():
	 # Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# 为什么使用 PI ？在需要角度的函数中，GDScript使用 弧度，而不是角度。
	#如果您更喜欢使用角度，则需要使用 deg2rad() 和 rad2deg() 函数在角度和弧度之间进行转换。
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
