extends CanvasLayer

var score = 0
var high_score = 0

signal new_highscore(score: int)

func set_score(new_score: int):
	score = new_score
	$scorelabel.text = 'Score: ' + str(score)

	if score > high_score:
		set_highscore(high_score)
		new_highscore.emit(score)

func add_score(new_score: int):
	score += new_score
	set_score(score)

func set_time(time: int):
	$timelabel.text = 'Time: ' + str(int(time/60)) + ':' + str(time%60)

func set_highscore(score: int):
	high_score = score
	$highscorelabel.text = 'Hi Score: ' + str(score)
