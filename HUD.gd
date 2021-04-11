extends CanvasLayer
#start_game 信号通知 Main 节点，按钮已经被按下。
signal start_game

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#当我们想要显示一条临时消息时，比如 Get Ready ，就会调用这个函数。
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

#当 Player 输掉时调用这个函数。它将显示 Game Over 2秒，然后返回标题屏幕并显示 Start 按钮。
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()

	#当您需要暂停片刻时，可以使用场景树的 create_timer() 函数替代使用 Timer 节点。
	#这对于延迟非常有用，例如在上述代码中，在这里我们需要在显示 开始 按钮前等待片刻。
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

#每当分数改变，这个函数会被 Main 调用。
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
