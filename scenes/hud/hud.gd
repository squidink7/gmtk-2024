extends CanvasLayer

var score = 0
var high_score = 0

signal new_highscore(score: int)

func set_score(new_score: int):
	score = new_score
	$scorelabel.text = 'Score: ' + str(score)

	if score > high_score:
		high_score = score
		new_highscore.emit(score)

func add_score(new_score: int):
	score += new_score
	$scorelabel.text = 'Score: ' + str(score)

func set_time(time: int):
	$timelabel.text = 'Time: ' + str(int(time/60)) + ':' + str(time%60)
