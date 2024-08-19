extends CanvasLayer

var score = 0

func set_score(new_score: int):
	score = new_score
	$scorelabel.text = 'Score: ' + str(score)

func add_score(new_score: int):
	score += new_score
	$scorelabel.text = 'Score: ' + str(score)

func set_time(time: int):
	$timelabel.text = 'Time: ' + str(int(time/60)) + ':' + str(time%60)
